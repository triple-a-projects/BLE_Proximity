import 'package:ble_advertiser/perspectives/teacher/addclass.dart';
import 'package:ble_advertiser/perspectives/teacher/check_attendance.dart';
import 'package:ble_advertiser/perspectives/teacher/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ble_advertiser/colors.dart';
import 'package:ble_advertiser/info.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:ble_advertiser/perspectives/teacher/settings.dart';
import 'package:ble_advertiser/animation.dart';

class TeacherBasePage extends StatelessWidget {
  final String title;
  final Widget Function(BuildContext) buildBody;
  final int currentPageIndex;

  const TeacherBasePage({
    Key? key,
    required this.title,
    required this.buildBody,
    required this.currentPageIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: darkest,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              icon: Icon(
                Icons.info_outlined,
                color: lightest,
                size: 30,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  PageTransitionAnimation(
                    page: InfoPage(),
                  ),
                );
              })
        ],
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
        ),
      ),
      body: buildBody(context),
      bottomNavigationBar: Container(
        color: darkest,
        height: 60,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            child: GNav(
              // tabMargin: EdgeInsets.all(1),
              iconSize: 30,
              textSize: 20,
              backgroundColor: darkest,
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: middle,
              gap: 10,
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                  onPressed: () {
                    Navigator.of(context).push(
                      PageTransitionAnimation(
                        page: TeacherHomePage(),
                      ),
                    );
                  },
                  padding: EdgeInsets.all(10),
                ),
                GButton(
                  icon: Icons.add_circle_outline_outlined,
                  text: 'Add Class',
                  onPressed: () {
                    Navigator.of(context).push(
                      PageTransitionAnimation(
                        page: AddClass(),
                      ),
                    );
                  },
                  padding: EdgeInsets.all(10),
                ),
                GButton(
                  icon: Icons.assignment,
                  text: 'Attendance',
                  onPressed: () {
                    Navigator.of(context).push(
                      PageTransitionAnimation(
                        page: TeacherAttendancePage(),
                      ),
                    );
                  },
                  padding: EdgeInsets.all(10),
                ),
              ],
              selectedIndex: currentPageIndex,
            )),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              height: 100,
              child: const DrawerHeader(
                decoration: BoxDecoration(
                  color: darkest,
                ),
                padding: EdgeInsets.all(20),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                Navigator.of(context).push(
                  PageTransitionAnimation(
                    page: TeacherSettingsPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('About Us'),
              onTap: () {
                Navigator.of(context).push(
                  PageTransitionAnimation(
                    page: InfoPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
