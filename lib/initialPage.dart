import 'package:ble_advertiser/perspectives/student/phone_auth.dart';
import 'package:ble_advertiser/perspectives/teacher/email_auth.dart';
import 'package:ble_advertiser/perspectives/teacher/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ble_advertiser/perspectives/student/login.dart';

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
//yo chai for not directly logging in once you've been verified, last ma uncomment garne


  void checkLoggedIn() async {
    User? user = auth.currentUser;
    User? teacher=auth.currentUser;
    if (user != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentLoginPage())); // Navigate to the home page based on user role
    }
    if (teacher!=null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TeacherHomePage()));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Your Role'),
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
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TeacherEmailAuth()),
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
