import 'package:flutter/material.dart';
import 'package:prototype_app/screens/HomePage.dart';



import 'screens/HomePage.dart';void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Startup Name Generator',
        theme: ThemeData(
            primaryColor: Colors.blueGrey
        ),
        home: HomePage()
    );
  }
}


