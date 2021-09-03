import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Player>> fetchPlayers(http.Client client) async {
  final response =
      await client.get(Uri.parse('http://localhost:8080/api/v1/players'));
  if (response.statusCode == 200 || response.statusCode == 201) {
    return parsePhotos(response.body);
  } else {
    throw Exception('Failed to load players');
  }
}

List<Player> parsePhotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Player>((json) => Player.fromJson(json)).toList();
}

class Player {
  final int id;
  final String name;
  final String position;
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
      position: json['position']['name'] as String,
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
  @override
  Widget build(BuildContext context) {
    var futureBuilder = new FutureBuilder(
      future: fetchPlayers(http.Client()),
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
      ),
      body: futureBuilder,
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Player> players = snapshot.data;
    return new ListView.builder(
      itemCount: players.length,
      itemBuilder: (BuildContext context, int index) {
        return new Column(
          children: <Widget>[
            new ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('images/atleta.png'),
              ),
              title: new Text(players[index].name),
              subtitle: new Text(players[index].position),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Text('Players datails');
              },
            ),
            new Divider(
              height: 2.0,
            ),
          ],
        );
      },
    );
  }
}
