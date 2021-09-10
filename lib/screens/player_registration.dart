import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:futeba/models/players.dart';
import 'package:futeba/screens/main_menu.dart';
import 'package:futeba/utilities/constants.dart';
import 'package:http/http.dart' as http;
import '../utilities/constants.dart';

class PlayerRegistration extends StatefulWidget {
  @override
  _PlayerRegistrationState createState() => _PlayerRegistrationState();
}

class _PlayerRegistrationState extends State<PlayerRegistration> {
  var emailController = TextEditingController();
  var passController = TextEditingController();

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
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Atletas"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => players(context),
          icon: Icon(Icons.arrow_back_ios_new_outlined),
        ),
        actions: [
          IconButton(
            onPressed: () => print("Salva Atleta atletas"),
            icon: Icon(Icons.save_outlined),
          ),
        ],
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      _buildPlayerName(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildPositionId(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void players(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PlayersPage()));
  }

  Future<void> loginMock() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MainMenu()));
  }

  Future<void> login() async {
    if (passController.text.isNotEmpty && emailController.text.isNotEmpty) {
      var response = await http.post(Uri.parse("https://regres.in/api/login"),
          body: ({
            'email': emailController.text,
            'password': passController.text
          }));
      if (response.statusCode == 200) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainMenu()));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Invalid Credentials")));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Black Field Not Allowed")));
    }
  }
}
