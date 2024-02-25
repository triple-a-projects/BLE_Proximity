#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEScan.h>
#include <BLEAdvertisedDevice.h>
#include <vector>

std::vector<const char*> manufacturer_data;

BLEScan* pBLEScan;

bool isThere= false;

const char* serviceUUID = "bf27730d-860a-4e09-889c-2d8b6a9e0fe7";
BLEUUID serviceUUIDObject(serviceUUID);

class MyAdvertisedDeviceCallbacks: public BLEAdvertisedDeviceCallbacks {
  void onResult(BLEAdvertisedDevice advertisedDevice) {
    // if(advertisedDevice.haveServiceUUID()){
    //   if(strcmp(advertisedDevice.getServiceUUID().toString().c_str(), serviceUUIDObject.toString().c_str()) == 0){
    //     if(advertisedDevice.haveManufacturerData()){
    //         Serial.print("BLE Advertised Device found: \n");
    //         Serial.println(advertisedDevice.toString().c_str());
    //     }
    //   }
            Serial.print("BLE Advertised Device found: \n");
            Serial.println(advertisedDevice.toString().c_str());    
    // }
    
    delay(2000);
  }
};

void setup() {
  Serial.begin(115200);
  Serial.println("Scanning for BLE devices...");

  BLEDevice::init("ESP32");
  pBLEScan = BLEDevice::getScan(); //create new scan
  pBLEScan->setAdvertisedDeviceCallbacks(new MyAdvertisedDeviceCallbacks());
  pBLEScan->setActiveScan(true);
}

void loop() {
  
  pBLEScan->start(100);
  Serial.println("...........................................................................................................................");
  pBLEScan->clearResults();
  delay(10000);
}

