// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAjv1Kzc1bQxfXfmzMB9KnFyq0IBGPlWEc',
    appId: '1:100428051356:web:a1599d41228dcd49084e59',
    messagingSenderId: '100428051356',
    projectId: 'bluetooth-attendance-sys-e6be1',
    authDomain: 'bluetooth-attendance-sys-e6be1.firebaseapp.com',
    storageBucket: 'bluetooth-attendance-sys-e6be1.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC0f30uuXT1NhINtHiVLxbGoi3Q4gWa1ts',
    appId: '1:100428051356:android:eab630dd76a8ecd6084e59',
    messagingSenderId: '100428051356',
    projectId: 'bluetooth-attendance-sys-e6be1',
    storageBucket: 'bluetooth-attendance-sys-e6be1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB8V9TJIXeEo6XK-eZ8jZ1gNfzdSjTNZhQ',
    appId: '1:100428051356:ios:0d450ff7b024c8a8084e59',
    messagingSenderId: '100428051356',
    projectId: 'bluetooth-attendance-sys-e6be1',
    storageBucket: 'bluetooth-attendance-sys-e6be1.appspot.com',
    iosBundleId: 'com.example.bleAdvertiser',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB8V9TJIXeEo6XK-eZ8jZ1gNfzdSjTNZhQ',
    appId: '1:100428051356:ios:6c3cc65c5260d38f084e59',
    messagingSenderId: '100428051356',
    projectId: 'bluetooth-attendance-sys-e6be1',
    storageBucket: 'bluetooth-attendance-sys-e6be1.appspot.com',
    iosBundleId: 'com.example.bleAdvertiser.RunnerTests',
  );
}