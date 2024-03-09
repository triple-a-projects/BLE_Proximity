import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ble_advertiser/perspectives/teacher/home.dart';
import 'package:ble_advertiser/colors.dart';
import 'package:ble_advertiser/perspectives/teacher/check_attendance.dart';

class AddClass extends StatefulWidget {
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
    'Object Oriented Software Engineering'
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
      await FirebaseFirestore.instance.collection('subjects').add({
        'subject': selectedSubject,
        'faculty': selectedFaculty,
        'semester': selectedSemester,
      });
      print('Class added successfully.');
    } catch (e) {
      print('Failed to add class: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Class'),
        backgroundColor: darkest,
        foregroundColor: middle,
      ),
      backgroundColor: middle,
      body: Padding(
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
                backgroundColor: secondLight,
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
      ),
      bottomNavigationBar: BottomAppBar(
        color: darkest,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, size: 40, color: middle),
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
              icon: const Icon(Icons.add_circle_outline_outlined,
                  size: 50, color: middle),
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
              icon: const Icon(Icons.assignment, size: 40, color: middle),
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
    );
  }
}
