import 'package:GameTwoZero/ui/main_menu/main_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'game_logic/game2048_logic.dart/game.dart';
import 'constants/constants.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '2048',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainMenu(),
      ),
    );

class CellBox extends StatelessWidget {
  final double left;
  final double top;
  final double size;
  final Color color;
  final Text text;
  CellBox({this.left, this.top, this.size, this.color, this.text});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Center(
            child: text,
          )),
    );
  }
}

class gameOverDialog extends StatefulWidget {
  @override
  _gameOverDialogState createState() => _gameOverDialogState();
}

class _gameOverDialogState extends State<gameOverDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[200],
      actions: [
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Ok'),
        ),
      ],
      title: Text('Game Over'),
    );
  }
}
