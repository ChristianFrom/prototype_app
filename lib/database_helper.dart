import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'models/temperatureSensor.dart';
import 'models/temperatureTelemetry.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'temperatureSensor.db'),
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE temperatureSensors("
            "sensorName TEXT PRIMARY KEY, "
            "sensorLocation TEXT, "
            "sensorGroup TEXT)");
        await db.execute("CREATE TABLE temperatureTelemetry("
            "timeStamp TEXT PRIMARY KEY,"
            "temperature REAL, "
            "sensorLocation TEXT, "
            "sensorGroup TEXT, "
            "alarmTriggered INTEGER, "
            "alarmAcknowledged INTEGER)");

        return db;
      },
      version: 1,
    );
  }

  void insertDummyData() {
    TemperatureSensor sensor1 = TemperatureSensor(
        sensorName: "Sensor #1", sensorLocation: "Hjem", sensorGroup: "Kontor");

    TemperatureSensor sensor2 = TemperatureSensor(
        sensorName: "Sensor #2", sensorLocation: "Hjem", sensorGroup: "Køkken");

    TemperatureTelemetry telemetry1 = TemperatureTelemetry(
        timeStamp: DateTime.now().toString(),
        temperature: 30.5,
        sensorLocation: "Hjem",
        sensorGroup: "Kontor",
        alarmTriggered: 1,
        alarmAcknowledged: 0);

    TemperatureTelemetry telemetry2 = TemperatureTelemetry(
        timeStamp: DateTime.now().toString(),
        temperature: 33.0,
        sensorLocation: "Hjem",
        sensorGroup: "Køkken",
        alarmTriggered: 1,
        alarmAcknowledged: 0);

    TemperatureTelemetry telemetry3 = TemperatureTelemetry(
        timeStamp: DateTime.now().toString(),
        temperature: 35.4,
        sensorLocation: "Hjem",
        sensorGroup: "Køkken",
        alarmTriggered: 1,
        alarmAcknowledged: 0);

    insertTemperatureSensor(sensor1);
    insertTemperatureSensor(sensor2);

    insertTemperatureTelemetry(telemetry1);
    insertTemperatureTelemetry(telemetry2);
    insertTemperatureTelemetry(telemetry3);

    print("Dummy data inserted");
  }

  Future<void> insertTemperatureSensor(TemperatureSensor sensor) async {
    Database _db = await database();
    await _db.insert('temperatureSensors', sensor.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertTemperatureTelemetry(
      TemperatureTelemetry telemetry) async {
    Database _db = await database();
    await _db.insert('temperatureTelemetry', telemetry.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<TemperatureSensor>> getTemperatureSensors() async {
    Database _db = await database();
    List<Map<String, dynamic>> sensorMap =
        await _db.query('temperatureSensors');
    return List.generate(sensorMap.length, (index) {
      return TemperatureSensor(
          sensorName: sensorMap[index]['sensorName'],
          sensorLocation: sensorMap[index]['sensorLocation'],
          sensorGroup: sensorMap[index]['sensorGroup']);
    });
  }

  Future<List<TemperatureTelemetry>> getTriggeredTemperatureTelemetry(
      String sensorLocation, String sensorGroup) async {
    Database _db = await database();
    List<Map<String, dynamic>> sensorMap = await _db.rawQuery(
        "SELECT * FROM temperatureTelemetry WHERE sensorLocation = '$sensorLocation' AND sensorGroup = '$sensorGroup' AND alarmTriggered = 1");
    return List.generate(sensorMap.length, (index) {
      return TemperatureTelemetry(
          timeStamp: sensorMap[index]['timeStamp'],
          temperature: sensorMap[index]['temperature'],
          sensorLocation: sensorMap[index]['sensorLocation'],
          sensorGroup: sensorMap[index]['sensorGroup'],
          alarmTriggered: sensorMap[index]['alarmTriggered'],
          alarmAcknowledged: sensorMap[index]['alarmAcknowledged']);
    });
  }

  Future<void> updateTelemetryAcknowledged(
      String timeStamp, int alarmAcknowledged) async {
    Database _db = await database();
    await _db.rawUpdate(
        "UPDATE temperatureTelemetry SET alarmAcknowledged = '$alarmAcknowledged' WHERE timeStamp = '$timeStamp'");
  }
}
