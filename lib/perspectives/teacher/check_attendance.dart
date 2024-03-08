import 'package:flutter/material.dart';
import 'package:ble_advertiser/perspectives/teacher/home.dart';
import 'package:ble_advertiser/colors.dart';
import 'package:ble_advertiser/perspectives/teacher/addclass.dart';

class TeacherAttendancePage extends StatelessWidget {
  TeacherAttendancePage({Key? key}) : super(key: key);

  final List<String> subjectNames = [
    'Communication System',
    'Propagation and Antenna',
    'Object Oriented Software Engineering'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Attendance'),
        backgroundColor: darkest,
        foregroundColor: middle,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: middle,
      body: ListView.builder(
        itemCount: subjectNames.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 3,
              child: ListTile(
                title: Text(
                  subjectNames[index],
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: lightest),
                ),
                trailing : GestureDetector(
                  onTap: () {},
                  child: const Icon(Icons.edit, color: lightest,)
                ) ,
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: darkest,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, size: 40, color: middle,),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TeacherHomePage()),
                );
              },
              tooltip: 'Home',
              color: darkest,
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline_outlined, size: 50,color: middle,),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>  AddClass()),
                );
              },
              tooltip: 'Add Class',
              color: darkest,
            ),
            IconButton(
              icon: const Icon(Icons.assignment, size: 40, color: middle,),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TeacherAttendancePage()),
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
