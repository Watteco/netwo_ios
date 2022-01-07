//
//  Formatters.swift
//  NetwO
//
//  Created by Alain Grange on 12/05/2021.
//

import UIKit

enum FormattersTemplate: String {

    case ddMMyyyyHHmmss = "dd-MM-yyyy HH:mm:ss"
    
    func localized() -> Bool {
        
        //return (self == .ddMMyyyyHHmmss)
        return false
        
    }
    
    func dateFormat() -> String {
    
        if self.localized() {
            return NSLocalizedString(self.rawValue, comment: "")
        } else {
            return self.rawValue
        }
    
    }
    
}

class Formatters: NSObject {

    static var dateFormatter: DateFormatter?
        
    static func dateFromString(from: String, template: FormattersTemplate) -> Date? {
        
        if dateFormatter == nil {
            
            let formatter = DateFormatter()
            dateFormatter = formatter
            
        }
        
        dateFormatter?.dateFormat = template.dateFormat()
        
        return dateFormatter?.date(from: from)
        
    }
    
    static func stringFromDate(from: Date, template: FormattersTemplate) -> String? {
        
        if dateFormatter == nil {
            
            let formatter = DateFormatter()
            dateFormatter = formatter
            
        }
        
        dateFormatter?.dateFormat = template.dateFormat()
        
        return dateFormatter?.string(from: from)
        
    }
    
}
