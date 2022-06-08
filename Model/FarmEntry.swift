//
//  FarmEntry.swift
//  Farm-Finder
//
//  Created by vatran robert on 2022-01-12.
//

import Foundation
import CoreLocation
import FirebaseFirestoreSwift
import UIKit
import SwiftUI


struct FarmEntry : Identifiable, Codable {
    @DocumentID var id : String?
    var owner : String? = nil
    var name : String
    var content: String
    var image : String
    var location : String?
    var latitude: Double
    var longitude: Double
    
    
    var coordinate : CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}


