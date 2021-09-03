import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:futeba/themes/colors.dart';
import 'package:http/http.dart' as http;

Future<Player> fetchPlayers() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Player.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load players');
  }
}

class Player {
  final int id;
  final String name;
  final String position;

  Player({
    required this.id,
    required this.name,
    required this.position,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      position: json['position']['name'],
    );
  }
}

class PlayersPage extends StatefulWidget {
  const PlayersPage({Key? key}) : super(key: key);
  @override
  _PlayersPageState createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  late Future<Player> futurePlayers;

  @override
  void initState() {
    super.initState();
    futurePlayers = fetchPlayers();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Player>(
            future: futurePlayers,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.name);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
