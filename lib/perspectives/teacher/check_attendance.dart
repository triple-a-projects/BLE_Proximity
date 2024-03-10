import 'package:ble_advertiser/perspectives/teacher/attendance.dart';
import 'package:ble_advertiser/perspectives/teacher/teacher_base.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ble_advertiser/perspectives/teacher/home.dart';
import 'package:ble_advertiser/colors.dart';
import 'package:ble_advertiser/perspectives/teacher/addclass.dart';
import 'package:ble_advertiser/info.dart';

class TeacherAttendancePage extends StatelessWidget {
  const TeacherAttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return TeacherBasePage(
      title: 'Check Attendance',
      currentPageIndex: 2,
      buildBody: (context) => StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('subjects').snapshots(),
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

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final Map<String, dynamic> data =
                  documents[index].data() as Map<String, dynamic>;
              final String subjectName = data['subject'];
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
                  elevation: 3,
                  color: lightest,
                  child: ListTile(
                    title: Text(
                      subjectName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AttendanceTable())); // Handle onTap
                      },
                      child: const Icon(Icons.edit, color: Colors.black),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    ); //Base Page
  }
}
