import 'package:flutter/material.dart';
import 'package:prototype_app/database_helper.dart';
import 'package:prototype_app/models/temperatureSensor.dart';
import 'package:prototype_app/widgets.dart';
import 'package:vibrate/vibrate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SensorPage extends StatefulWidget {
  DocumentSnapshot msg;
  SensorPage({@required this.msg});

  @override
  _SensorPageState createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  String sensorName = "";
  String sensorLocation = "";
  String sensorGroup = "";
  int documentCount;
  Stream telemetryStream;

  void countDocs() async {
    final QuerySnapshot qSnap = await Firestore.instance
        .collection('TemperatureTelemetry')
        .where('sensorGroup', isEqualTo: sensorGroup)
        .where('sensorLocation', isEqualTo: sensorLocation)
        .where('alarmTriggered', isEqualTo: true)
        .get();
    documentCount = qSnap.docs.length;
    print("Total docs: " + documentCount.toString());
  }

  @override
  void initState() {
    sensorName = widget.msg.id;
    sensorLocation = widget.msg.data()['sensorLocation'];
    sensorGroup = widget.msg.data()['sensorGroup'];

    telemetryStream = FirebaseFirestore.instance
        .collection("TemperatureTelemetry")
        .where('sensorGroup', isEqualTo: sensorGroup)
        .where('sensorLocation', isEqualTo: sensorLocation)
        .where('alarmTriggered', isEqualTo: true)
        .snapshots();

    countDocs();
    print(sensorLocation);
    print(sensorGroup);
    print(sensorName);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 24.0, bottom: 6.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Image(
                            image:
                                AssetImage('assets/images/back_arrow_icon.png'),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Text(
                        sensorName,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF211551),
                        ),
                      ))
                    ],
                  ),
                ), // Top Bar with Title editing
                Padding(
                    padding: EdgeInsets.only(
                      left: 24.0,
                      bottom: 10.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Sensor Location: " + sensorLocation,
                            style: TextStyle(
                                fontSize: 16, color: Color(0xFF86829D))),
                        Text("Sensor Group: " + sensorGroup,
                            style: TextStyle(
                                fontSize: 16, color: Color(0xFF86829D))),
                      ],
                    )),
                StreamBuilder<QuerySnapshot>(
                    stream: telemetryStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData && documentCount != 0) {
                        return Container(
                          width: double.infinity,
                          height: 280,
                          child: ScrollConfiguration(
                            behavior: NoGlowScrollBehavior(),
                            child: ListView.builder(
                              itemCount: snapshot.data.size,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    var _type = FeedbackType.medium;
                                    Vibrate.feedback(_type);
                                    if (snapshot.data.docs[index]
                                            .data()['alarmAcknowledged'] ==
                                        false) {
                                      FirebaseFirestore.instance
                                          .collection("TemperatureTelemetry")
                                          .doc(snapshot.data.docs[index].id)
                                          .update({"alarmAcknowledged": true});
                                      print("changed to true");
                                    } else {
                                      await FirebaseFirestore.instance
                                          .collection("TemperatureTelemetry")
                                          .doc(snapshot.data.docs[index].id)
                                          .update({"alarmAcknowledged": false});
                                      print("changed to false");
                                    }

                                    print("alarm pressed changed to: " +
                                        snapshot.data.docs[index]
                                            .data()['alarmAcknowledged']
                                            .toString());
                                    setState(() {});
                                  },
                                  child: AlarmTriggeredWidget(
                                    timeStamp: snapshot.data.docs[index].id,
                                    temperature: double.parse(snapshot
                                        .data.docs[index]
                                        .data()['temperature']),
                                    alarmAcknowledged: snapshot.data.docs[index]
                                                .data()['alarmAcknowledged'] ==
                                            false
                                        ? false
                                        : true,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      } else
                        return Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Center(
                              child: Text("No alarms triggered!",
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      color: Color(0xFF86829D)))),
                        );
                    }),

                Expanded(
                  child: Center(
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("TemperatureTelemetry")
                            .where('sensorGroup', isEqualTo: sensorGroup)
                            .where('sensorLocation', isEqualTo: sensorLocation)
                            .snapshots(),
                        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Text("No Data");
                          } else {
                            var temperature = snapshot.data.docs.last.data()['temperature'];
                            var alarmTriggered = snapshot.data.docs.last.data()['alarmTriggered'];
                            print(snapshot.data.docs.last.data());

                            return Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                  border: Border.all(width: 3, color: alarmTriggered ? Colors.red : Colors.green),
                                  borderRadius: BorderRadius.all(Radius.circular(200)),
                                  //shape: BoxShape.circle,
                                  color: Colors.white),
                              child: Center(child: Text(temperature + "°C", style: TextStyle(
                                fontSize: 45.0,
                                fontWeight: FontWeight.bold,
                              ),)),
                            );
                          }
                        }),
                  ),
                )

                // Description Editing
                /* FutureBuilder(
                  initialData: [],
                  future: _dbHelper.getTriggeredTemperatureTelemetry(
                      sensorLocation, sensorGroup),
                  builder: (context, snapshot) {
                    if (snapshot.data.length == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          top: 80,
                        ),
                        child: Center(child: Text("No alarms triggered!", style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF86829D),
                        ),)),
                      );
                    } else {
                      return Container(
                        width: double.infinity,
                        height: 200,
                        child: ScrollConfiguration(
                          behavior: NoGlowScrollBehavior(),
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  var _type = FeedbackType.medium;
                                  Vibrate.feedback(_type);
                                  if (snapshot.data[index].alarmAcknowledged ==
                                      0) {
                                    await _dbHelper.updateTelemetryAcknowledged(
                                        snapshot.data[index].timeStamp, 1);
                                  } else {
                                    await _dbHelper.updateTelemetryAcknowledged(
                                        snapshot.data[index].timeStamp, 0);
                                  }
                                  setState(() {});
                                },
                                child: AlarmTriggeredWidget(
                                  timeStamp: snapshot.data[index].timeStamp,
                                  temperature: snapshot.data[index].temperature,
                                  alarmAcknowledged:
                                      snapshot.data[index].alarmAcknowledged ==
                                              0
                                          ? false
                                          : true,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }
                  },
                ), // Triggered alarms list*/
              ],
            ),
          ],
        )),
      ),
    );
  }
}
