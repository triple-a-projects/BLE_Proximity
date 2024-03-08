import 'package:ble_advertiser/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
          title: const Text('Bluetooth Attendance System'),
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
                onPressed: _authenticate, child: Text('Authenticate')),
          ],
        ));
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
          MaterialPageRoute(builder: (context) => MyHomePage()),
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
