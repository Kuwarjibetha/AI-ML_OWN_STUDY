#include <iostream>
#include <vector>

using namespace std;

// Function prototypes
void displayBoard(const vector<vector<char>>& board);
bool makeMove(vector<vector<char>>& board, char player, int position);
bool checkWin(const vector<vector<char>>& board, char player);
bool checkDraw(const vector<vector<char>>& board);

int main() {
    vector<vector<char>> board(3, vector<char>(3, ' ')); // 3x3 game board
    char currentPlayer = 'X';
    int position;

    do {
        displayBoard(board);

        cout << "Player " << currentPlayer << ", enter your move (1-9): ";
        cin >> position;

        if (position >= 1 && position <= 9) {
            if (makeMove(board, currentPlayer, position)) {
                if (checkWin(board, currentPlayer)) {
                    displayBoard(board);
                    cout << "Player " << currentPlayer << " wins!" << endl;
                    break;
                } else if (checkDraw(board)) {
                    displayBoard(board);
                    cout << "The game is a draw." << endl;
                    break;
                } else {
                    currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
                }
            } else {
                cout << "Invalid move. Try again." << endl;
            }
        } else {
            cout << "Invalid position. Enter a number between 1 and 9." << endl;
        }

    } while (true);

    return 0;
}

void displayBoard(const vector<vector<char>>& board) {
    cout << "-------------" << endl;
    for (int i = 0; i < 3; ++i) {
        cout << "| ";
        for (int j = 0; j < 3; ++j) {
            cout << board[i][j] << " | ";
        }
        cout << endl << "-------------" << endl;
    }
}

bool makeMove(vector<vector<char>>& board, char player, int position) {
    int row = (position - 1) / 3;
    int col = (position - 1) % 3;

    if (board[row][col] == ' ') {
        board[row][col] = player;
        return true;
    }
    return false;
}

bool checkWin(const vector<vector<char>>& board, char player) {
    for (int i = 0; i < 3; ++i) {
        if ((board[i][0] == player && board[i][1] == player && board[i][2] == player) ||
            (board[0][i] == player && board[1][i] == player && board[2][i] == player)) {
            return true;
        }
    }
    if ((board[0][0] == player && board[1][1] == player && board[2][2] == player) ||
        (board[0][2] == player && board[1][1] == player && board[2][0] == player)) {
        return true;
    }
    return false;
}

bool checkDraw(const vector<vector<char>>& board) {
    for (const auto& row : board) {
        for (char cell : row) {
            if (cell == ' ') {
                return false;
            }
        }
    }
    return true;
}