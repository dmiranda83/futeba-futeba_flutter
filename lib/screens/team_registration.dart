import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:futeba/utilities/constants.dart';

import '../utilities/constants.dart';

class PlayerRegistration extends StatefulWidget {
  @override
  _PlayerRegistrationState createState() => _PlayerRegistrationState();
}

class _PlayerRegistrationState extends State<PlayerRegistration> {
  final _cepController = TextEditingController(); // CEP
  final _enderecoController = TextEditingController(); // Nome da Rua
  final _bairroController = TextEditingController(); // Bairro
  final _cidadeContoller = TextEditingController(); // Cidade / Localidade
  final _ufController = TextEditingController(); //  Unidade federativa Estado.

  Widget _buildPlayerName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextField(
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blueAccent,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: Colors.blueAccent,
                ),
                hintText: "Nome do atleta ...",
                hintStyle: kHintTextStyle)),
        SizedBox(height: 10)
      ],
    );
  }

  Widget _buildPositionId() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextField(
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blueAccent,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: Colors.blueAccent,
                ),
                hintText: "Selecione a posicao do atleta ...",
                hintStyle: kHintTextStyle)),
        SizedBox(height: 10)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    debugDisableShadows = false;
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Cadastro de Atletas"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => print("Voltar"),
          icon: Icon(Icons.home),
        ),
        actions: [
          IconButton(
            onPressed: () => print("Salvar"),
            icon: Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          GestureDetector(
            child: TextFormField(
              controller: _cepController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "CEP"),
              keyboardType: TextInputType.number,
              onChanged: (_cepController) {
                if (_cepController.length >= 8) {
                  // _cpe();
                }
              },
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          TextFormField(
            controller: _enderecoController,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Endreço"),
          ),
          SizedBox(
            height: 8.0,
          ),
          TextFormField(
            controller: _bairroController,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Bairro"),
          ),
          SizedBox(
            height: 8.0,
          ),
          TextFormField(
            controller: _cidadeContoller,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Cidade"),
          ),
          SizedBox(
            height: 8.0,
          ),
          TextFormField(
            controller: _ufController,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Estado"),
          )
        ],
      ),
    );
  }
}
