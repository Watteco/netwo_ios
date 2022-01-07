//
//  DeviceTableViewCell.swift
//  NetwO
//
//  Created by Alain Grange on 08/05/2021.
//

import UIKit
import CoreBluetooth

class DeviceTableViewCell: UITableViewCell {
 
    let nameLabel = UILabel()
    let macAddressLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        self.accessoryType = .none
        self.selectionStyle = .none
        
        // name label
        nameLabel.frame = CGRect(x: 20.0, y: 0.0, width: self.contentView.frame.size.width - 40.0, height: self.contentView.frame.size.height)
        nameLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.systemFont(ofSize: 16.0)
        nameLabel.textColor = ColorTextGreyMedium
        self.contentView.addSubview(nameLabel)
        
        // mac address label
//        macAddressLabel.frame = CGRect(x: 30.0, y: 35.0, width: self.contentView.frame.size.width - 60.0, height: 15.0)
//        macAddressLabel.autoresizingMask = .flexibleWidth
//        macAddressLabel.textAlignment = .left
//        macAddressLabel.font = UIFont.systemFont(ofSize: 14.0)
//        macAddressLabel.textColor = ColorTextGreyLight
//        self.contentView.addSubview(macAddressLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadWithPeripheral(peripheral: CBPeripheral) {
                
        // name
        nameLabel.text = peripheral.name
        
        // mac address
//        macAddressLabel.text = "XX:XX:XX:XX:XX:XX"
        
    }
    
}
