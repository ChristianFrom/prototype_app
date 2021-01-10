import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:prototype_app/main.dart';
import 'package:prototype_app/screens/SensorPage.dart';
import 'package:prototype_app/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
=======
import 'package:prototype_app/database_helper.dart';
import 'package:prototype_app/screens/SensorPage.dart';
import 'package:prototype_app/widgets.dart';
>>>>>>> parent of 096ea0d... Revert "Revert "Using db in the cloud""

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    //_dbHelper.insertDummyData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {

    });
    return Scaffold(
        body: SafeArea(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 24.0,
            ),
            color: Color(0xFFF6F6F6),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(
                          top: 32.0,
                          bottom: 32.0,
                        ),
                        child: Center(
                          child: Text(
                            "Temperature Sensors",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30.0),
                          ),
                        )),
                    Expanded(
                      child: FutureBuilder(
                        initialData: [],
                        future: _dbHelper.getTemperatureSensors(),
                        builder: (context, snapshot) {
                          return ScrollConfiguration(
                            behavior: NoGlowScrollBehavior(),
                            child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SensorPage(
                                                sensor: snapshot.data[index],
                                              )),
                                    ).then((value) {
                                      setState(() {});
                                    });
                                  },
                                  child: SensorCardWidget(
                                    sensorName: snapshot.data[index].sensorName,
                                    sensorLocation: snapshot.data[index]
                                        .sensorLocation,
                                    sensorGroup: snapshot.data[index]
                                        .sensorGroup,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
