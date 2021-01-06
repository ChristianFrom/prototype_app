import 'dart:async';

import 'package:flutter/material.dart';
import 'package:prototype_app/database_helper.dart';
import 'package:prototype_app/screens/HomePage.dart';
import 'package:prototype_app/screens/NotificationsPage.dart';
import 'package:prototype_app/screens/SensorPage.dart';
import 'package:prototype_app/screens/SettingsPage.dart';
import 'screens/HomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Temperature Sensors',
        theme: ThemeData(primaryColor: Colors.blueGrey),
        home: Home());
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  int alarmCount = 0;
  DatabaseHelper _dbHelper = DatabaseHelper();

  final List<Widget> _children = [
    HomePage(),
    NotificationsPage(),
    SettingsPage(),
  ];

  bool alarmed = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: _currentIndex,
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          new BottomNavigationBarItem(
            icon: FutureBuilder(
              initialData: [],
              future: _dbHelper.getAllTriggeredTemperatureTelemetry(),
              builder: (context, snapshot) {
                alarmCount = snapshot.data.length;
                print("total alarms triggered" + alarmCount.toString());
                return new Stack(children: <Widget>[
                  new Icon(Icons.notifications),
                  new Positioned(
                    // draw a red marble
                    top: 0.0,
                    right: 0.0,

                    child: new Icon(Icons.brightness_1,
                        size: 8.0,
                        color: alarmCount > 0
                            ? Colors.redAccent
                            : Colors.transparent),
                  )
                ]);
              },
            ),
            title: Text('Notifications'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text('Settings'))
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
