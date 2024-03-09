import 'dart:ffi';

import 'package:ble_advertiser/info.dart';
import 'package:ble_advertiser/perspectives/student/phone_auth.dart';
import 'package:ble_advertiser/perspectives/teacher/email_auth.dart';
import 'package:ble_advertiser/perspectives/teacher/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ble_advertiser/perspectives/student/login.dart';
import 'package:ble_advertiser/colors.dart';
import 'package:ble_advertiser/info.dart';

class ChooseRolePage extends StatefulWidget {
  const ChooseRolePage({Key? key}) : super(key: key);

  @override
  _ChooseRolePageState createState() => _ChooseRolePageState();
}

class _ChooseRolePageState extends State<ChooseRolePage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => checkLoggedIn());
  }

  void checkLoggedIn() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = await auth.authStateChanges().first;
    if (user != null) {
      if (user.phoneNumber != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StudentLoginPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TeacherHomePage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Your Role'),
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
              child: Text(
                'Student',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TeacherEmailAuth()),
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
              child: Text(
                'Teacher',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
