import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:futeba/models/User.dart';
import 'package:futeba/screens/team_registration_page.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  var maskFormatter = new MaskTextInputFormatter(
      mask: '(##) # ####-####', filter: {"#": RegExp(r'[0-9]')});
  var _nameController = TextEditingController();
  var _celPhoneController = TextEditingController();
  var _emailController = TextEditingController();
  var _passController = TextEditingController();
  var _confirmPassController = TextEditingController();
  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.white, // Navigation bar
            statusBarColor: Colors.white, // Status bar
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height - 50,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      "Cadastro",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Cria sua conta, é gratis ",
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    inputFile(
                        label: "Nome do Responsável",
                        controller: _nameController),
                    inputFile(
                        label: "Telefone do Responsável",
                        controller: _celPhoneController,
                        mask: maskFormatter,
                        hintText: "(XX) X XXXX-XXXX"),
                    inputFile(label: "Email", controller: _emailController),
                    inputFile(
                        label: "Password",
                        obscureText: true,
                        controller: _passController),
                    inputFile(
                        label: "Confirm Password ",
                        obscureText: true,
                        controller: _confirmPassController),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 3, left: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border(
                        bottom: BorderSide(color: Colors.black),
                        top: BorderSide(color: Colors.black),
                        left: BorderSide(color: Colors.black),
                        right: BorderSide(color: Colors.black),
                      )),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () => signup(
                        _nameController.text,
                        _celPhoneController.text,
                        _emailController.text,
                        _passController.text,
                        _passController.text),
                    color: Color(0xff0095FF),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      "Cadastre-se",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Já tem uma conta?"),
                    Text(
                      " Entrar",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );

  Future<void> signup(String name, String celPhone, String email,
      String password, String confirmPassword) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      Map<String, dynamic> jsonMap = {
        'name': name,
        'email': email,
        'cellPhone': celPhone,
        'password': password
      };
      String jsonString = json.encode(jsonMap);
      var response = await http.post(
          Uri.parse("http://10.0.2.2:8080/api/v1/user/signup"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonString);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        User user = User.fromJson(jsonResponse);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TeamRegistration(
                      userId: user.id.toString(),
                      userName: user.name,
                      userPhone: user.cellPhone,
                    )));
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

Widget inputFile(
    {label, obscureText = false, controller, mask, hintText = ""}) {
  var masker = mask != null ? mask : new MaskTextInputFormatter(mask: '');
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
      ),
      SizedBox(
        height: 5,
      ),
      TextField(
        obscureText: obscureText,
        inputFormatters: [masker],
        controller: controller,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
      ),
      SizedBox(
        height: 10,
      )
    ],
  );
}
