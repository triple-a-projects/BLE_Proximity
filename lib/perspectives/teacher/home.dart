import 'package:ble_advertiser/perspectives/teacher/settings.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ble_advertiser/perspectives/teacher/addclass.dart';
import 'package:ble_advertiser/colors.dart';
import 'package:ble_advertiser/perspectives/teacher/check_attendance.dart';
import 'package:ble_advertiser/info.dart';

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({Key? key});

  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Dashboard'),
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
              })
        ],
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('subjects').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final List<DocumentSnapshot> documents = snapshot.data!.docs;

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Container(
                
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  
                  children: documents.map((document) {
                    final subjectName = document['subject'] as String;
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
                          color:lightest,
                        ),
                        child: Column(
                          
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                subjectName,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.black),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Handle button press
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: middle,
                                  textStyle: const TextStyle(fontSize: 20, color: Colors.black),
                                ),
                                child: const Text('Start Class',
                                    style: TextStyle(color: Colors.black)),
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
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        color: darkest,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, size: 30, color: middle),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TeacherHomePage()),
                );
              },
              tooltip: 'Home',
              color: darkest,
            ),
            IconButton(
              icon: const Icon(
                Icons.add_circle_outline_outlined,
                size: 35,
                color: middle,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddClass()),
                );
              },
              tooltip: 'Add Class',
              color: darkest,
            ),
            IconButton(
              icon: const Icon(
                Icons.assignment,
                size: 30,
                color: middle,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TeacherAttendancePage()),
                );
              },
              tooltip: 'Check Attendance',
              color: darkest,
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              height: 100,
            
            child: const DrawerHeader(
              decoration: BoxDecoration(
                color: darkest,
              ),
              padding: EdgeInsets.all(20),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
            ),
        ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TeacherSettingsPage()),
                  );
              },
            ),
            ListTile(
              title: const Text('About Us'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InfoPage()),
                  );
              },
            ),
          ],
        ),
      ),
    );
  }
}
