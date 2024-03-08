import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'package:ble_advertiser/phone_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';
import 'package:hex/hex.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BLE Peripheral',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PhoneAuth(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isAdvertising = false;
  Timer? advertiseTime;

  String uniqueUUID = Uuid().v4();

  final rollNumberController = TextEditingController();

  @override
  void dispose() {
    advertiseTime?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('BLE Peripheral'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Container(
              child: TextButton(
                onPressed: () {
                  if (isAdvertising) {
                    stopAdvertising();
                  } else {
                    startAdvertising();
                    print(rollNumberController.text);
                  }
                },
                child: Text(
                    isAdvertising ? 'Stop Advertising' : 'Start Advertising'),
              ),
            ),
          ],
        ));
  }

  Future<void> startAdvertising() async {
    String serviceUUID = 'bf27730d-860a-4e09-889c-2d8b6a9e0fe7';

    // Digest hashedUUID = sha256.convert(utf8.encode(uniqueUUID));
    // Uint8List hashedUUIDBytes = Uint8List.fromList(hashedUUID.bytes);
    // String hashedUUIDHex = HEX.encode(hashedUUIDBytes);

    // String shortUUID = uniqueUUID.substring(0, 8);

    // String rollNumber = "077BEI008";//d204303737424549303134
    //
    //d204303737424549303134

    String rollNumber = rollNumberController.text;
    String serviceDataUUID = generateUUIDRollNumber(rollNumber);

    List<int> manufactData = utf8.encode(rollNumber);

    //ffff303737626569303134 077bei014

    //ffff303737626569303038 077bei008

    //ffff303737626569303133 077bei013

    //ffff303737626569303438 077bei048

    //ffff303737626172303136 077bar016

    //ffff303737626172303031 077bar001

    AdvertiseData advertiseData = AdvertiseData(
      serviceUuid: serviceUUID,
      manufacturerId: 0xFFFF,
      manufacturerData: Uint8List.fromList(manufactData),
    );

    AdvertiseSetParameters advertiseSetParameters = AdvertiseSetParameters();
    advertiseTime = Timer.periodic(Duration(seconds: 5), (timer) {
      try {
        FlutterBlePeripheral().start(
            advertiseData: advertiseData,
            advertiseSetParameters: advertiseSetParameters);
        setState(() {
          isAdvertising = true;
          print(serviceDataUUID);
        });
      } catch (e) {
        print('Error starting advertising: $e');
      }
    });
  }

  Future<void> stopAdvertising() async {
    try {
      await FlutterBlePeripheral().stop();
      setState(() {
        isAdvertising = false;
        advertiseTime?.cancel();
      });
    } catch (e) {
      print('Error stopping advertising: $e');
    }
  }

  String generateUUIDRollNumber(String rollNumber) {
    String uniqueUUID = Uuid().v5(Uuid.NAMESPACE_URL, rollNumber);
    String serviceDataUUID = '0000$uniqueUUID-0000-1000-8000-00805f9b34fb';
    String serviceRollNumber = serviceDataUUID.replaceAll('-', '');
    return serviceRollNumber;
  }
}
