/*
 * This file is part of Connect4 Game Solver <http://connect4.gamesolver.org>
 * Copyright (C) 2017-2019 Pascal Pons <contact@gamesolver.org>
 *
 * Connect4 Game Solver is free software: you can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * Connect4 Game Solver is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with Connect4 Game Solver. If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef MOVE_CHOOSER_HPP
#define MOVE_CHOOSER_HPP

#include <climits>
#include <cstdlib> // for std::rand() and std::srand()

#include "Position.hpp"

namespace GameSolver {
namespace Connect4 {

/**
 * This class helps choosing the best move
 *
 * You have to add moves first with their score
 * then you can get the best move back.
 * If more than one move have the same score the class choose randomly one.
 */
class MoveChooser {
public:

    /**
     * Add a move in the container with its score.
     * You cannot add more than Position::WIDTH moves
     */
    void add(uint64_t move, int mscore) {
        if (mscore < score) return;

        if (mscore > score) {
            score = mscore;
            size = 0; // drop old moves
        }

        int pos = size++;
        entries[pos] = move;
    }

    /**
     * Get the best move
     * @return the best move, if more than one move have the same score the class choose randomly one.
     * If no move is available return 0
     */
    uint64_t getBestMove() {
        if(size) {
            static constexpr double fraction { 1.0 / (RAND_MAX + 1.0) };
            int pos = static_cast<int>(size * (std::rand() * fraction));
            return entries[pos];
        } else
            return 0;
    }

    /**
     * @return the current best score
     */
    int getBestScore() {
        return score;
    }

    /**
     * reset (empty) the container
     */
    void reset() {
        size = 0;
        score = INT_MIN;
    }

    /**
     * Build an empty container
     */
    MoveChooser(): size{0}, score{INT_MIN} {
    }

private:
    // number of stored moves
    unsigned int size;
    // current best score
    int score;

    // Contains size moves with the current best score
    uint64_t entries[Position::WIDTH];
};

} // namespace Connect4
} // namespace GameSolver
#endif
