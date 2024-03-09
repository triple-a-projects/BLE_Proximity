import 'package:ble_advertiser/colors.dart';
import 'package:ble_advertiser/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:ble_advertiser/perspectives/student/login.dart';
import 'package:ble_advertiser/perspectives/student/home.dart';
import 'package:ble_advertiser/info.dart';

class StudentLoginPage extends StatefulWidget {
  const StudentLoginPage({super.key});

  @override
  State<StudentLoginPage> createState() => _StudentLoginPageState();
}

class _StudentLoginPageState extends State<StudentLoginPage> {
  late final LocalAuthentication auth;
  bool _supportState = false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() {
            _supportState = isSupported;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InfoPage()),
                );
              })
        ],
        title: const Text('Login Page for Student'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // if (_supportState)
          //   const Text('This device is supported')
          // else
          //   const Text('This device is not supported'),
          // const Divider(
          //   height: 100,
          // ),
          // ElevatedButton(
          //     onPressed: _getAvailableBiometrics,
          //     child: const Text("Get available biometrics")),
          const Divider(
            height: 100,
          ),
          ElevatedButton(
            onPressed: _authenticate,
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.only(
                  left: 40,
                  right: 40,
                  top: 15,
                  bottom: 15,
                ),
                backgroundColor: secondDark,
                foregroundColor: Colors.white),
            child: Text('Authenticate'),
          ),
        ],
      ),
    );
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
          localizedReason:
              'You must authenticate yourself to continue to the app.',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ));

      print('Authenticated: $authenticated');
      if (authenticated) {
        // Navigate to the main page
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => StudentHomePage()),
          (route) => false,
        );
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    print("List of available biometrics: $availableBiometrics");

    if (!mounted) {
      return;
    }
  }
}
