import 'package:GameTwoZero/constants/constants.dart';
import 'package:flutter/material.dart';

import '../../game_logic/game2048_logic.dart/game.dart';
import '../../main.dart';

class MainGameWidget extends StatefulWidget {
  final int rowN;
  final int colN;

  const MainGameWidget({Key key, @required this.rowN, @required this.colN})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _MainGameWidgetState();
  }
}

class BoardGridWidget extends StatelessWidget {
  final _MainGameWidgetState _state;
  BoardGridWidget(this._state);
  @override
  Widget build(BuildContext context) {
    Size boardSize = _state.sizeOfBoard();
    double width = (boardSize.width - (_state.column + 1) * _state.PadCell) /
        _state.column;
    List<CellBox> _backgroundBox = List<CellBox>();
    for (int r = 0; r < _state.row; ++r) {
      for (int c = 0; c < _state.column; ++c) {
        CellBox box = CellBox(
          left: c * width + _state.PadCell * (c + 1),
          top: r * width + _state.PadCell * (r + 1),
          size: width,
          color: Colors.grey[300],
        );
        _backgroundBox.add(box);
      }
    }
    return Positioned(
      left: 0.0,
      top: 0.0,
      child: Container(
        width: _state.sizeOfBoard().width,
        height: _state.sizeOfBoard().height,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Stack(
          children: _backgroundBox,
        ),
      ),
    );
  }
}

class _MainGameWidgetState extends State<MainGameWidget> {
  GameLogic _game;
  MediaQueryData _screenSizeQuery;
  int row = 3;
  int column = 3;
  final double PadCell = 5.0;
  final EdgeInsets _marginOfGame = EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0);
  bool _isDragged = false, _isGameOver = false;

  void moveLeft() {
    setState(() {
      _game.moveLeft();
      gameOverOrNot();
    });
  }

  void moveRight() {
    setState(() {
      _game.moveRight();
      gameOverOrNot();
    });
  }

  @override
  void initState() {
    super.initState();
    row = widget.rowN;
    column = widget.colN;
    _game = GameLogic(row, column);
    newGame();
  }

  void newGame() {
    _game.init();
    _isGameOver = false;
    setState(() {});
  }

  void moveUp() {
    setState(() {
      _game.moveUp();
      gameOverOrNot();
    });
  }

  void moveDown() {
    setState(() {
      _game.moveDown();
      gameOverOrNot();
    });
  }

  void gameOverOrNot() {
    if (_game.isGameOver()) {
      _isGameOver = true;
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Do you really want to exit the game ?'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'No',
            ),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Yes',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<CellWidget> _cellWidget = List<CellWidget>();
    for (int r = 0; r < row; ++r) {
      for (int c = 0; c < column; ++c) {
        _cellWidget.add(CellWidget(cell: _game.get(r, c), state: this));
      }
    }
    _screenSizeQuery = MediaQuery.of(context);
    List<Widget> children = List<Widget>();
    children.add(BoardGridWidget(this));
    children.addAll(_cellWidget);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.brown[100],
        appBar: AppBar(
          iconTheme:
              Theme.of(context).accentIconTheme.copyWith(color: Colors.black),
          elevation: 0.0,
          // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          backgroundColor: Colors.brown[100],
        ),
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 64.0, 0.0, 0.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(6),
                            child: Text(
                              '2048',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          ScoreContainer(game: _game),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(0.0),
                        child: GestureDetector(
                          child: Container(
                            width: 60.0,
                            height: 60.0,
                            child: Center(
                              child:
                                  Icon(Icons.replay, color: Colors.brown[500]),
                            ),
                          ),
                          onTap: () {
                            newGame();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                Container(
                    margin: _marginOfGame,
                    width: _screenSizeQuery.size.width,
                    height: _screenSizeQuery.size.width,
                    child: GestureDetector(
                      onVerticalDragUpdate: (detail) {
                        if (detail.delta.distance == 0 || _isDragged) {
                          return;
                        }
                        _isDragged = true;
                        if (detail.delta.direction > 0) {
                          moveDown();
                        } else {
                          moveUp();
                        }
                      },
                      onVerticalDragEnd: (detail) {
                        _isDragged = false;
                      },
                      onVerticalDragCancel: () {
                        _isDragged = false;
                      },
                      onHorizontalDragUpdate: (detail) {
                        if (detail.delta.distance == 0 || _isDragged) {
                          return;
                        }
                        _isDragged = true;
                        if (detail.delta.direction > 0) {
                          moveLeft();
                        } else {
                          moveRight();
                        }
                      },
                      onHorizontalDragDown: (detail) {
                        _isDragged = false;
                      },
                      onHorizontalDragCancel: () {
                        _isDragged = false;
                      },
                      child: Stack(
                        children: children,
                      ),
                    )),
              ],
            ),
            _isGameOver ? gameOverDialog() : SizedBox(),
          ],
        ),
      ),
    );
  }

  Size sizeOfBoard() {
    assert(_screenSizeQuery != null);
    Size size = _screenSizeQuery.size;
    num width = size.width - _marginOfGame.left - _marginOfGame.right;
    return Size(width, width);
  }
}

class ScoreContainer extends StatelessWidget {
  const ScoreContainer({
    Key key,
    @required GameLogic game,
  })  : _game = game,
        super(key: key);

  final GameLogic _game;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: gameScreenRowColor,
      ),
      child: Container(
        width: 130.0,
        height: 60.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Score',
              style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              _game.score.toString(),
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedCell extends AnimatedWidget {
  final BoardCell cell;
  final _MainGameWidgetState state;
  AnimatedCell({Key key, this.cell, this.state, Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    double animationValue = animation.value;
    Size boardSize = state.sizeOfBoard();
    double width =
        (boardSize.width - (state.column + 1) * state.PadCell) / state.column;
    if (cell.number == 0) {
      return Container();
    } else {
      return CellBox(
        left: (cell.column * width + state.PadCell * (cell.column + 1)) +
            width / 2 * (1 - animationValue),
        top: cell.row * width +
            state.PadCell * (cell.row + 1) +
            width / 2 * (1 - animationValue),
        size: width * animationValue,
        color: boxColor.containsKey(cell.number)
            ? boxColor[cell.number]
            : boxColor[boxColor.keys.last],
        text: Text(
          cell.number.toString(),
          style: TextStyle(
            fontSize: 30.0 * animationValue,
            fontWeight: FontWeight.bold,
            color: cell.number < 32 ? Colors.grey[600] : Colors.grey[50],
          ),
        ),
      );
    }
  }
}

class CellWidget extends StatefulWidget {
  final BoardCell cell;
  final _MainGameWidgetState state;
  CellWidget({this.cell, this.state});
  _CellWidgetState createState() => _CellWidgetState();
}

class _CellWidgetState extends State<CellWidget>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> _animation;

  @override
  initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(
        milliseconds: 200,
      ),
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(controller);
  }

  dispose() {
    controller.dispose();
    super.dispose();
    widget.cell.isNew = false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cell.isNew && !widget.cell.isEmpty()) {
      controller.reset();
      controller.forward();
      widget.cell.isNew = false;
    } else {
      controller.animateTo(1.0);
    }
    return AnimatedCell(
      cell: widget.cell,
      state: widget.state,
      animation: _animation,
    );
  }
}
