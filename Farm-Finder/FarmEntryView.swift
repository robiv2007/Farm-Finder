//
//  FarmEntryView.swift
//  Farm-Finder
//
//  Created by vatran robert on 2022-01-12.
//

import SwiftUI

struct FarmEntryView : View {
    var entry: FarmEntry
   
    var body: some View {
        VStack{
            MapView(coordinate: entry.coordinate)
                .ignoresSafeArea(edges: .top)
                .frame(height: 300)
            
            Image(entry.image)
                .resizable()
                .frame(width: 300, height: 300, alignment: .center)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.white,lineWidth: 4)
                }
                .shadow(radius: 7)
                .offset(y: -130)
                .padding(.bottom, -130)
         VStack(alignment: .leading) {
             Text(entry.name)
                    .font(.title)
                HStack {
                    Text(entry.location).font(.subheadline)
                    Spacer()
                    Text("Haninge")
                }
                .font(.subheadline)
                    .foregroundColor(.secondary)
             Divider()
             
             Text("About The Farm")
                 .font(.title2)
             ScrollView{
             Text(entry.content)
             }
            
            }
         .padding()
            
            Spacer()
            
            
        }
       
    }
    
    
}
