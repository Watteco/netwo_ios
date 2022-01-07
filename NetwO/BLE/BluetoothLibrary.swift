//
//  BluetoothLibrary.swift
//  NetwO
//
//  Created by Alain Grange on 07/05/2021.
//

import UIKit
import CoreBluetooth

@objc protocol BluetoothLibraryDelegate {
    @objc optional func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristic characteristic: CBCharacteristic, service: CBService, error: Error?)
    @objc optional func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?)
    @objc optional func scanResults(_ scanPeripherals: [CBPeripheral: NSNumber])
    @objc optional func centralManagerDidUpdateState(_ central: CBCentralManager, bluetoothEnabled: Bool)
    @objc optional func didConnectPeripheral()
    @objc optional func didFailedToConnectPeripheral()
    @objc optional func didDisconnectPeripheral()
}

class BluetoothLibrary: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {

    static let shared = BluetoothLibrary()
    
    var centralManager: CBCentralManager? = nil
    var bluetoothEnabled = false
    var isScanning = false
    var isConnected = false
    var isConnecting = false
    var autoconnect = false
    var characteristicsChecked = false
    var bondChecked = false
    var peripheral: CBPeripheral?
    var scanPeripherals = [CBPeripheral: NSNumber]()
    var deviceName = ""
    var currentPeripheralName = ""
    var servicesAdvertiseUUID = [CBUUID]()
    var servicesUUID = [CBUUID]()
    var characteristicsUUID = [CBUUID]()
    
    var delegate: BluetoothLibraryDelegate?
    
    required override init() {
        
        super.init()
        
//        self.centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionRestoreIdentifierKey: "CentralManagerIdentifier"])
        
        self.centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
        
    }
 
    func scanWithServicesAdvertise(servicesAdvertiseUUID: [CBUUID],
                                   servicesUUID: [CBUUID],
                                   characteristicsUUID: [CBUUID],
                                   deviceName: String,
                                   currentPeripheralName: String,
                                   autoconnect: Bool,
                                   forgetPeripheral: Bool) {
        
        self.isScanning = true
        self.isConnected = false
        self.autoconnect = autoconnect
        
        if forgetPeripheral {
            self.peripheral = nil
        }
        
        scanPeripherals.removeAll()
        self.deviceName = deviceName
        self.currentPeripheralName = currentPeripheralName
        
        self.servicesAdvertiseUUID.removeAll()
        self.servicesAdvertiseUUID.append(contentsOf: servicesAdvertiseUUID)
        
        self.servicesUUID.removeAll()
        self.servicesUUID.append(contentsOf: servicesUUID)
        
        self.characteristicsUUID.removeAll()
        self.characteristicsUUID.append(contentsOf: characteristicsUUID)
        
        if centralManager?.state == CBManagerState.poweredOn {
            
            print("TODO: start scan")
            
            if autoconnect && peripheral != nil {
                centralManager?.connect(peripheral!, options: nil)
            } else {
                
                centralManager?.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.stopScan()
                }
                
            }
            
        }
        
    }
    
    func stopScan() {
        
        print("TODO: stop scan")
        
        if isScanning {
            
            self.isScanning = false
            centralManager?.stopScan()
            
            if autoconnect {
                
                var selectedPeripheral: CBPeripheral? = nil
                
                if currentPeripheralName.count > 0 {
                    
                    for peripheral in scanPeripherals.keys {
                        
                        if peripheral.name == currentPeripheralName {
                            selectedPeripheral = peripheral
                            break
                        }
                        
                    }
                    
                }
                
                if selectedPeripheral != nil {
                    connectPeripheral(peripheral: selectedPeripheral!)
                } else {
                    
                    // notify scan results
                    self.delegate?.scanResults?(scanPeripherals)
                    
                }
                
            } else {
                
                // notify scan results
                self.delegate?.scanResults?(scanPeripherals)
                
            }
            
        }
        
    }
    
    func connectPeripheral(peripheral: CBPeripheral) {
        
        centralManager?.connect(peripheral, options: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            
            if peripheral.state != CBPeripheralState.connected {
                self.disconnectPeripheral(peripheral: peripheral)
            }
            
        }
        
    }
    
    func disconnectPeripheral(peripheral: CBPeripheral) {
        centralManager?.cancelPeripheralConnection(peripheral)
        self.peripheral = nil
    }
    
    func disconnectPeripheral() {
        if peripheral != nil {
            disconnectPeripheral(peripheral: peripheral!)
        }
    }
    
    func isServiceAllowed(service: CBService) -> Bool {
        
        var result = false
        
        for serviceUUID in servicesUUID {
            
            if serviceUUID.uuidString == service.uuid.uuidString {
                result = true
                break
            }
            
        }
        
        return result
        
    }
    
    func isCharacteristicAllowed(characteristic: CBCharacteristic) -> Bool {
        
        var result = false
        
        for characteristicUUID in characteristicsUUID {
            
            if characteristicUUID.uuidString == characteristic.uuid.uuidString {
                result = true
                break
            }
            
        }
        
        return result
        
    }
    
    func writeValue(characteristic: CBCharacteristic, value: Data) {
        peripheral?.writeValue(value, for: characteristic, type: .withResponse)
    }
    
    // MARK: - CBCentralManager Delegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            
            switch (central.state) {
                
                case .poweredOn:

                    self.bluetoothEnabled = true
                    
                    if self.peripheral != nil {
                        self.connectPeripheral(peripheral: self.peripheral!)
                    }
                    
                    break
                    
                case .poweredOff:

                    self.bluetoothEnabled = false
                    break
                
                case .unsupported:
                    self.bluetoothEnabled = false
                    break
                
                case .resetting,
                     .unauthorized,
                     .unknown:
                    self.bluetoothEnabled = false
                    break
                
                default:
                    break
                
            }

            self.delegate?.centralManagerDidUpdateState?(central, bluetoothEnabled: self.bluetoothEnabled)
            
        }
        
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            
            self.centralManager?.stopScan()
            
            self.isConnected = false
            self.isConnecting = true
            self.peripheral = peripheral
            self.characteristicsChecked = false
            self.bondChecked = false
            
