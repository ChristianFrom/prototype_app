import 'package:flutter/material.dart';
import 'package:prototype_app/main.dart';
import 'package:prototype_app/screens/SensorPage.dart';
import 'package:prototype_app/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  int documentCount;

  @override
  Widget build(BuildContext context) {
    setState(() {});
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
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("SensorTable")
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return ScrollConfiguration(
                            behavior: NoGlowScrollBehavior(),
                            child: ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SensorPage(
                                                msg: snapshot.data.docs[index],
                                              )),
                                    ).then((value) {
                                      Home().createState();
                                    });
                                  },
                                  child: SensorCardWidget(
                                    sensorName: snapshot.data.docs[index].id,
                                    sensorLocation: snapshot.data.docs[index]
                                        .data()['sensorLocation'],
                                    sensorGroup: snapshot.data.docs[index]
                                        .data()['sensorGroup'],
                                  ),
                                );
                              },
                            ),
                          );
                        } else
                          return Text("No data available...");
                      }),
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
