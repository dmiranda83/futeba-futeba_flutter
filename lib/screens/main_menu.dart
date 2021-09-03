import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:futeba/models/players.dart';
import 'package:http/http.dart' as http;

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
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
                "Bem Vindo! \nRitmo de Festa",
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
                            playerRegistration();
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
                                  "Cadastro",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  "Atletas",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w100),
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
                                  "Consulta",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  "Atletas",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w100),
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
                              ),
                              Text(
                                "4 Items",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w100),
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
                                "Settings",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                "6 Items",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w100),
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
        context, MaterialPageRoute(builder: (context) => PlayersPage()));
  }

  Future<void> playerRegistration() async {
    var response = await http.post(
        Uri.parse("http://localhost:8080/api/v1/players"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'name': "Luiz",
          'positionId': "6",
          'teamId': "4"
        }));
    if (response.statusCode == 200 || response.statusCode == 201) {
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
      title: 'Atleta cadastrado com sucesso!',
      btnOkOnPress: () {
        //Navigator.push(
        //   context, MaterialPageRoute(builder: (context) => Players()));
      },
    ).show();
  }
}
