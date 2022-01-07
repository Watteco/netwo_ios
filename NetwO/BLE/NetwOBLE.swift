//
//  NetwOBLE.swift
//  NetwO
//
//  Created by Alain Grange on 07/05/2021.
//

import UIKit
import CoreBluetooth

// services
let BLEDeviceInformationService: CBUUID = CBUUID(string: "49535343-FE7D-4AE5-8FA9-9FAFD205E455")

// characteristics
let BLEMainCharacteristic: CBUUID = CBUUID(string: "49535343-1E4D-4BD9-BA61-23C647249616")

class NetwOBLE: NSObject, BluetoothLibraryDelegate {
 
    static let shared = NetwOBLE()
    
    var mainCharacteristic: CBCharacteristic? = nil
    
    required override init() {
        super.init()
        BluetoothLibrary.shared.delegate = self
    }
        
    func isBluetoothEnabled() -> Bool {
        return BluetoothLibrary.shared.bluetoothEnabled
    }

    func isConnected() -> Bool {
        return BluetoothLibrary.shared.isConnected && BluetoothLibrary.shared.bondChecked == true
    }
    
    func scan() {
        
        let servicesAdvertiseUUID = [CBUUID]()
//        servicesAdvertiseUUID.append(OrionBLEGeneralService)
//
        var servicesUUID = [CBUUID]()
        servicesUUID.append(BLEDeviceInformationService)
//        servicesUUID.append(OrionBLEJumpService)
//
        var characteristicsUUID = [CBUUID]()
        characteristicsUUID.append(BLEMainCharacteristic)
//        characteristicsUUID.append(BLECharacteristic2)
//        characteristicsUUID.append(BLECharacteristic3)
//        characteristicsUUID.append(OrionBLEJumpReadyCharacteristic)
//        characteristicsUUID.append(OrionBLEJumpTimeCharacteristic)
        
        // start scan
//        BluetoothLibrary.shared.scanWithServicesAdvertise(servicesAdvertiseUUID: servicesAdvertiseUUID, servicesUUID: servicesUUID, characteristicsUUID: characteristicsUUID, deviceName: "Gaspard_", currentPeripheralName: UserDefaults.standard.string(forKey: OrionBLECurrentPeripheralName) ?? "", autoconnect: true, forgetPeripheral: false)
        
        
        BluetoothLibrary.shared.scanWithServicesAdvertise(servicesAdvertiseUUID: servicesAdvertiseUUID, servicesUUID: servicesUUID, characteristicsUUID: characteristicsUUID, deviceName: "", currentPeripheralName: "", autoconnect: true, forgetPeripheral: false)
        
    }
    
    func connectPeripheral(peripheral: CBPeripheral) {
        BluetoothLibrary.shared.connectPeripheral(peripheral: peripheral)
    }
    
    func checkConnection(peripheral: CBPeripheral) {
        
        if !BluetoothLibrary.shared.characteristicsChecked &&
            mainCharacteristic != nil {

            BluetoothLibrary.shared.characteristicsChecked = true
            BluetoothLibrary.shared.isConnecting = false

            // check if device is bonded
            checkBond(peripheral: peripheral)

        }
        
    }
    
    func checkBond(peripheral: CBPeripheral) {
        
//        if BluetoothLibrary.shared.bondChecked {
//
//            print("TODO: device is bonded")
//
//            // save peripheral name for autoconnect
//            UserDefaults.standard.set(peripheral.name, forKey: OrionBLECurrentPeripheralName)
//            UserDefaults.standard.synchronize()
//
//            // update gaspard time
//            saveTime()
//
//            NotificationCenter.default.post(name: .BLEDeviceConnected, object: nil)
//            NotificationCenter.default.post(name: .BLEScanFinished, object: nil)
//
//        } else {
//            print("TODO: device is not bonded : start bonding")
//            peripheral.readValue(for: orionBLEGeneralSeatInUseCharacteristic!)
//        }
        
    }
    
    func disconnect() {
        BluetoothLibrary.shared.disconnectPeripheral()
    }
    
    func startTest(value: String) {
                
        if let mainCharacteristic = mainCharacteristic,
           let data = value.data(using: .utf8) {
            print("TODO: startTest")
            BluetoothLibrary.shared.writeValue(characteristic: mainCharacteristic, value: data)
            
        }
                
    }
    
    // MARK: - BluetoothLibrary Delegate
    
    func scanResults(_ scanPeripherals: [CBPeripheral: NSNumber]) {
        NotificationCenter.default.post(name: .BLEScanFinished, object: nil)
        NotificationCenter.default.post(name: .BLEScanResults, object: scanPeripherals)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristic characteristic: CBCharacteristic, service: CBService, error: Error?) {
        
        print("TODO: discovered characteristic : \(characteristic.uuid.uuidString)")
        
        if characteristic.uuid.uuidString == BLEMainCharacteristic.uuidString {
            self.mainCharacteristic = characteristic
        }

        // activate notify
        if characteristic.uuid.uuidString == BLEMainCharacteristic.uuidString {
            print("TODO: discovered characteristic activate notify : \(characteristic.uuid.uuidString)")
            peripheral.setNotifyValue(true, for: characteristic)
            BluetoothLibrary.shared.bondChecked = true
        }

        checkConnection(peripheral: peripheral)
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        print("TODO: didUpdateValueFor characteristic : \(characteristic.uuid.uuidString)")
        
        if characteristic.uuid.uuidString == BLEMainCharacteristic.uuidString {

            if error == nil {

                if let value: Data = characteristic.value,
                   let dataString = String(data: value, encoding: String.Encoding.utf8) {
                    
                    NotificationCenter.default.post(name: .BLECollectDatas, object: dataString)
                    
                }
                
            } else {

                // TODO: error jump ready

            }

        }
        
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager, bluetoothEnabled: Bool) {
        NotificationCenter.default.post(name: .BLEBluetoothState, object: bluetoothEnabled)
    }
    
    func didConnectPeripheral() {
        NotificationCenter.default.post(name: .BLEDeviceConnected, object: BluetoothLibrary.shared.peripheral)
    }
    
    func didFailedToConnectPeripheral() {
        NotificationCenter.default.post(name: .BLEDeviceFailedToConnect, object: nil)
    }
    
    func didDisconnectPeripheral() {
        NotificationCenter.default.post(name: .BLEDeviceDisconnected, object: nil)
    }
    
}
