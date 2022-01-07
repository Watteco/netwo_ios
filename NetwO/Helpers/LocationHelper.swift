//
//  LocationHelper.swift
//  NetwO
//
//  Created by Alain Grange on 17/07/2021.
//

import UIKit
import CoreLocation

class LocationHelper: NSObject, CLLocationManagerDelegate {

    let RequestTimeout: TimeInterval = 10
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?

    func location() -> CLLocation? {
        
        if locationManager == nil {
            
            self.locationManager = CLLocationManager()
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.delegate = self
            if CLLocationManager.authorizationStatus() == .notDetermined {
                locationManager!.requestWhenInUseAuthorization()
            }
            CFRunLoopRun()
            
        }
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse &&
            CLLocationManager.authorizationStatus() != .authorizedAlways {
            return nil
        }
        
        currentLocation = nil
        locationManager?.startUpdatingLocation()
        
        self.performSelector(inBackground: #selector(backgroundTimeout), with: nil)
        
        CFRunLoopRun()
        locationManager?.stopUpdatingLocation()
        
        return currentLocation
        
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if CLLocationManager.authorizationStatus() != .notDetermined {
            CFRunLoopStop(CFRunLoopGetCurrent())
        }
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count > 0 {
            currentLocation = locations.last
            CFRunLoopStop(CFRunLoopGetCurrent())
        }
        
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        currentLocation = nil
        CFRunLoopStop(CFRunLoopGetCurrent())
        
    }

    @objc func backgroundTimeout() {
        
        Thread.sleep(forTimeInterval: RequestTimeout)
        self.performSelector(onMainThread: #selector(timeout), with: nil, waitUntilDone: false)
        
    }
    
    @objc func timeout() {
        
        if currentLocation == nil {
            CFRunLoopStop(CFRunLoopGetCurrent())
        }
        
    }
    
}
