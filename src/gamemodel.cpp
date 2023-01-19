#include "gamemodel.hpp"

#include <QDebug>
#include <QtConcurrent>
#include <chrono>
#include <thread>

GameModel::GameModel() {
  // perform custom initialization steps here
}

void GameModel::newGame() {
  qDebug() << "GameModel newGame";

  board = Position();
}

bool GameModel::canPlay(int column) {
  // qDebug() << "GameModel canPlay " << column;

  if (column < 0 || column > COLUMNS) {
    return false;
  }

  return board.canPlay(column);
}

int GameModel::play(int column) {
  if (!canPlay(column)) {
    return -1;
  }

  return board.playCol(column);
}

int GameModel::lastPlayer() { return board.lastPlayer(); }

void GameModel::chooseMove() {

  auto *watcher = new QFutureWatcher<Move>(this);

  watcher->setFuture(QtConcurrent::run(&GameModel::chooseMove_blocking, this));

  QObject::connect(watcher, &QFutureWatcher<Move>::finished, this,
                   [this, watcher]() {
                     Move move = watcher->result();
                     emit moveChoosed(move.toJSon());
                     watcher->deleteLater();
                   });
}

Move GameModel::chooseMove_blocking() {
  // qDebug() << "GameModel chooseMove ";

  // int columns[]{3, 2, 4, 1, 5, 0, 6};
  // int column = -1;
  //
  // for(int i = 0; i < 7; i++) {
  //     //qDebug() << "i: " << i << " columns[i]: " << columns[i] << " canPlay:
  //     " << canPlay(columns[i]); if (canPlay(columns[i])) {
  //         column = columns[i];
  //         break;
  //     }
  // }
  // std::this_thread::sleep_for(std::chrono::milliseconds(100));

  qDebug() << "going to sleep";
  int column = solver.getBestMove(board, depth);
  qDebug() << "awake";

  int row = play(column);
  // qDebug() << "column: " << column << " row: " << row;

  return Move{column, row};
}

int GameModel::whoWin() { return board.whoWin(); }

QVariantList GameModel::getWinningPosition() {
  QVariantList moves{};

  std::array<Move, Position::FOUR> arr = board.getWinningPosition();

  for (Move move : arr) {
    moves.append(move.toJSon());
  }

  return moves;
}

void GameModel::setLevel(Level level) {
  // std::cerr << "setLevel " << level << "\n";

  switch (level) {
  case Level::Easy:
    solver.clearBook();
    depth = 4;
    break;
  case Level::Normal:
    solver.loadBook("7x6_mini.book");
    depth = 40;
    break;
  case Level::Hard:
    solver.loadBook("7x6_small.book");
    depth = 20;
    break;
  case Level::Expert:
    solver.loadBook("7x6.book");
    depth = -1;
    break;
  default:
    assert(false && "Undefined level");
  }
}
