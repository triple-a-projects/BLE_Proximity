import 'package:ble_advertiser/perspectives/student/student_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ble_advertiser/colors.dart';
import 'package:ble_advertiser/info.dart';

class StudentAttendancePage extends StatefulWidget {
  const StudentAttendancePage({super.key});

  @override
  _StudentAttendancePageState createState() => _StudentAttendancePageState();
}

class _StudentAttendancePageState extends State<StudentAttendancePage> {
  int _currentPageIndex =
      1; // Set the initial page index to 1 for Check Attendance

  @override
  Widget build(BuildContext context) {
    return StudentBasePage(
      title: 'Attendance',
      currentPageIndex: _currentPageIndex,
      buildBody: (context) => FutureBuilder(
        future: FirebaseFirestore.instance.collection('subjects').get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(
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
                          Flexible(child: 
                          Text(
                            subjectName,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          )
                        ],
                      ),
                      subtitle: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Your Attendance: 0%',
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
    );
  }
}
