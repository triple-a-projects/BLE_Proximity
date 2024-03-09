import 'package:ble_advertiser/colors.dart';
import 'package:ble_advertiser/main.dart';
import 'package:ble_advertiser/perspectives/student/home.dart';
import 'package:ble_advertiser/perspectives/teacher/home.dart';
import 'package:flutter/material.dart';
import 'package:ble_advertiser/info.dart';

class TeacherSettingsPage extends StatefulWidget {
  const TeacherSettingsPage({Key? key}) : super(key: key);

  @override
  _TeacherSettingsPageState createState() => _TeacherSettingsPageState();
}

class _TeacherSettingsPageState extends State<TeacherSettingsPage> {
  bool notificationSwitchValue = true;
  double volumeSliderValue = 50.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: darkest,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              Icons.info_outlined,
              color: lightest,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InfoPage()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifications',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: Text('Receive Notifications'),
              activeColor: secondDark,
              value: notificationSwitchValue,
              onChanged: (value) {
                setState(() {
                  notificationSwitchValue = value;
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Volume',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: volumeSliderValue,
              onChanged: (value) {
                setState(() {
                  volumeSliderValue = value;
                });
              },
              min: 0,
              max: 100,
              divisions: 10,
              label: volumeSliderValue.round().toString(),
              activeColor: secondDark,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TeacherHomePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: middle,
                foregroundColor: Colors.white,
                padding: EdgeInsets.only(
                  left: 50,
                  right: 50,
                  top: 15,
                  bottom: 15,
                ),
              ),
              child: Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
