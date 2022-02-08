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
    var entry : FarmEntry
   
    var body: some View {
        let annotationItem: [FarmEntry] = [FarmEntry(name: entry.name, content: "", image: "", latitude: entry.latitude, longitude: entry.longitude)]
        Map(coordinateRegion: $region,
            annotationItems: annotationItem) {
            item in
            MapMarker(coordinate: entry.coordinate, tint: .red)
        }
        
            .onAppear {
                setRegion(coordinate)
             
            }
    }
    
    private func setRegion(_ coordinate: CLLocationCoordinate2D){
      
        region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
            
    }
    
}

