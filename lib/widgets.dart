import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SensorCardWidget extends StatelessWidget {
  final String sensorName;
  final String sensorLocation;
  final String sensorGroup;

  SensorCardWidget({this.sensorName, this.sensorLocation, this.sensorGroup});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 32.0,
      ),
      margin: EdgeInsets.only(
        bottom: 20.0,
      ),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sensorName ?? "(Unnamed sensor)",
                style: TextStyle(
                  color: Color(0xFF211551),
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                child: Text(
                  sensorLocation + " - " + sensorGroup ?? "No location added",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Color(0xFF86829D),
                    height: 1.5,
                  ),
                ),
              )
            ],
          ),
          StreamBuilder(
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

                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 120.0
                    ),
                    child: Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                          border: Border.all(width: 3, color: alarmTriggered ? Colors.red : Colors.green),
                          borderRadius: BorderRadius.all(Radius.circular(200)),
                          //shape: BoxShape.circle,
                          color: Colors.white),
                      child: Center(child: Text(temperature + "°C", style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),)),
                    ),
                  );
                }
              })
        ],
      ),
    );
  }
}

class AlarmTriggeredWidget extends StatelessWidget {
  final String timeStamp;
  final double temperature;
  final bool alarmAcknowledged;

  AlarmTriggeredWidget(
      {@required this.timeStamp,
      @required this.temperature,
      @required this.alarmAcknowledged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 8.0,
      ),
      child: Row(
        children: [
          Container(
            width: 20.0,
            height: 20.0,
            margin: EdgeInsets.only(
              right: 12.0,
            ),
            decoration: BoxDecoration(
                color: alarmAcknowledged ? Colors.green : Colors.transparent,
                borderRadius: BorderRadius.circular(6.0),
                border: alarmAcknowledged
                    ? null
                    : Border.all(
                        color: Color(0xFF86829D),
                        width: 1.5,
                      )),
            child: Image(
              image: AssetImage('assets/images/check_icon.png'),
            ),
          ),
          Flexible(
            child: Text(
              "Alarm Triggered: $timeStamp at $temperature°C " ??
                  "(No data available...)",
              style: TextStyle(
                color:
                    alarmAcknowledged ? Color(0xFF211511) : Color(0xFF86829D),
                fontSize: 14.0,
                fontWeight:
                    alarmAcknowledged ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
