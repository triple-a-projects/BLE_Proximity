import 'package:flutter/material.dart';
import 'package:ble_advertiser/colors.dart';
import 'package:ble_advertiser/main.dart';
// import 'package:student/check_attendance.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({Key? key}) : super(key: key);

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Dashboard'),
          backgroundColor: darkest,
          foregroundColor: middle,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(
                Icons.menu,
                size: 30,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          )),
      backgroundColor: middle,
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
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
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Subject Name $index',
                      style: const TextStyle(fontSize: 20, color: darkest),
                    ),
                  ],
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Name of Teacher ',
                      style: TextStyle(fontSize: 15, color: darkest),
                    ),
                  ],
                ),
                trailing: SizedBox(
                  width: 100,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => MyHomePage()),
                          (route) => false,
                        );
                        
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondLight,
                        textStyle: const TextStyle(fontSize: 15),
                      ),
                      child: const Text(
                        'Attend Class',
                        style: TextStyle(color: darkest),
                      ),
                    ),
                  ),
                ),
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
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: middle,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: darkest,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('About Us'),
              onTap: () {
                Navigator.pop(context);
              },
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
