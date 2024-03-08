import 'package:flutter/material.dart';
import 'package:ble_advertiser/colors.dart';
import 'package:ble_advertiser/main.dart';
import 'package:ble_advertiser/perspectives/student/home.dart';

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
        foregroundColor: middle,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30),
          onPressed: () {},
        ),
      ),
      backgroundColor: middle,
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 3,
              child: ListTile(
                tileColor: secondLight,
                title: Text(
                  'Communication System',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkest,
                  ),
                ),
                subtitle: const Text('Attendance: 80%'),
              ),
            ),
          );
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
