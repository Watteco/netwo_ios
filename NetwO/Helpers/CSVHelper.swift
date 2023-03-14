//
//  CSVHelper.swift
//  NetwO
//
//  Created by Alain Grange on 12/05/2021.
//

import UIKit

let CSVSeparator            = ","
let CSVNewLine              = "\n"

class CSVHelper: NSObject {

    static func generateCSV(reportDatas: [[String: Any?]]) -> Data? {
        
        // titles
        var csvString = "Date"
        csvString += CSVSeparator
        csvString += "Latitude"
        csvString += CSVSeparator
        csvString += "Longitude"
        csvString += CSVSeparator
        csvString += "Gateway"
        csvString += CSVSeparator
        csvString += "Margin"
        csvString += CSVSeparator
        csvString += "SFTX"
        csvString += CSVSeparator
        csvString += "SNR"
        csvString += CSVSeparator
        csvString += "RSSI"
        csvString += CSVSeparator
        csvString += "Windows"
        csvString += CSVSeparator
        csvString += "SFRX"
        csvString += CSVSeparator
        csvString += "Delay"
        csvString += CSVSeparator
        csvString += "OperatorIndex"
        csvString += CSVSeparator
        csvString += "OperatorName"
        csvString += CSVSeparator
        csvString += "Comment"
        csvString += CSVNewLine
        
        // datas
        for reportData in reportDatas {
                                
            csvString += "\(reportData["Date"] as? String ?? "")"
            csvString += CSVSeparator
            csvString += "\(reportData["Latitude"] as? String ?? "/")"
            csvString += CSVSeparator
            csvString += "\(reportData["Longitude"] as? String ?? "/")"
            csvString += CSVSeparator
            csvString += "\(reportData["Gateway"] as? Int ?? 0)"
            csvString += CSVSeparator
            csvString += "\(reportData["Margin"] as? Int ?? 0)"
            csvString += CSVSeparator
            csvString += "\(reportData["SFTX"] as? Int ?? 0)"
            csvString += CSVSeparator
            csvString += "\(reportData["SNR"] as? Int ?? 0)"
            csvString += CSVSeparator
            csvString += "\(reportData["RSSI"] as? Int ?? 0)"
            csvString += CSVSeparator
            csvString += "\(reportData["Windows"] as? Int ?? 0)"
            csvString += CSVSeparator
            csvString += "\(reportData["SFRX"] as? Int ?? 0)"
            csvString += CSVSeparator
            csvString += "\(reportData["Delay"] as? Int ?? 0)"
            csvString += CSVSeparator
            csvString += "\(reportData["OperatorIndex"] as? Int ?? 0)"
            csvString += CSVSeparator
            csvString += "\(reportData["OperatorName"] as? String ?? "")"
            csvString += CSVSeparator
            csvString += "\(reportData["Comment"] as? String ?? "")"
            csvString += CSVNewLine
                                            
        }
        
        return csvString.data(using: .utf8) ?? nil
        
    }
    
}
