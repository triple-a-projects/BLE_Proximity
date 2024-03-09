import 'package:ble_advertiser/perspectives/teacher/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherEmailAuth extends StatefulWidget {
  const TeacherEmailAuth({Key? key}) : super(key: key);

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
        MaterialPageRoute(builder: (context) => TeacherHomePage()),
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

  // Function to create a user document in Firestore
  Future<void> createUserDocument(User teacher) async {
    try {
      // Reference to the 'users' collection in Firestore
      CollectionReference teachers =
          FirebaseFirestore.instance.collection('teachers');

      // Create a new document with the user's UID
      await teachers.doc(teacher.uid).set({
        'email': emailController.text,
        'name': nameController.text,
      });

      print('User document created in Firestore successfully.');
    } catch (e) {
      print('Failed to create user document in Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Email Authentication',
          ),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Name',
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                signInWithEmailAndPassword();
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: const Text('Sign In'),
            )
          ],
        ),
      ),
    );
  }
}
