import 'package:flutter/material.dart';
import './screens/login_screen.dart';

main() => runApp(FutebaApp());

class FutebaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter login UI',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
