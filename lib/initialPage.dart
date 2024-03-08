import 'package:ble_advertiser/main.dart';
import 'package:flutter/material.dart';

import 'package:ble_advertiser/perspectives/student/login.dart';
import 'package:ble_advertiser/perspectives/teacher/login.dart';

import 'package:ble_advertiser/perspectives/student/phone_auth.dart';
import 'package:ble_advertiser/perspectives/teacher/phone_auth.dart';

class InitialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Attendance System'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentPhoneAuth()),
                );
              },
              child: Text('Student'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TeacherPhoneAuth()),
                );
              },
              child: Text('Teacher'),
            ),
          ],
        ),
      ),
    );
  }
}
