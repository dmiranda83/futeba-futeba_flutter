import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:futeba/models/team.dart';
import 'package:futeba/screens/main_menu_page.dart';
import 'package:http/http.dart' as http;

class TeamRegistration extends StatefulWidget {
  TeamRegistration({required this.userId, required this.userName});
  final String userId;
  final String userName;
  @override
  _TeamRegistrationState createState() => _TeamRegistrationState();
}

class _TeamRegistrationState extends State<TeamRegistration> {
  int currentStep = 0;
  bool isCompleted = false;
  final _localNameController = TextEditingController(); // CEP
  final _cepController = TextEditingController(); // CEP
  final _enderecoController = TextEditingController(); // Nome da Rua
  final _bairroController = TextEditingController(); // Bairro
  final _cidadeController = TextEditingController(); // Cidade / Localidade
  final _ufController = TextEditingController(); //  Unidade federativa Estado.
  final _nameController = TextEditingController();
  final _responsibleNameController = TextEditingController();
  final _phoneContact1Controller = TextEditingController();
  final _phoneContact2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar:
          new AppBar(title: new Text("Cadastro de Equipes"), centerTitle: true),
      body: Theme(
        data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: Colors.blueAccent)),
        child: Stepper(
            type: StepperType.horizontal,
            steps: getSteps(),
            currentStep: currentStep,
            onStepContinue: () {
              final isLastStep = currentStep == getSteps().length - 1;
              if (isLastStep) {
                setState(() => isCompleted = true);
                print('Chamar API para cadastrar');
              } else {
                setState(() => currentStep += 1);
              }
            },
            onStepTapped: (step) => setState(() => currentStep -= 1),
            onStepCancel: currentStep == 0
                ? null
                : () => setState(() => currentStep -= 1),
            controlsBuilder: (context, {onStepContinue, onStepCancel}) {
              final isLastStep = currentStep == getSteps().length - 1;
              return Container(
                margin: EdgeInsets.only(top: 50),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: Text(isLastStep ? 'Confirmar' : "Proximo"),
                        onPressed: onStepContinue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (currentStep != 0)
                      Expanded(
                        child: ElevatedButton(
                          child: Text('Anterior'),
                          onPressed: onStepCancel,
                        ),
                      ),
                  ],
                ),
              );
            }),
      ));

  List<Step> getSteps() => [
        Step(
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 0,
            title: Text('Equipe'),
            content: Column(
              children: <Widget>[
                inputFile(label: "Nome da Equipe", controller: _nameController),
                inputFile(
                    label: "Nome do Responsável",
                    controller: _responsibleNameController),
                inputFile(
                    label: "Telefone do Resposável 1",
                    controller: _phoneContact1Controller),
                inputFile(
                    label: "Telefone do Resposável 2",
                    controller: _phoneContact2Controller),
              ],
            )),
        Step(
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 1,
            title: Text('Endereço'),
            content: Column(
              children: <Widget>[
                inputFile(
                    label: "Nome do Local", controller: _localNameController),
                inputFile(label: "Endereço", controller: _enderecoController),
                inputFile(label: "Cidade", controller: _cidadeController),
                inputFile(label: "UF", controller: _ufController),
                inputFile(label: "Bairro", controller: _bairroController),
                inputFile(label: "Cep", controller: _cepController)
              ],
            )),
        Step(
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 2,
            title: Text('Completo'),
            content: Column(
              children: <Widget>[
                inputFile(
                    label: "Nome do Local", controller: _localNameController),
                inputFile(label: "Endereço", controller: _enderecoController),
                inputFile(label: "Cidade", controller: _cidadeController),
                inputFile(label: "UF", controller: _ufController),
                inputFile(label: "Bairro", controller: _bairroController),
                inputFile(label: "Cep", controller: _cepController)
              ],
            ))
      ];

  Future<void> login(
      String team,
      bool away,
      String responsibleName,
      String phoneContact1,
      String phoneContact2,
      String categoryName,
      String placeName,
      String placetype,
      String address,
      String city,
      String neighborhood,
      String zipCode) async {
    if (team.isNotEmpty &&
        responsibleName.isNotEmpty &&
        phoneContact1.isNotEmpty &&
        phoneContact2.isNotEmpty &&
        categoryName.isNotEmpty &&
        placeName.isNotEmpty &&
        placetype.isNotEmpty &&
        address.isNotEmpty &&
        city.isNotEmpty &&
        neighborhood.isNotEmpty &&
        zipCode.isNotEmpty) {
      Map<String, dynamic> jsonMap = {
        'name': team,
        'away': away,
        'responsibleName': responsibleName,
        'phoneContact1': phoneContact1,
        'phoneContact2': phoneContact2,
        'category': {'name': categoryName},
        'place': {
          'name': placeName,
          'type': placetype,
          'address': address,
          'city': city,
          'neighborhood': neighborhood,
          'zipCode': zipCode
        }
      };
      String jsonString = json.encode(jsonMap);
      var response = await http.post(
          Uri.parse("http://localhost:8080/api/v1/teams"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonString);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        Team team = Team.fromJson(jsonResponse);
        showAlertDialogOnOkCallback(team);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Invalid Credentials")));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Black Field Not Allowed")));
    }
  }

  void showAlertDialogOnOkCallback(Team team) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Equipe cadastrada com sucesso!',
      btnOkOnPress: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MainMenu(team: team)));
      },
    ).show();
  }
}

Widget inputFile({label, obscureText = false, controller}) {
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
        controller: controller,
        decoration: InputDecoration(
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
