import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: FutureBuilder(
          future: FirebaseFirestore.instance.collection('users').get(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(
                  color: Colors
                      .white); // Show a loading indicator while fetching data
            }
            if (snapshot.hasError) {
              return Text(
                  'Error: ${snapshot.error}'); // Show an error message if fetching fails
            }
            final users = snapshot.data!.docs;
            return DataTable(
              columns: <DataColumn>[
                DataColumn(
                  label: Text(
                    'Roll No',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Name',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Phone Number',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    DateFormat('yyyy-MM-dd').format(DateTime.now()),
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
              rows: List<DataRow>.generate(
                users.length,
                (index) => DataRow(
                  cells: <DataCell>[
                    DataCell(Text(users[index]['rollNo'])),
                    DataCell(Text(users[index]['name'])),
                    DataCell(Text(users[index]['phoneNo'])),
                    DataCell(Text(
                        users[index]['phoneNo'])), // Placeholder for attendance
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AttendanceTable(),
  ));
}
