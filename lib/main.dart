import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToe());
}

class TicTacToe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TicTacToeGame(),
    );
  }
}

class TicTacToeGame extends StatefulWidget {
  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  List<List<String>> _board = [];
  bool _isPlayer1Turn = true;
  String? _winner;

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  void _initializeBoard() {
    _board = List.generate(3, (_) => List.filled(3, ''));
    _isPlayer1Turn = true;
    _winner = null;
  }

  void _makeMove(int row, int col) {
    if (_board[row][col].isEmpty && _winner == null) {
      setState(() {
        _board[row][col] = _isPlayer1Turn ? 'X' : 'O';
        _checkWinner(row, col);
        _isPlayer1Turn = !_isPlayer1Turn;
      });
    }
  }

  void _checkWinner(int row, int col) {
    String player = _board[row][col];
    if (_board[row].every((element) => element == player)) {
      _winner = player;
      return;
    }
    if (_board.every((row) => row[col] == player)) {
      _winner = player;
      return;
    }
    if ((row == col ||
        (row + col) == (_board.length - 1)) &&
        _checkDiagonals(player)) {
      _winner = player;
      return;
    }
    if (_board.every((row) => row.every((cell) => cell.isNotEmpty))) {
      _winner = 'Draw';
    }
  }

  bool _checkDiagonals(String player) {
    bool diagonal1 = true, diagonal2 = true;
    for (int i = 0; i < _board.length; i++) {
      if (_board[i][i] != player) {
        diagonal1 = false;
      }
      if (_board[i][_board.length - 1 - i] != player) {
        diagonal2 = false;
      }
    }
    return diagonal1 || diagonal2;
  }

  Widget _buildBoard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _board.asMap().entries.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.value.asMap().entries.map((cell) {
            return GestureDetector(
              onTap: () => _makeMove(row.key, cell.key),
              child: Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: _board[row.key][cell.key] == 'X'
                      ? Colors.red
                      : _board[row.key][cell.key] == 'O'
                      ? Colors.blue
                      : null,
                ),
                child: Center(
                  child: Text(
                    _board[row.key][cell.key],
                    style: const TextStyle(fontSize: 40.0),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  void _showWinnerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Game Over'),
        content: Text(_winner == 'Draw'
            ? 'It\'s a draw!'
            : 'Player $_winner wins!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _initializeBoard();
              });
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_winner != null) {
      _showWinnerDialog(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
      ),
      body: Center(
        child: _buildBoard(),
      ),
    );
  }
}
