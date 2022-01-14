//
//  FarmEntry.swift
//  Farm-Finder
//
//  Created by vatran robert on 2022-01-12.
//

import Foundation
import CoreLocation


struct FarmEntry : Identifiable {
    var id = UUID()
    var name : String
    var content: String
    var image : String
    var date : Date = Date()
    var location : String
    var latitude: Double
    var longitude: Double
    
    
    
    var coordinate : CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
