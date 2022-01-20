//
//  MapView.swift
//  Farm-Finder
//
//  Created by vatran robert on 2022-01-12.
//

import Foundation
import MapKit
import SwiftUI

struct MapView: View {
    var coordinate: CLLocationCoordinate2D
    @State private var region = MKCoordinateRegion()
   
    
//    MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 59.1216, longitude: 18.0973 ), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    var body: some View {
        
        Map(coordinateRegion: $region)
           
        
            .onAppear {
                setRegion(coordinate)
                 
            }
       
    }
    
    private func setRegion(_ coordinate: CLLocationCoordinate2D){
        
        region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
            
    }
//    func setPinUsingMKPlacemark(location: CLLocationCoordinate2D) {
//       let pin = MKPlacemark(coordinate: location)
//        var coordinateRegion = MKCoordinateRegion(center: pin.coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
//        coordinateRegion = coordinate
//
//        //MapMarker(coordinate: coordinate)
//    }
    
    
    
}

