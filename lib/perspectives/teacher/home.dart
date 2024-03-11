import 'package:ble_advertiser/perspectives/student/student_base.dart';
import 'package:ble_advertiser/perspectives/teacher/settings.dart';
import 'package:ble_advertiser/perspectives/teacher/teacher_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ble_advertiser/perspectives/teacher/addclass.dart';
import 'package:ble_advertiser/colors.dart';
import 'package:ble_advertiser/info.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({Key? key});

  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentPageIndex = 0;
  List<String> buttonTexts = [];
  bool classStarted = false;
  final String esp32IP = '192.168.1.81';

  @override
  Widget build(BuildContext context) {
    return TeacherBasePage(
      title: 'Dashboard',
      currentPageIndex: _currentPageIndex,
      buildBody: (context) => FutureBuilder<List<String>>(
        future: getTeacherNames(),
        builder: (context, teacherNamesSnapshot) {
          if (teacherNamesSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(color: Colors.white));
          }

          if (teacherNamesSnapshot.hasError) {
            return Center(child: Text('Error: ${teacherNamesSnapshot.error}'));
          }

          final List<String> teacherNames = teacherNamesSnapshot.data ?? [];

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('subjects')
                .where('teacherName', whereIn: teacherNames)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final List<DocumentSnapshot> documents = snapshot.data!.docs;

              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: documents.map((document) {
                          final subjectName = document['subject'] as String;
                          final index = documents.indexOf(document);
                          while (buttonTexts.length <= index) {
                            buttonTexts.add('Start Class');
                          }
                          return Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 8,
                              right: 10,
                              left: 10,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: lightest),
                                borderRadius: BorderRadius.circular(15),
                                color: lightest,
                              ),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 5),
                                      child: Text(
                                        subjectName,
                                        style: const TextStyle(
                                            fontSize: 20, color: Colors.black),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        final isStartPressed =
                                            buttonTexts[index] == 'Start Class';
                                        if(classStarted){
                                          stopBLEScan();
                                        } else {
                                          startBLEScan();
                                        }
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Row(
                                              children: [
                                                Icon(Icons.check,
                                                    color: Colors.white),
                                                SizedBox(width: 8),
                                                Text(isStartPressed
                                                    ? 'Class Started Successfully'
                                                    : 'Class Ended Sucessfully')
                                              ],
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );

                                        setState(() {
                                          buttonTexts[index] =
                                              (buttonTexts[index] ==
                                                      'Start Class')
                                                  ? 'End Class'
                                                  : 'Start Class';
                                          ;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: middle,
                                        textStyle: GoogleFonts.nunito(
                                            fontSize: 20, color: Colors.black),
                                      ),
                                      child: Text(buttonTexts[index],
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    ); //BasePage
  }

  void startBLEScan() async {
    try {
      final response = await http.post(
        Uri.parse('http://$esp32IP/startScan'),
      );
      print('Scanning');
      setState(() {
        classStarted = true;
      });
      print('Response: ${response.statusCode} ${response.body}');
    } catch (e) {
      print('Error starting BLE scan: $e');
    }
  }

  void stopBLEScan() async {
    try {
      final response = await http.post(
        Uri.parse('http://$esp32IP/stopScan'),
      );
      print('Stopping');
      setState(() {
        classStarted = false;
      });
      print('Response: ${response.statusCode} ${response.body}');
    } catch (e) {
      print('Error stopping BLE scan: $e');
    }
  }

  Future<List<String>> getTeacherNames() async {
    final teachersCollection =
        FirebaseFirestore.instance.collection('teachers');
    final querySnapshot = await teachersCollection.get();
    final List<String> teacherNames = [];
    querySnapshot.docs.forEach((doc) {
      teacherNames.add(doc['name'] as String);
    });
    return teacherNames;
  }
}
