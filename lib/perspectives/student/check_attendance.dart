import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ble_advertiser/colors.dart';
import 'package:ble_advertiser/main.dart';
import 'package:ble_advertiser/perspectives/student/home.dart';
import 'package:ble_advertiser/info.dart';

class StudentAttendancePage extends StatefulWidget {
  const StudentAttendancePage({Key? key}) : super(key: key);

  @override
  _StudentAttendancePageState createState() => _StudentAttendancePageState();
}

class _StudentAttendancePageState extends State<StudentAttendancePage> {
  int _currentPageIndex =
      1; // Set the initial page index to 1 for Check Attendance

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Attendance'),
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
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('subjects').get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(
              color: Colors.white,
            );
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          final subjects = snapshot.data!.docs;
          return ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                String subjectName = subjects[index]['subject'];
                return Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 8,
                    right: 10,
                    left: 10,
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: lightest,
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '$subjectName',
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Your Attendance',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        color: darkest,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: buildBottomNavItem(Icons.home, 0, 'Home'),
            ),
            Expanded(
              child:
                  buildBottomNavItem(Icons.assignment, 1, 'Check Attendance'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBottomNavItem(IconData icon, int pageIndex, String tooltip) {
    bool isSelected = _currentPageIndex == pageIndex;

    return IconButton(
      icon: Icon(
        icon,
        size: 30,
        color: isSelected ? Colors.white : middle,
      ),
      onPressed: () {
        setState(() {
          _currentPageIndex = pageIndex;
        });
        if (pageIndex == 0) {
          Navigator.pushReplacementNamed(context, '/student_home');
        } else if (pageIndex == 1) {
          Navigator.pushReplacementNamed(context, '/student_checkattendance');
        }
      },
      tooltip: tooltip,
    );
  }
}
