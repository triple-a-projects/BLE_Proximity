import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ble_advertiser/initialPage.dart';
import 'package:ble_advertiser/perspectives/student/check_attendance.dart';
import 'package:ble_advertiser/perspectives/student/home.dart';
import 'package:ble_advertiser/perspectives/student/login.dart';
import 'package:ble_advertiser/perspectives/student/phone_auth.dart';
import 'package:ble_advertiser/perspectives/teacher/addclass.dart';

import 'package:ble_advertiser/perspectives/teacher/check_attendance.dart';
import 'package:ble_advertiser/perspectives/teacher/home.dart';
import 'package:ble_advertiser/perspectives/teacher/login.dart';
import 'package:ble_advertiser/perspectives/teacher/email_auth.dart';

import 'package:firebase_core/firebase_core.dart';
//import 'package:ble_advertiser/login.dart';

import 'firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';
import 'package:uuid/uuid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '': (context) => InitialPage(),
        '/student_phoneauth': (context) => StudentPhoneAuth(),
        '/student_login': (context) => StudentLoginPage(),
        '/student_home': (context) => StudentHomePage(),
        '/student_checkattendance': (context) => StudentAttendancePage(),
        '/teacher_phoneauth': (context) => TeacherEmailAuth(),
        '/teacher_login': (context) => TeacherLoginPage(),
        '/teacher_home': (context) => TeacherHomePage(),
        '/teacher_checkattendance': (context) => TeacherAttendancePage(),
        '/teacher_addclass': (context) => AddClass(),
      },
      debugShowCheckedModeBanner: false,
      title: 'BLE Peripheral',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InitialPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isAdvertising = false;
  Timer? advertiseTime;
  String uniqueUUID = Uuid().v4();
  String rollNumber = '';

  @override
  void initState() {
    super.initState();
    fetchRollNumber();
  }

  @override
  void dispose() {
    advertiseTime?.cancel();
    super.dispose();
  }

  Future<void> fetchRollNumber() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String userUID = currentUser.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userUID)
          .get();
      if (userDoc.exists) {
        setState(() {
          rollNumber = userDoc.get('rollNo');
        });
      } else {
        print('User document not found.');
      }
    } else {
      print('No current user found.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('BLE Peripheral'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Text(rollNumber),
            Container(
              child: TextButton(
                onPressed: () {
                  if (isAdvertising) {
                    stopAdvertising();
                  } else {
                    startAdvertising();
                  }
                },
                child: Text(
                    isAdvertising ? 'Stop Advertising' : 'Start Advertising'),
              ),
            ),
          ],
        ));
  }

  Future<void> startAdvertising() async {
    String serviceUUID = 'bf27730d-860a-4e09-889c-2d8b6a9e0fe7';
    String serviceDataUUID = generateUUIDRollNumber(rollNumber);
    List<int> manufactData = utf8.encode(rollNumber);

    AdvertiseData advertiseData = AdvertiseData(
      serviceUuid: serviceUUID,
      manufacturerId: 0xFFFF,
      manufacturerData: Uint8List.fromList(manufactData),
    );

    AdvertiseSetParameters advertiseSetParameters = AdvertiseSetParameters();
    advertiseTime = Timer.periodic(Duration(seconds: 5), (timer) {
      try {
        FlutterBlePeripheral().start(
            advertiseData: advertiseData,
            advertiseSetParameters: advertiseSetParameters);
        setState(() {
          isAdvertising = true;
        });
      } catch (e) {
        print('Error starting advertising: $e');
      }
    });
  }

  Future<void> stopAdvertising() async {
    try {
      await FlutterBlePeripheral().stop();
      setState(() {
        isAdvertising = false;
        advertiseTime?.cancel();
      });
    } catch (e) {
      print('Error stopping advertising: $e');
    }
  }

  String generateUUIDRollNumber(String rollNumber) {
    String uniqueUUID = Uuid().v5(Uuid.NAMESPACE_URL, rollNumber);
    String serviceDataUUID = '0000$uniqueUUID-0000-1000-8000-00805f9b34fb';
    String serviceRollNumber = serviceDataUUID.replaceAll('-', '');
    return serviceRollNumber;
  }
}
