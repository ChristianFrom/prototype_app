import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool useAWS;
  bool useAzure;

  @override
  void initState() {
    super.initState();
    useAWS = false;
    useAzure = false;
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 30.0,
            ),
            child: Text(
              "Settings",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF211551)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 15.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Service Provider",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF211511),
                  ),
                ),
                Container(
                  child: ButtonBar(
                    alignment: MainAxisAlignment.start,
                    children: <Widget>[
                      TextButton(
                        child: new Text(
                          "Amazon AWS",
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          primary: useAWS ? Colors.white : Colors.blue,
                          backgroundColor:
                              useAWS ? Color(0xFF2699FB) : Color(0xFFF1F9FF),
                        ),
                        onPressed: changeToAWS,
                      ),
                      TextButton(
                        child: new Text(
                          'Microsoft Azure',
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          primary: useAzure ? Colors.white : Colors.blue,
                          backgroundColor:
                              useAzure ? Color(0xFF2699FB) : Color(0xFFF1F9FF),
                        ),
                        onPressed: changeToAzure,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }

  Future<Null> getPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    useAWS = prefs.getBool('useAWS');
    useAzure = prefs.getBool('useAzure');
    setState(() {});
  }

  Future<Null> changeToAWS() async {
    if (!useAWS) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('useAWS', true);
      prefs.setBool('useAzure', false);

      setState(() {
        useAWS = true;
        useAzure = false;
      });
      print("set to aws");
    }
  }

  Future<Null> changeToAzure() async {
    if (!useAzure) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('useAWS', false);
      prefs.setBool('useAzure', true);

      setState(() {
        useAWS = false;
        useAzure = true;
      });
      print("set to azure");
    }
  }
}
