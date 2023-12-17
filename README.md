# Abalone Game

Abalone is an abstract strategy board game designed for two players. The game is played on a hexagonal board consisting of 61 circular spaces arranged in a hexagon. Each player has 14 marbles that are initially arranged in a triangular pattern at one end of the board. The objective of the game is to push your opponent's marbles off the board.

# Rules

    Players can move their marbles in straight lines or push the opponent's marbles if they have more marbles in the line.
    A player can move one, two, or three marbles at a time.
    Diagonal moves are not allowed.
    The player wins by pushing six or more of the opponent's marbles off the board.

# Abalone AI Project

This project implements an Abalone game where two AI players compete against each other. The following features are incorporated into the implementation:
# Minimax Algorithm

The AI players use the Minimax algorithm to make strategic decisions. Minimax explores all possible moves to find the optimal one for maximizing its own score and minimizing the opponent's score.
# Alpha-Beta Pruning

Building upon Minimax, the implementation includes Alpha-Beta Pruning, a technique that reduces the number of nodes evaluated by the minimax algorithm.
# Evaluation Function

A customized evaluation function is implemented to determine the desirability of a particular game state. This function helps in deciding which paths to explore further during the search.
# Forward Pruning with Beam Search Algorithm

Forward pruning is employed along with the Beam Search algorithm to trim unpromising branches early in the search, improving the efficiency of the AI decision-making process.
# Transposition Table

To avoid redundant calculations and repetitions, a transposition table is implemented. This table stores previously evaluated positions, preventing the AI from re-evaluating the same game state.

Feel free to clone the repository and explore the intricacies of this Abalone AI implementation! If you have any questions or suggestions, don't hesitate to reach out.
