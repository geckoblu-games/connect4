#ifndef GAMEMODEL_H
#define GAMEMODEL_H

#include <QJsonArray>
#include <QJsonObject>
#include <QObject>
#include <QVariant>

// include custom classes
#include "brain/Move.hpp"
#include "brain/Position.hpp"
#include "brain/Solver.hpp"
#include "levelclass.hpp"

using namespace GameSolver::Connect4;

class GameModel : public QObject {
  Q_OBJECT
  // Q_PROPERTY(int counter READ counter WRITE setCounter NOTIFY counterChanged)
  // // this makes counter available as a QML property

public:
  static const int COLUMNS = Position::WIDTH; // Width of the board
  static const int ROWS = Position::HEIGHT;   // Height of the board

  GameModel();

public slots: // slots are public methods available in QML

  /**
   * Start a new game
   */
  void newGame();

  /**
   * Indicates whether a column is playable.
   * @param column: 0-based index of column to play
   * @return true if the column is playable, false if the column is already
   * full.
   */
  bool canPlay(int column);

  /**
   * Plays a playable column.
   * This function should not be called on a non-playable column or a column
   * making an alignment.
   *
   * @param column: 0-based index of a playable column.
   * @return the height of the play or -1 if the column is not playable
   */
  int play(int column);

  /**
   * Return the last player
   * @return 1 first player, 2 second player
   */
  int lastPlayer();

  /**
   * Ask the model to choose a move to play.
   * The call is asyncronous, the method returns immediately, when the model has
   * choosen a move a signal moveChoosed is emited.
   */
  void chooseMove();

  /**
   * Return the current winner
   * @return -1 nobody wins, 0 drawn (no more moves), 1 first player wins, 2
   * second player wins
   */
  int whoWin();

  /**
   * Return the alignment which cause the player victory.
   * Should be called only after a winnig position exists.
   * Is possible that more than a winning position exists,
   * in that case the method returns the first found.
   *
   * @return an array of 4 aligned moves.
   */
  QVariantList getWinningPosition();

  /**
   * Set the level of AI
   * @param level
   */
  void setLevel(Level level);

signals:
  /**
   * Emited when the model has choosed wich move to play, after a call to
   * chooseMove. QVariant will contain a move in JSon format.
   */
  void moveChoosed(QVariant);

private:
  Position board;
  Solver solver;
  int depth;

  Move chooseMove_blocking();
};

#endif // GAMEMODEL_H
