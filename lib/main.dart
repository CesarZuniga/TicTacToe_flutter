import 'package:flutter/material.dart';

void main() {
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Tic Tac Toe',
      home: TicTacToe(),
    );
  }
}

class TicTacToe extends StatefulWidget {
  const TicTacToe({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  List<List<String>> boardState = List.generate(3, (_) => List.filled(3, ''));
  String turn = 'X';
  String winner = '';
  void restar(){
    setState(() {      
        turn =  'X' ;
        boardState = List.generate(3, (_) => List.filled(3, ''));
        winner = '';
    });
  }
  void handleButtonPressed(int row, int col) {
    setState(() {
      if (boardState[row][col].isEmpty && winner.isEmpty){
        turn = turn == 'X' ? 'O' : 'X';
        boardState[row][col] = turn;
        winner = checkWinner(boardState);
        if (winner.isNotEmpty) {
          if(winner.contains('draw')){
            _showMyDialog('Lo sentimos!!', 'Sigan intentando esta partida a quedado igualada 😜');
            restar();
          }else{
            _showMyDialog('Felicidades!!','$winner tu has ganado esta partida 😊');
            restar();
          }          
        }
      }
    });
  }

  Widget buildBoard() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: 9,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (BuildContext context, int index) {
        final row = index ~/ 3;
        final col = index % 3;

        return TextButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                    side: BorderSide(width: 0.5, color: Colors.blue)))),
            onPressed: () => {handleButtonPressed(row, col)},
            child: Text(
              boardState[row][col],
              style: const TextStyle(fontSize: 50),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
      ),
      body: Center(
        child: buildBoard(),
      ),
      floatingActionButton:
      FloatingActionButton(
                onPressed: () {
                  _showMyDialog('Confirmación', 'Estas seguro que quieres reiniciar la partida?',isConfirm: true );
                },
                tooltip: 'Reiniciar',
                child: const Icon(Icons.restore),
              ) ,
    );
  }

  String checkWinner(List<List<String>> board) {
    for (int i = 0; i < 3; i++) {
      if (board[i][0] == board[i][1] &&
          board[i][1] == board[i][2] &&
          board[i][0] != '') {
        return board[i][0];
      }
      if (board[0][i] == board[1][i] &&
          board[1][i] == board[2][i] &&
          board[0][i] != '') {
        return board[0][i];
      }
    }
    if (board[0][0] == board[1][1] &&
        board[1][1] == board[2][2] &&
        board[0][0] != '') {
      return board[0][0];
    }
    if (board[0][2] == board[1][1] &&
        board[1][1] == board[2][0] &&
        board[0][2] != '') {
      return board[0][2];
    }
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == '') {
          return '';
        }
      }
    }
    return 'draw';
  }

  Future<void> _showMyDialog(String title, String msg, {bool isConfirm = false}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children:  <Widget>[
                Text(msg),
              ],
            ),
          ),
          actions: isConfirm ? <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                restar();
                Navigator.of(context).pop();
              },
            ),
          ] : 
          <Widget>[
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
