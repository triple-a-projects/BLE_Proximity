import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build
  (BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BLE Peripheral',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
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
  AdvertiseData advertiseData = AdvertiseData(
    // includeDeviceName: true,
    serviceUuid: 'bf27730d-860a-4e09-889c-2d8b6a9e0fe7',
    manufacturerId: 1234,
    manufacturerData: Uint8List.fromList([1, 2, 3, 4, 5, 6]),
    // includeDeviceName: true,
  );
  AdvertiseSetParameters advertiseSetParameters = AdvertiseSetParameters();

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
      body: Center(
        child: TextButton(
          onPressed: () {
                if (isAdvertising) {
                  stopAdvertising();
                } else {
                  startAdvertising();
                }
              },
          child: Text(
            isAdvertising ? 'Stop Advertising' : 'Start Advertising'
          ),  
        ),
      ),
    );
  }

  Future<void> startAdvertising() async {
    advertiseTime = Timer.periodic(Duration(seconds: 2), (timer) {
      try {
      FlutterBlePeripheral().start(
        advertiseData: advertiseData, 
        advertiseSetParameters: advertiseSetParameters
      );
      setState(() {
        isAdvertising = true;
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
}