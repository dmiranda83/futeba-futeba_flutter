import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:futeba/models/player.dart';
import 'package:futeba/models/position.dart';
import 'package:futeba/models/team.dart';
import 'package:http/http.dart' as http;

Future<List<Position>> fetchPositions(http.Client client) async {
  final response = await client
      .get(Uri.parse('http://localhost:8080/api/v1/playerPositions'));
  if (response.statusCode == 200 || response.statusCode == 201) {
    return parsePositions(response.body);
  } else {
    throw Exception('Failed to load players');
  }
}

List<Position> parsePositions(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Position>((json) => Position.fromJson(json)).toList();
}

// ignore: must_be_immutable
class PlayerEdit extends StatefulWidget {
  PlayerEdit({required this.player, required this.team});
  final Player player;
  final Team team;
  @override
  _PlayerEditState createState() => _PlayerEditState();
}

class _PlayerEditState extends State<PlayerEdit> {
  List<Position> _positionResponse = [];
  TextEditingController _playerNameController = TextEditingController();
  late String _selectedPositionIdController =
      widget.player.position.id.toString();
  late int _idPlayer = widget.player.id;

  @override
  void initState() {
    _playerNameController.text = widget.player.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugDisableShadows = false;
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Edição de Atletas"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => players(context),
          icon: Icon(Icons.arrow_back_ios_new_outlined),
        ),
        actions: [
          IconButton(
            onPressed: () => _clickSaveButton(context),
            icon: Icon(Icons.save_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          SizedBox(
            height: 8.0,
          ),
          TextFormField(
            controller: _playerNameController,
            decoration: InputDecoration(
              labelText: 'Nome do atleta',
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blueAccent,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              prefixIcon: Icon(
                Icons.person_outline_outlined,
                color: Colors.blueAccent,
              ),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          FutureBuilder<List<Position>>(
            future: fetchPositions(http.Client()),
            builder: (BuildContext context, snapshot) {
              if (snapshot.data != null) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                      borderRadius: new BorderRadius.circular(10),
                      border: Border.all(color: Colors.blueAccent)),
                  child: DropdownButton(
                    items: snapshot.data!.map((value) {
                      return new DropdownMenuItem(
                        value: value.id.toString(),
                        child: new Text(
                          value.name,
                        ),
                      );
                    }).toList(),
                    value: _selectedPositionIdController,
                    onChanged: (value) {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      setState(() {
                        _selectedPositionIdController = value.toString();
                      });
                    },
                    isExpanded: true,
                    hint: Text(
                      'Select Source',
                    ),
                  ),
                );
              }
              if (snapshot.data == null) {
                return Text("No Data");
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

  _clickSaveButton(BuildContext context) async {
    String playerName = _playerNameController.text;
    String idPosition = _selectedPositionIdController;
    int idPlayer = _idPlayer;
    playerEdit(playerName, _selectedPositionIdController, idPlayer);
  }

  void players(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PlayersPage(team: widget.team)));
  }

  Future<void> playerEdit(
      String playerName, String positionId, idPlayer) async {
    Map<String, dynamic> jsonMap = {
      'id': idPlayer,
      'name': playerName,
      'positionId': positionId
    };
    String jsonString = json.encode(jsonMap); // encode map to json

    var response = await http.put(
        Uri.parse("http://localhost:8080/api/v1/players/$idPlayer"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonString);
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) {
      showAlertDialogOnOkCallback();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Houve falha ao cadastrar atleta!")));
    }
  }

  void showAlertDialogOnOkCallback() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Atleta atualizado com sucesso!',
      btnOkOnPress: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlayersPage(team: widget.team)));
      },
    ).show();
  }
}
