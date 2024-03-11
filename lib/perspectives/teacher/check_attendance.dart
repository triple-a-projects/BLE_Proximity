import 'package:ble_advertiser/perspectives/teacher/attendance.dart';
import 'package:ble_advertiser/perspectives/teacher/teacher_base.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ble_advertiser/perspectives/teacher/home.dart';
import 'package:ble_advertiser/colors.dart';
import 'package:ble_advertiser/perspectives/teacher/addclass.dart';
import 'package:ble_advertiser/info.dart';
import 'package:ble_advertiser/animation.dart';

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
              final Map<String, dynamic> data = documents[index].data() as Map<String, dynamic>;
              final String subjectName = data['subject'];
              final String teacherName = data['teacherName']; // Retrieve teacher's name from the subject data
              return FutureBuilder<bool>(
                future: isTeacherAssociatedWithSubject(teacherName),
                builder: (context, teacherAssociatedSnapshot) {
                  if (teacherAssociatedSnapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(color: Colors.white);
                  }

                  if (teacherAssociatedSnapshot.hasError) {
                    return Text('Error: ${teacherAssociatedSnapshot.error}');
                  }

                  final bool isTeacherAssociated = teacherAssociatedSnapshot.data ?? false;

                  if (isTeacherAssociated) {
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
                              Navigator.of(context).push(
                                PageTransitionAnimation(
                                  page: AttendanceTable(),
                                ),
                              ); // Handle onTap
                            },
                            child: const Icon(Icons.edit, color: Colors.black),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox(); // Return an empty container if the teacher is not associated with the subject
                  }
                },
              );
            },
          );
        },
      ),
    ); //Base Page
  }

  Future<bool> isTeacherAssociatedWithSubject(String teacherName) async {
    final teachersCollection = FirebaseFirestore.instance.collection('teachers');
    final querySnapshot = await teachersCollection.where('name', isEqualTo: teacherName).get();
    return querySnapshot.docs.isNotEmpty;
  }
}