import 'package:GameTwoZero/constants/constants.dart';
import 'package:GameTwoZero/ui/game2048.dart/game_2048.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../main.dart';

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int gameL = 0;
  int gameR = 0;
  int r = 0;
  int c = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () => {
                      gameL == 0
                          ? null
                          : setState(() {
                              gameL = --r;
                              gameR = --c;
                            }),
                    },
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.3,
                    child: Center(
                      child: Text(
                        '${gameLevel[gameL]}X${gameLevel[gameR]}',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () => {
                      gameL == gameLevel.length - 1
                          ? null
                          : setState(
                              () {
                                gameL = ++r;
                                gameR = ++c;
                              },
                            ),
                    },
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  color: mainHomeBarColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 50,
                width: MediaQuery.of(context).size.width / 2,
                child: Center(
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 27,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            NewGame(gameL: gameL, gameR: gameR),
          ],
        ),
      ),
    );
  }
}

class NewGame extends StatelessWidget {
  const NewGame({
    Key key,
    @required this.gameL,
    @required this.gameR,
  }) : super(key: key);

  final int gameL;
  final int gameR;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (BuildContext context) {
            return MainGameWidget(
              rowN: gameLevel[gameL],
              colN: gameLevel[gameR],
            );
          },
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: mainHomeBarColor,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 50,
        width: MediaQuery.of(context).size.width / 2,
        child: Center(
          child: Text(
            'New Game',
            style: TextStyle(
              fontSize: 27,
            ),
          ),
        ),
      ),
    );
  }
}
