import 'package:ble_advertiser/perspectives/teacher/teacher_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ble_advertiser/perspectives/teacher/home.dart';
import 'package:ble_advertiser/colors.dart';

import 'package:ble_advertiser/perspectives/teacher/check_attendance.dart';
import 'package:ble_advertiser/info.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AddClass extends StatefulWidget {
  const AddClass({super.key});

  @override
  _AddClassState createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  String? selectedSubject;
  String? selectedFaculty;
  String? selectedSemester;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController customSubjectController = TextEditingController();

  List<String> subjects = [
    'Communication English',
    'Communication System',
    'Project Management',
    'Embedded System',
    'Propagation and Antenna',
    'Object Oriented Software Engineering',
  ];

  List<String> faculties = [
    'BEI',
    'BCT',
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

      // String subjectToAdd = selectedSubject ?? customSubjectController.text;

      // Add the subject document with all the fields
      await FirebaseFirestore.instance.collection('subjects').add({
        'subject': customSubjectController.text,
        'faculty': selectedFaculty,
        'semester': selectedSemester,
        'teacherName': teacherName, // Add teacher's name to the document
      });
      // Show "Added successfully" message using SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check, color: Colors.white),
              SizedBox(width: 8),
              Text('Subject Added successfully'),
            ],
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Clear input fields after successful addition
      setState(() {
        customSubjectController.clear();
        selectedSubject = null;
        selectedFaculty = faculties.first;
        selectedSemester = semesters.length >= 6 ? semesters[5] : null;
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
        key: _scaffoldKey,
        currentPageIndex: 1,
        buildBody: (context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                TypeAheadField<String>(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: customSubjectController,
                    decoration: InputDecoration(
                      labelText: 'Subject',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  suggestionsCallback: (pattern) {
                    return subjects.where((subject) => subject
                        .toLowerCase()
                        .startsWith(pattern.toLowerCase()));
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    customSubjectController.text = suggestion;
                    setState(() {
                      selectedSubject = suggestion;
                    });
                  },
                  noItemsFoundBuilder: (context) {
                    return Text('New Subject will be Added');
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedFaculty,
                  // ?? faculties.first,
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
                  // ??
                  //     (semesters.length >= 6 ? semesters[5] : null),
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
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }); //Base Page
  }
}
