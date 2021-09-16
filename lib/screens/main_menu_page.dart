import 'package:flutter/material.dart';
import 'package:futeba/models/player.dart';
import 'package:futeba/models/team.dart';

class MainMenu extends StatefulWidget {
  MainMenu({required this.team});
  final Team team;
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  late String _teamName = widget.team.name;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset(
                "images/image.png",
                width: 52.0,
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(
            "Bem Vindo!\n $_teamName",
            style: TextStyle(
                color: Colors.white,
                fontSize: 28.0,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Wrap(
              spacing: 20,
              runSpacing: 20.0,
              children: <Widget>[
                SizedBox(
                  width: 160.0,
                  height: 160.0,
                  child: Card(
                    color: Color.fromARGB(255, 21, 21, 21),
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    child: InkWell(
                      onTap: () {
                        playersPage(context);
                      },
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              "images/todo.png",
                              width: 64.0,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "Atletas",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                            SizedBox(
                              height: 5.0,
                            )
                          ],
                        ),
                      )),
                    ),
                  ),
                ),
                SizedBox(
                  width: 160.0,
                  height: 160.0,
                  child: Card(
                    color: Color.fromARGB(255, 21, 21, 21),
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            "images/calendar.png",
                            width: 64.0,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Agenda",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                          SizedBox(
                            height: 5.0,
                          )
                        ],
                      ),
                    )),
                  ),
                ),
                SizedBox(
                  width: 160.0,
                  height: 160.0,
                  child: Card(
                    color: Color.fromARGB(255, 21, 21, 21),
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            "images/settings.png",
                            width: 64.0,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Estatisticas",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                          SizedBox(
                            height: 5.0,
                          )
                        ],
                      ),
                    )),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    )));
  }

  void playersPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PlayersPage(team: widget.team)));
  }
}
