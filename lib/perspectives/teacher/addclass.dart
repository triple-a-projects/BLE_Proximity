import 'package:ble_advertiser/perspectives/teacher/teacher_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ble_advertiser/perspectives/teacher/home.dart';
import 'package:ble_advertiser/colors.dart';
import 'package:ble_advertiser/perspectives/teacher/check_attendance.dart';
import 'package:ble_advertiser/info.dart';

class AddClass extends StatefulWidget {
  const AddClass({super.key});

  @override
  _AddClassState createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  String? selectedSubject;
  String? selectedFaculty;
  String? selectedSemester;

  List<String> subjects = [
    'Communication English',
    'Communication System',
    'Project Management',
    'Embedded System',
    'Propagation and Antenna',
    // 'Object Oriented Software Engineering'
  ];

  List<String> faculties = [
    'BCT',
    'BEI',
    'BCE',
    'BArch',
    'BME',
  ];

  List<String> semesters = [
    'I/I',
    'I/II',
    'II/I',
    'II/II',
    'III/I',
    'III/II',
    'IV/I',
    'IV/II'
  ];

  Future<void> addSubject() async {
    try {
      // Get current user
      User? currentTeacher = FirebaseAuth.instance.currentUser;

      // Retrieve user data to get the teacher's name
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('teachers')
          .doc(currentTeacher?.uid)
          .get();

      // Extract the teacher's name from user data
      String teacherName = userSnapshot['name'];

      // Add the subject document with all the fields
      await FirebaseFirestore.instance.collection('subjects').add({
        'subject': selectedSubject,
        'faculty': selectedFaculty,
        'semester': selectedSemester,
        'teacherName': teacherName, // Add teacher's name to the document
      });
      print('Class added successfully.');
    } catch (e) {
      print('Failed to add class: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return TeacherBasePage(
        title: 'Add Subject',
        currentPageIndex: 1,
        buildBody: (context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedSubject,
                  onChanged: (newValue) {
                    setState(() {
                      selectedSubject = newValue;
                    });
                  },
                  items: subjects.map((subject) {
                    return DropdownMenuItem<String>(
                      value: subject,
                      child: Text(subject),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Subject',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedFaculty,
                  onChanged: (newValue) {
                    setState(() {
                      selectedFaculty = newValue;
                    });
                  },
                  items: faculties.map((faculty) {
                    return DropdownMenuItem<String>(
                      value: faculty,
                      child: Text(faculty),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Faculty',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedSemester,
                  onChanged: (newValue) {
                    setState(() {
                      selectedSemester = newValue;
                    });
                  },
                  items: semesters.map((semester) {
                    return DropdownMenuItem<String>(
                      value: semester,
                      child: Text(semester),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Semester',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondDark,
                    foregroundColor: darkest,
                    padding: const EdgeInsets.only(
                      left: 50,
                      right: 50,
                      top: 15,
                      bottom: 15,
                    ),
                  ),
                  onPressed: () {
                    addSubject();
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: lightest),
                  ),
                ),
              ],
            ),
          );
        }); //Base Page
  }
}
