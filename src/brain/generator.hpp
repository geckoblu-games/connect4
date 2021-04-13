#include "Position.hpp"
#include "OpeningBook.hpp"

#include <iostream>
#include <string>
#include <unordered_set>

#include "Solver.hpp"

using namespace GameSolver::Connect4;

std::unordered_set<uint64_t> visited;

static constexpr int BOOK_SIZE = 14; // store 2^BOOK_SIZE positions in the book
static constexpr int DEPTH = 6;     // max depth of evry position to be stored
static constexpr double LOG_3 = 1.58496250072; // log2(3)

/**
 * Explore and print all possible position under a given depth.
 * symetric positions are printed only once.
 */
void explore(const Position &P, char* pos_str, const int depth, TranspositionTable<uint_t<int((DEPTH + Position::WIDTH -1) * LOG_3) + 1 - BOOK_SIZE>, uint8_t, BOOK_SIZE> *table, Solver *solver) {
  uint64_t key = P.key3();
  if(visited.count(key)) return;  // already explored position
  visited.insert(key);            // flag new position as visited

  int score = solver->solve(P);

  std::cout << pos_str << ' ' << score << std::endl;

  table->put(P.key3(), score - Position::MIN_SCORE + 1);

  int nb_moves = P.nbMoves();
  if(nb_moves >= depth) return;  // do not explore at further depth

  for(int i = 0; i < Position::WIDTH; i++) // explore all possible moves
    if(P.canPlay(i) && !P.isWinningMove(i)) {
      Position P2(P);
      P2.playCol(i);
      pos_str[nb_moves] = '0' + i;
      explore(P2, pos_str, depth, table, solver);
      pos_str[nb_moves] = 0;
    }
}

/**
 * Read scored positions from stdin and store them in an opening book
 */
void generate_opening_book() {

  TranspositionTable<uint_t<int((DEPTH + Position::WIDTH -1) * LOG_3) + 1 - BOOK_SIZE>, uint8_t, BOOK_SIZE> *table =
    new TranspositionTable<uint_t<int((DEPTH + Position::WIDTH -1) * LOG_3) + 1 - BOOK_SIZE>, uint8_t, BOOK_SIZE>();

  Solver solver;
  solver.loadBook("/usr/share/connect4/7x6.book");

  char pos_str[DEPTH + 1] = {0};
  explore(Position(), pos_str, DEPTH, table, &solver);

//  std::string pos;
//  int score;
//  while(getline(std::cin, pos, ' ')) {
//    std::cin >> score;
//    static long long count = 0;
//    if(++count % 1000000 == 0)
//      std::cout << count << std::endl;
//    Position P;
//    //P.play(pos);
//    table->put(P.key3(), score - Position::MIN_SCORE + 1);
//    getline(std::cin, pos);
//  }

 OpeningBook book{
    Position::WIDTH,
    Position::HEIGHT,
    DEPTH,
    table
  };
  book.save("7x6_mini.book");
}

/**
 * If used with a max depth parameter: generate all uniquepsoition upto max depth
 * If no parameter: read scoredposition from standard input to store in an opening book
 */
int main_generator(int , char** ) {
//  //if(argc > 1) {
//    int depth = 6; //atoi(argv[1]);
//    char pos_str[7] = {0};
//    explore(Position(), pos_str, depth);
//  //} else
    generate_opening_book();

    return 0;
}
