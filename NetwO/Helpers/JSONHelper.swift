//
//  JSONHelper.swift
//  NetwO
//
//  Created by Alain Grange on 12/05/2021.
//

import UIKit

class JSONHelper: NSObject {

    static func generateJSON(reportDatas: [[String: Any?]]) -> Data? {
        
        var jsonData: Data? = nil
        
        do {
            jsonData = try JSONSerialization.data(withJSONObject: reportDatas, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch {
            jsonData = nil
        }
        
        return jsonData
        
    }
    
}
