import 'package:flutter/material.dart';
import 'package:prototype_app/database_helper.dart';
import 'package:prototype_app/models/temperatureSensor.dart';
import 'package:prototype_app/widgets.dart';

class SensorPage extends StatefulWidget {
  final TemperatureSensor sensor;

  SensorPage({@required this.sensor});

  @override
  _SensorPageState createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  String sensorName = "";
  String sensorLocation = "";
  String sensorGroup = "";

  @override
  void initState() {
    if (widget.sensor != null) {
      sensorName = widget.sensor.sensorName;
      sensorLocation = widget.sensor.sensorLocation;
      sensorGroup = widget.sensor.sensorGroup;
    }

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
                    )), // Description Editing
                FutureBuilder(
                  initialData: [],
                  future: _dbHelper.getTriggeredTemperatureTelemetry(
                      sensorLocation, sensorGroup),
                  builder: (context, snapshot) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              if (snapshot.data[index].alarmAcknowledged == null) {
                                await _dbHelper.updateTelemetryAcknowledged(
                                    snapshot.data[index].timeStamp, 1);
                              } else {
                                await _dbHelper.updateTelemetryAcknowledged(
                                    snapshot.data[index].timeStamp, 0);
                              }
                              print(snapshot.data[index].alarmAcknowledged.toString());
                              setState(() {});
                            },
                            child: AlarmTriggeredWidget(
                              timeStamp: snapshot.data[index].timeStamp,
                              temperature: snapshot.data[index].temperature,
                              alarmAcknowledged:
                                  snapshot.data[index].alarmAcknowledged == 0
                                      ? false
                                      : true,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ), // Triggered alarms list
              ],
            ),
          ],
        )),
      ),
    );
  }
}
