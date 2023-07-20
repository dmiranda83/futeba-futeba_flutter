import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    double width = MediaQuery.of(context).size.width - 100;
    return Container(
      color: Color(0xFF272837),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    'Ola!',
                    style: TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        fontSize: 36,
                        color: Colors.white),
                  ),
                  Text(_teamName,
                      style: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          fontSize: 36,
                          color: Colors.white))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  circButton(FontAwesomeIcons.instagram),
                  circButton(FontAwesomeIcons.accusoft),
                  circButton(FontAwesomeIcons.whatsapp),
                  circButton(FontAwesomeIcons.facebook)
                ],
              ),
              Wrap(runSpacing: 10, children: [
                modeButton('ATLETAS', FontAwesomeIcons.airbnb,
                    Color(0xFF2F80ED), width),
                modeButton('TIMES', FontAwesomeIcons.football,
                    Color(0xFFDF1D5A), width)
              ])
            ],
          ),
        ),
      ),
    );
  }

  Padding circButton(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: RawMaterialButton(
          onPressed: () {},
          fillColor: Colors.white,
          shape: CircleBorder(),
          constraints: BoxConstraints(minHeight: 85, minWidth: 85),
          child: FaIcon(icon, size: 50, color: Color(0xFF2F3041))),
    );
  }

  GestureDetector modeButton(
      String title, IconData icon, Color color, double width) {
    return GestureDetector(
      child: Container(
        width: width,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.all(Radius.circular(16))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        fontFamily: 'Manrope',
                        color: Colors.white,
                        fontSize: 18),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
              child: FaIcon(icon, size: 60, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  void playersPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PlayersPage(team: widget.team)));
  }
}
