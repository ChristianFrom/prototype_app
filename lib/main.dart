import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prototype_app/screens/HomePage.dart';
import 'package:prototype_app/screens/NotificationsPage.dart';
import 'package:prototype_app/screens/SettingsPage.dart';

import 'screens/HomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Temperature Sensors',
        theme: ThemeData(primaryColor: Colors.blueGrey),
        home: HomeDB());
  }
}

class HomeDB extends StatefulWidget {
  @override
  _HomeDBState createState() => _HomeDBState();
}

class _HomeDBState extends State<HomeDB> {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Snapshot error"));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Home();
          }

          return Center(child: Text("Loading"));
        });
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  int documentCount = 0;
  final List<Widget> _children = [
    HomePage(),
    NotificationsPage(),
    SettingsPage(),
  ];

  void countDocs() async {
    final QuerySnapshot qSnap = await FirebaseFirestore.instance
        .collection('TemperatureTelemetry')
        .where('alarmTriggered', isEqualTo: true)
        .where('alarmAcknowledged', isEqualTo: false)
        .get();
    documentCount = qSnap.docs.length;
    print("alarms: " + documentCount.toString());
  }

  bool alarmed = false;

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
            icon: StreamBuilder(
              initialData: [],
              stream: FirebaseFirestore.instance
                  .collection("TemperatureTelemetry")
                  .where('alarmTriggered', isEqualTo: true)
                  .where('alarmAcknowledged', isEqualTo: false)
                  .snapshots(),
              builder: (context, snapshot) {
                countDocs();
                //print("total alarms triggered" + alarmCount.toString());
                return new Stack(children: <Widget>[
                  new Icon(Icons.notifications),
                  new Positioned(
                    // draw a red marble
                    top: 0.0,
                    right: 0.0,

                    child: new Icon(Icons.brightness_1,
                        size: 8.0,
                        color: documentCount > 0 ? Colors.redAccent : Colors.transparent),
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
      countDocs();
      _currentIndex = index;
    });
  }
}
