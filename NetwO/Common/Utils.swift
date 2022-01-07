//
//  Utils.swift
//  NetwO
//
//  Created by Alain Grange on 09/05/2021.
//

import UIKit
import MBProgressHUD

class Utils: NSObject {
    
    static var isAlertShowing = false
    
    static func showAlert(view: UIView, message: String) {
        
        if !isAlertShowing {
        
            isAlertShowing = true
            
            let alert = MBProgressHUD.showAdded(to: view, animated: true)
            alert.mode = .text
            alert.label.text = message
            alert.margin = 10.0
            alert.offset = CGPoint(x: 0.0, y: 150.0)
            alert.removeFromSuperViewOnHide = true
            
            alert.hide(animated: true, afterDelay: 3)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                isAlertShowing = false
            }
            
        } else {

            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                showAlert(view: view, message: message)
            }
            
        }
                
    }

}

