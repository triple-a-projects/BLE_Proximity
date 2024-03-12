import 'package:ble_advertiser/colors.dart';
import 'package:ble_advertiser/perspectives/teacher/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ble_advertiser/info.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ble_advertiser/animation.dart';

String currentTeacher = '';

class TeacherEmailAuth extends StatefulWidget {
  const TeacherEmailAuth({super.key});

  @override
  State<TeacherEmailAuth> createState() => _TeacherEmailAuthState();
}

class _TeacherEmailAuthState extends State<TeacherEmailAuth> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      createUserDocument(userCredential.user!);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const TeacherHomePage()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  // To create a user document in Firestore
  Future<void> createUserDocument(User teacher) async {
    try {
      // Reference to the 'users' collection in Firestore
      CollectionReference teachers =
          FirebaseFirestore.instance.collection('teachers');

      // Create a new document with the user's UID
      await teachers.doc(teacher.uid).set(
        {
          'email': emailController.text,
          'name': nameController.text,
        },
      );

      print('User document created in Firestore successfully.');
    } catch (e) {
      print('Failed to create user document in Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoTextTheme(),
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: darkest,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
                icon: const Icon(
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
          title: const Text(
            'Email Authentication',
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 120),
              Padding(
                padding: const EdgeInsets.all(
                  20,
                ),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: nameController,
                  onChanged: (value) {
                    currentTeacher =
                        value; // Update the global value when text changes
                  },
                  decoration: InputDecoration(
                    hintText: 'Name',
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  signInWithEmailAndPassword();
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(
                      left: 40,
                      right: 40,
                      top: 15,
                      bottom: 15,
                    ),
                    backgroundColor: secondDark,
                    foregroundColor: Colors.white),
                child: const Text('Sign In'),
              ),
              SizedBox(height: 120),
            ],
          ),
          // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        ),
      ),
    );
  }
}
