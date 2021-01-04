
class TemperatureTelemetry {
  // Variabler som ikke kommer til at ændre sig, derfor 'final' bliver brugt
  final String timeStamp;
  final double temperature;
  final String sensorLocation;
  final String sensorGroup;
  final int alarmTriggered;
  final int alarmAcknowledged;

  // Constructor
  TemperatureTelemetry(
      {this.timeStamp,
      this.temperature,
      this.sensorLocation,
      this.sensorGroup,
      this.alarmTriggered,
      this.alarmAcknowledged});

  // Funktion til at returnere et map.
  Map<String, dynamic> toMap() {
    return {
      'timeStamp': timeStamp,
      'temperature': temperature,
      'sensorLocation': sensorLocation,
      'sensorGroup': sensorGroup,
      'alarmTriggered': alarmTriggered,
      'alarmAcknowledged': alarmAcknowledged
    };
  }
}
