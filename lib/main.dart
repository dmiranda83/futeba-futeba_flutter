import 'package:flutter/material.dart';
import './screens/login_screen.dart';

main() => runApp(FutebaApp());

class FutebaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Futeba',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: LoginScreen(),
    );
  }
}
