import 'package:flutter/material.dart';
import 'package:ble_advertiser/perspectives/teacher/addclass.dart';
import 'package:ble_advertiser/colors.dart';
import 'package:ble_advertiser/perspectives/teacher/check_attendance.dart';

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({super.key});

  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: darkest,
        foregroundColor: middle,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      backgroundColor: middle,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              
              children: [
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.all(5),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: lightest),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft, 
                        child: Text(
                          'Subject Name',
                          style: TextStyle(fontSize: 25, color: darkest ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,  
                        child: ElevatedButton(
                          onPressed: () {},
                          style:ElevatedButton.styleFrom(
                            backgroundColor: secondLight,
                            textStyle: const TextStyle(fontSize: 20),
                          
                          ),
                          child: const Text('Start Class', style: TextStyle(color: darkest),),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            
            ),
          ),
        ],
        
      ),
      

      bottomNavigationBar: BottomAppBar(
        color: darkest,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, size:40, color: middle),
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
                  MaterialPageRoute(
                      builder: (context) =>  TeacherAttendancePage()),
                );
              },
              tooltip: 'Check Attendance',
              color: darkest,
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
}
