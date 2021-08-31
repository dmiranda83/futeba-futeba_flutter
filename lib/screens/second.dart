import 'package:flutter/material.dart';

class Second extends StatefulWidget {
  @override
  _SecondState createState() => _SecondState();
}

class _SecondState extends State<Second> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Bem Vindo"),
              SizedBox(
                height: 50,
              ),
              OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.exit_to_app,
                    size: 18,
                  ),
                  label: Text("Logout"))
            ],
          ),
        ),
      ),
    );
  }
}
