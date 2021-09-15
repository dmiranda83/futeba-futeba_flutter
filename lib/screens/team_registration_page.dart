import 'package:flutter/material.dart';

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
  final _confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar:
          new AppBar(title: new Text("Cadastro de Equipes"), centerTitle: true),
      body: isCompleted
          ? buildCompleted()
          : Theme(
              data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(primary: Colors.blueAccent)),
              child: Stepper(
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
            title: Text('Dados da Equipe'),
            content: Column(
              children: <Widget>[
                inputFile(label: "Nome da Equipe", controller: _nameController),
                inputFile(
                    label: "Nome do Responsável",
                    controller: _responsibleNameController),
                inputFile(
                    label: "Telefone do Resposável",
                    controller: _phoneContact1Controller),
                inputFile(
                    label: "Telefone do Resposável",
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
}

Widget buildCompleted() {
  return Column();
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
