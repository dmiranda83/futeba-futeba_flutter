import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futeba/models/team.dart';

class SelectTeam extends StatefulWidget {
  SelectTeam({required this.teams});
  final List<Team> teams;
  @override
  _SelectTeamState createState() => _SelectTeamState();
}

class _SelectTeamState extends State<SelectTeam> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: new AppBar(
          title: new Text("Seleção de Equipe"),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => {},
            icon: Icon(Icons.arrow_back_ios_new_outlined),
          ),
          actions: [
            IconButton(
              onPressed: () => {},
              icon: Icon(Icons.save_outlined),
            ),
          ],
        ),
      );
}
