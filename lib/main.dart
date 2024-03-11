import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'package:ble_advertiser/colors.dart';
import 'package:ble_advertiser/info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ble_advertiser/initialPage.dart';
import 'package:ble_advertiser/perspectives/student/check_attendance.dart';
import 'package:ble_advertiser/perspectives/student/home.dart';
import 'package:ble_advertiser/perspectives/student/login.dart';
import 'package:ble_advertiser/perspectives/student/phone_auth.dart';
import 'package:ble_advertiser/perspectives/teacher/addclass.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ble_advertiser/perspectives/teacher/check_attendance.dart';
import 'package:ble_advertiser/perspectives/teacher/home.dart';
import 'package:ble_advertiser/perspectives/teacher/email_auth.dart';
import 'package:ble_advertiser/perspectives/student/phone_auth.dart';

import 'package:firebase_core/firebase_core.dart';
//import 'package:ble_advertiser/login.dart';

import 'firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';
import 'package:uuid/uuid.dart';
import 'package:ble_advertiser/animation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '': (context) => const ChooseRolePage(),
        '/student_phoneauth': (context) => const StudentPhoneAuth(),
        '/student_login': (context) => const StudentLoginPage(),
        '/student_home': (context) => const StudentHomePage(),
        '/student_checkattendance': (context) => const StudentAttendancePage(),
        '/teacher_emailauth': (context) => const TeacherEmailAuth(),
        '/teacher_home': (context) => const TeacherHomePage(),
        '/teacher_checkattendance': (context) => const TeacherAttendancePage(),
        '/teacher_addclass': (context) => const AddClass(),
      },
      debugShowCheckedModeBanner: false,
      title: 'BLE Peripheral',
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoTextTheme(),
        primarySwatch: Colors.blue,
      ),
      home: const ChooseRolePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isAdvertising = false;
  Timer? advertiseTime;
  String uniqueUUID = const Uuid().v4();
  String rollNumber = rollNumberOfStudent;
  // String rollNumberOfStudent = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    advertiseTime?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Attend Class'),
          backgroundColor: darkest,
          foregroundColor: Colors.white,
          automaticallyImplyLeading: true,
          actions: [
            IconButton(
                icon: const Icon(
                  Icons.info_outlined,
                  color: lightest,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    PageTransitionAnimation(
                      page: InfoPage(),
                    ),
                  );
                })
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'ROLL NUMBER: \n $rollNumber',
                style: const TextStyle(
                    fontSize: 30, color: darkest, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  if (isAdvertising) {
                    stopAdvertising();
                  } else {
                    startAdvertising();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondDark,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.only(
                    top: 15,
                    bottom: 15,
                    right: 50,
                    left: 50,
                  ),
                ),
                child:
                    Text(isAdvertising ? 'Stop Attending' : 'Start Attending'),
              ),
              if (isAdvertising)
                const SizedBox(
                    height: 50,
                    child: Center(
                      child: Text('You are attending the class...',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold)),
                    ))
            ],
          ),
        ));
  }

  Future<void> startAdvertising() async {
    String serviceUUID = 'bf27730d-860a-4e09-889c-2d8b6a9e0fe7';
    // String rollNumberOfStudent = await fetchRollNumber();
    List<int> manufactData = utf8.encode(rollNumberOfStudent);
    print("ManufacturerData:$manufactData");
    AdvertiseData advertiseData = AdvertiseData(
      serviceUuid: serviceUUID,
      manufacturerId: 0xFFFF,
      manufacturerData: Uint8List.fromList(manufactData),
    );

    AdvertiseSetParameters advertiseSetParameters = AdvertiseSetParameters();
    advertiseTime = Timer.periodic(Duration(seconds: 2), (timer) {
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

  Future<String> fetchRollNumber() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String userUID = currentUser.uid;
      print("UserID:$userUID");
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userUID)
          .get();
      if (userDoc.exists) {
        rollNumber = userDoc.get('rollNo');
        print("Roll Number: $rollNumber");
      } else {
        rollNumber = "Null";
        print('User document not found.');
      }
    } else {
      rollNumber = "No user found";
      print('No current user found.');
    }
    return rollNumber;
  } 
}
