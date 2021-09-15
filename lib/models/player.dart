import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:futeba/models/slidable_action.dart';
import 'package:futeba/screens/main_menu.dart';
import 'package:futeba/screens/player_edit.dart';
import 'package:futeba/screens/player_registration.dart';
import 'package:http/http.dart' as http;

Future<List<Player>> fetchPlayers(http.Client client) async {
  final response =
      await client.get(Uri.parse('http://localhost:8080/api/v1/players'));
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
  final String position;
  final int positionId;
  final String photo;

  Player({
    required this.id,
    required this.name,
    required this.position,
    required this.positionId,
    required this.photo,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as int,
      name: json['name'] as String,
      position: json['position']['name'] as String,
      positionId: json['position']['id'] as int,
      photo: "https://randomuser.me/api/portraits/men/69.jpg",
    );
  }
}

class PlayersPage extends StatefulWidget {
  const PlayersPage({Key? key}) : super(key: key);
  @override
  _PlayersPageState createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  late Future<List<Player>> _futurePlayer;

  @override
  void initState() {
    super.initState();
    _futurePlayer = fetchPlayers(http.Client());
  }

  @override
  Widget build(BuildContext context) {
    var futureBuilder = new FutureBuilder(
      future: _futurePlayer,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Text('loading...');
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

  void playersRegister(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PlayerRegistration()));
  }

  void dashBoardMenu(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MainMenu()));
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Player> players = snapshot.data;
    return new ListView.builder(
      itemCount: players.length,
      itemBuilder: (BuildContext context, int index) {
        final item = players[index];
        return Slidable(
          key: Key(item.name),
          dismissal: SlidableDismissal(
            child: SlidableDrawerDismissal(),
            onDismissed: (type) {
              final action = SlidableAction.excluir;
              onDismissed(item, action);
            },
          ),
          actionPane: SlidableDrawerActionPane(),
          child: buildListTile(item),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Excluir',
              color: Colors.red,
              icon: Icons.delete_outline_outlined,
              onTap: () => onDismissed(item, SlidableAction.excluir),
            ),
            IconSlideAction(
              caption: 'Editar',
              color: Colors.blueGrey,
              icon: Icons.edit_outlined,
              onTap: () => playerEdit(context, item),
            )
          ],
        );
      },
    );
  }

  void playerEdit(BuildContext context, Player player) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => PlayerEdit(player: player)));
  }

  void onDismissed(Player player, SlidableAction action) {
    String name = player.name;
    deletePlayer(player.id.toString());
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Atleta excluido com sucesso!')));
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PlayersPage()));
  }

  Widget buildListTile(Player item) => ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: AssetImage('images/atleta.png'),
        ),
        title: new Text(item.name),
        subtitle: new Text(item.position),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {
          print("Detalhes do Atleta");
        },
      );
}
