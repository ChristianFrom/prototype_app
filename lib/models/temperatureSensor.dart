class TemperatureSensor {
  final String sensorName;
  final String sensorLocation;
  final String sensorGroup;

  TemperatureSensor({this.sensorName, this.sensorLocation, this.sensorGroup});

  Map<String, dynamic> toMap() {
    return {
      'sensorName': sensorName,
      'sensorLocation': sensorLocation,
      'sensorGroup': sensorGroup
    };
  }
}
