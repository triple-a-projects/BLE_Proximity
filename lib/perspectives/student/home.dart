import 'package:ble_advertiser/perspectives/student/settings.dart';
import 'package:ble_advertiser/perspectives/student/student_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ble_advertiser/colors.dart';
import 'package:ble_advertiser/main.dart';
// import 'package:student/check_attendance.dart';
import 'package:ble_advertiser/info.dart';
import 'package:ble_advertiser/animation.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({Key? key}) : super(key: key);

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return StudentBasePage(
      title: 'Dashboard',
      currentPageIndex: _currentPageIndex,
      buildBody: (context) => FutureBuilder(
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
                String teacherName = subjects[index]['teacherName'];
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
                          Flexible(
                            child: Text(
                              '$subjectName',
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              '$teacherName',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                PageTransitionAnimation(
                                  page: MyHomePage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: middle,
                              textStyle: const TextStyle(fontSize: 15),
                            ),
                            child: const Text(
                              'Attend',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
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
