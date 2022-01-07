//
//  AppDelegate.swift
//  NetwO
//
//  Created by Alain Grange on 07/05/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainNavigationController: MainNavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // init bluetooth
        _ = BluetoothLibrary.shared
        
        // window
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        
        self.mainNavigationController = MainNavigationController()
        window?.rootViewController = mainNavigationController
        window?.makeKeyAndVisible()
        
        return true
        
    }

}

