import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:futeba/models/position.dart';
import 'package:futeba/models/team.dart';
import 'package:futeba/screens/main_menu_page.dart';
import 'package:futeba/screens/player_edit_page.dart';
import 'package:futeba/screens/player_registration_page.dart';
import 'package:http/http.dart' as http;

Future<List<Player>> fetchPlayers(http.Client client, String idTeam) async {
  final response = await client
      .get(Uri.parse('http://localhost:8080/api/v1/players/team/$idTeam'));
  if (response.statusCode == 200 || response.statusCode == 201) {
    return parsePlayer(response.body);
  } else {
    throw Exception('Failed to load players');
  }
}

Future<Player> deletePlayer(String id) async {
  final response =
      await http.delete(Uri.parse('http://localhost:8080/api/v1/players/$id'));
  if (response.statusCode == 200) {
    return Player.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to delete Player');
  }
}

List<Player> parsePlayer(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Player>((json) => Player.fromJson(json)).toList();
}

class Player {
  final int id;
  final String name;
  final Position position;
  final String photo;

  Player({
    required this.id,
    required this.name,
    required this.position,
    required this.photo,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as int,
      name: json['name'] as String,
      position: Position.fromJson(json['position']),
      photo: "https://randomuser.me/api/portraits/men/69.jpg",
    );
  }
}

class PlayersPage extends StatefulWidget {
  PlayersPage({required this.team});
  final Team team;

  @override
  _PlayersPageState createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage>
    with TickerProviderStateMixin {
  late Future<List<Player>> _futurePlayer;
  late AnimationController controllerAnimation;

  @override
  void initState() {
    controllerAnimation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controllerAnimation.repeat(reverse: true);
    super.initState();
    _futurePlayer = fetchPlayers(http.Client(), widget.team.id.toString());
  }

  @override
  void dispose() {
    controllerAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var futureBuilder = new FutureBuilder(
      future: _futurePlayer,
      builder: (context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return _circularLoading();
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return createListView(context, snapshot);
        }
      },
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Atletas"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => dashBoardMenu(context),
          icon: Icon(Icons.home),
        ),
        actions: [
          IconButton(
            onPressed: () => playersRegister(context),
            icon: Icon(Icons.person_add_alt_outlined),
          ),
        ],
      ),
      body: futureBuilder,
    );
  }

  Widget _circularLoading() {
    return Container(
      height: 15.0,
      width: 15.0,
      child: CircularProgressIndicator(),
    );
  }

  void playersRegister(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PlayerRegistration(team: widget.team)));
  }

  void dashBoardMenu(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MainMenu(team: widget.team)));
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Player> players = snapshot.data;
    return new ListView.builder(
      itemCount: players.length,
      itemBuilder: (BuildContext context, int index) {
        final item = players[index];
        return Slidable(
          key: ValueKey(0), // A key is necessary.
          startActionPane: ActionPane(
            dismissible: DismissiblePane(
              onDismissed: () {
                // Remove this Slidable from the widget tree.
              },
            ),
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                label: 'Archive',
                backgroundColor: Colors.blue,
                icon: Icons.archive,
                onPressed: (context) {},
              ),
            ],
          ),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.25,
            children: [
              SlidableAction(
                label: 'Excluir',
                backgroundColor: Colors.red,
                icon: Icons.delete_outline_outlined,
                onPressed: (context) {},
              ),
              SlidableAction(
                label: 'Editar',
                backgroundColor: Colors.blueGrey,
                icon: Icons.edit_outlined,
                onPressed: (context) {},
              ),
            ],
          ),
          child: buildListTitle(item),
        );
      },
    );
  }

  void playerEdit(BuildContext context, Player player) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PlayerEdit(player: player, team: widget.team)));
  }

  void onDismissed(Player player, SlidableAction action) {
    deletePlayer(player.id.toString());
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Atleta excluido com sucesso!')));
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PlayersPage(team: widget.team)));
  }

  Widget buildListTitle(Player item) => ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: AssetImage('assets/images/atleta.png'),
        ),
        title: new Text(item.name,
            style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.w900,
                fontFamily: 'Open Sans')),
        subtitle: new Text(item.position.name,
            style: TextStyle(fontStyle: FontStyle.italic)),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {
          print("Detalhes do Atleta");
        },
      );
}
