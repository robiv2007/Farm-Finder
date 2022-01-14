//
//  LocationManager.swift
//  Farm-Finder
//
//  Created by vatran robert on 2022-01-12.
//

import Foundation
import CoreLocation

class LocationManager: NSObject , CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    var location: CLLocationCoordinate2D?
    
    
    
    override init () {
        super.init()
        manager.delegate = self
    }
    
    func askForPermission() {
        manager.requestWhenInUseAuthorization()
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
       
    }
    
}


