import 'package:flutter/material.dart';
import 'package:futeba/screens/home_page.dart';

main() => runApp(FutebaApp());

class FutebaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Futeba',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        platform: TargetPlatform.iOS,
        unselectedWidgetColor: Colors.blueAccent
      ),
      home: HomePage(),
    );
  }
}