print("TODO: connected")
            
            peripheral.delegate = self
            peripheral.discoverServices(self.servicesUUID.count > 0 ? self.servicesUUID : [CBUUID]())
            
            self.delegate?.didConnectPeripheral?()
            
        }
        
    }
    
    func centralManager(_: CBCentralManager, didDisconnectPeripheral: CBPeripheral, error: Error?) {
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            
print("TODO: disconnected")
            
            self.isConnected = false
            self.delegate?.didDisconnectPeripheral?()
            
        }
        
    }
    
    func centralManager(_: CBCentralManager, didFailToConnect: CBPeripheral, error: Error?) {
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            
print("TODO: failed to connect")
            
            self.isConnected = false
            self.delegate?.didFailedToConnectPeripheral?()
            
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            
            if let name = advertisementData[CBAdvertisementDataLocalNameKey],
                let nameString = name as? String,
                nameString.count > 0,
                nameString.hasPrefix("WTC-") {
                
                print("TODO: discover peripheral : \(peripheral.name ?? "")   rssi : \(RSSI.intValue)")
                
                if RSSI.intValue < 0 {
                    
                    if nameString.hasPrefix(self.deviceName) {
                        
                        self.scanPeripherals[peripheral] = RSSI
                        
                        if nameString == self.currentPeripheralName || peripheral.name == self.currentPeripheralName {
                            self.stopScan()
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func centralManager(_: CBCentralManager, didUpdateANCSAuthorizationFor: CBPeripheral) {
        
    }
    
//    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
//
//        if dict["kCBRestoredPeripherals"] is NSMutableArray {
//
//            let peripherals = dict["kCBRestoredPeripherals"] as! NSMutableArray
//            for item in peripherals {
//
//                let peripheral: CBPeripheral = item as! CBPeripheral
//
//                switch peripheral.state {
//                case .connected:
//                    print("Restore peripheral \(peripheral)")
//                    self.peripheral = peripheral
//                    break
//                default:
//                    break
//                }
//
//            }
//
//        }
//
//    }
    
    // MARK: - CBPeripheral Delegate
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            
            self.isConnected = true
            self.peripheral = peripheral
            
            if peripheral.services != nil {
                for service in peripheral.services! {
                
                    print("TODO: discover service : \(service.uuid)")
                    
                    if self.isServiceAllowed(service: service) {
                        peripheral.discoverCharacteristics(self.characteristicsUUID, for: service)
                    }
                    
                }
            }
            
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            
            if (service.characteristics != nil) {
                for characteristic in service.characteristics! {
                
                    print("TODO: discover characteristic : \(characteristic.uuid)")
                    
                    if self.isCharacteristicAllowed(characteristic: characteristic) {
                        
                        // notify delegate for characteristic
                        self.delegate?.peripheral?(peripheral, didDiscoverCharacteristic: characteristic, service: service, error: error)
                        
                    }
                    
                }
            }
            
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.delegate?.peripheral?(peripheral, didUpdateValueFor: characteristic, error: error)
        }
        
    }
        
}
