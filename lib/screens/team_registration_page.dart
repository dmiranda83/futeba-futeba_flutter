import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:futeba/models/team.dart';
import 'package:futeba/models/user.dart';
import 'package:futeba/screens/main_menu_page.dart';
import 'package:futeba/services/via_cep_service.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class TeamRegistration extends StatefulWidget {
  TeamRegistration({required this.userId, required this.userName});
  final String userId;
  final String userName;
  @override
  _TeamRegistrationState createState() => _TeamRegistrationState();
}

class _TeamRegistrationState extends State<TeamRegistration> {
  var maskFormatter = new MaskTextInputFormatter(
      mask: '(##) # ####-####', filter: {"#": RegExp(r'[0-9]')});
  late String _userId = widget.userId;
  int currentStep = 0;
  bool isCompleted = false;
  final _placelNameController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _addressController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _cityController = TextEditingController();
  final _ufController = TextEditingController();
  final _nameController = TextEditingController();
  final _responsibleNameController = TextEditingController();
  final _phoneContact1Controller = TextEditingController();
  final _phoneContact2Controller = TextEditingController();
  final _awayController = TextEditingController();
  final _categoryController = TextEditingController();
  final _placeTypeController = TextEditingController();

  final _searchCepController = TextEditingController();
  bool _loading = false;
  bool _enableField = true;
  late String _result;

  @override
  void dispose() {
    super.dispose();
    _searchCepController.clear();
  }

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
                teamRegistration(
                    _nameController.text,
                    _awayController.text,
                    _responsibleNameController.text,
                    _phoneContact1Controller.text,
                    _phoneContact2Controller.text,
                    _categoryController.text,
                    _placelNameController.text,
                    _placeTypeController.text,
                    _addressController.text,
                    _cityController.text,
                    _neighborhoodController.text,
                    _zipCodeController.text);
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
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blueAccent),
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
                    controller: _phoneContact1Controller,
                    mask: maskFormatter),
                inputFile(
                    label: "Telefone do Resposável 2",
                    controller: _phoneContact2Controller,
                    mask: maskFormatter),
              ],
            )),
        Step(
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 1,
            title: Text('Endereço'),
            content: Column(
              children: <Widget>[
                inputFile(
                    label: "Nome do Local", controller: _placelNameController),
                inputFileZipCode(label: "Cep", controller: _zipCodeController),
                inputFile(label: "Endereço", controller: _addressController),
                inputFile(label: "Cidade", controller: _cityController),
                inputFile(label: "UF", controller: _ufController),
                inputFile(label: "Bairro", controller: _neighborhoodController)
              ],
            )),
        Step(
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 2,
            title: Text('Completo'),
            content: Column(
              children: <Widget>[
                inputFile(
                    label: "Nome do Local", controller: _placelNameController),
                inputFile(label: "Endereço", controller: _addressController),
                inputFile(label: "Cidade", controller: _cityController),
                inputFile(label: "UF", controller: _ufController),
                inputFile(label: "Bairro", controller: _neighborhoodController),
                inputFile(label: "Cep", controller: _zipCodeController)
              ],
            ))
      ];

  Future<void> teamRegistration(
      String team,
      String away,
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
      bool teamAway = "1" == away ? true : false;
      Map<String, dynamic> jsonMap = {
        'team': {
          'name': team,
          'away': teamAway,
          'responsibleName': responsibleName,
          'phoneContact1': phoneContact1,
          'phoneContact2': phoneContact2,
          'category': {'name': "Futsal"},
          'place': {
            'name': placeName,
            'type': placetype,
            'address': address,
            'city': city,
            'neighborhood': neighborhood,
            'zipCode': zipCode
          }
        }
      };
      String jsonString = json.encode(jsonMap);
      var response = await http.put(
          Uri.parse("http://localhost:8080/api/v1/user/$_userId"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonString);
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        final jsonResponse = json.decode(response.body);
        User user = User.fromJson(jsonResponse);
        showAlertDialogOnOkCallback(user.teams[0]);
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

  Widget inputFileZipCode({label, obscureText = false, controller, mask}) {
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
        TextFormField(
          controller: controller,
          onChanged: (controller) {
            if (controller.length >= 8) {
              _searchCep();
            }
          },
          inputFormatters: [masker],
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey))),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  void _searching(bool enable) {
    setState(() {
      _result = enable ? '' : _result;
      _loading = enable;
      _enableField = !enable;
    });
  }

  Future _searchCep() async {
    _searching(true);
    final cep = _zipCodeController.text;
    final resultCep = await ViaCepService.fetchCep(cep: cep);
    print(resultCep.localidade); // Exibindo somente a localidade no terminal
    setState(() {
      _addressController.text = resultCep.logradouro;
      _cityController.text = resultCep.localidade;
      _ufController.text = resultCep.uf;
      _neighborhoodController.text = resultCep.bairro;
    });
    _searching(false);
  }
}

Widget inputFile({label, obscureText = false, controller, mask}) {
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
      TextFormField(
        controller: controller,
        inputFormatters: [masker],
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
