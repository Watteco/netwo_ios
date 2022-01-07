//
//  NetwOBLEExtensions.swift
//  NetwO
//
//  Created by Alain Grange on 07/05/2021.
//

import UIKit

extension Notification.Name {
    static let BLEBluetoothState        = Notification.Name(rawValue: "BLEBluetoothState")
    static let BLEDeviceConnected       = Notification.Name(rawValue: "BLEDeviceConnected")
    static let BLEDeviceFailedToConnect = Notification.Name(rawValue: "BLEDeviceFailedToConnect")
    static let BLEDeviceDisconnected    = Notification.Name(rawValue: "BLEDeviceDisconnected")
    static let BLEScanFinished          = Notification.Name(rawValue: "BLEScanFinished")
    static let BLEScanResults           = Notification.Name(rawValue: "BLEScanResults")
    static let BLECollectDatas          = Notification.Name(rawValue: "BLECollectDatas")
}
