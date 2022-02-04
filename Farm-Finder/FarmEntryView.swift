//
//  FarmEntryView.swift
//  Farm-Finder
//
//  Created by vatran robert on 2022-01-12.
//

import SwiftUI

struct FarmEntryView : View {
    var entry: FarmEntry
    @Binding var downloadImage : UIImage?
   
    var body: some View {
        ScrollView {
        VStack{
            MapView(coordinate: entry.coordinate)
                .ignoresSafeArea(edges: .top)
                .frame(height: 400)
            
            AsyncImage(url: URL(string: entry.image)){image in
                image
                    .resizable()
                    .frame(width: 300, height: 300, alignment: .center)
                    .scaledToFit()
                    .clipShape(Circle())
                    .overlay {
                            Circle().stroke(.white,lineWidth: 4)
                             }
                    .shadow(radius: 7)
                    .offset(y: -130)
                    .padding(.bottom, -130)
            }  placeholder: {
                //ProgressView()
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 300, height: 300, alignment: .center)
                    .scaledToFit()
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(.white,lineWidth: 4)
                    }
                    .shadow(radius: 7)
                    .offset(y: -130)
                    .padding(.bottom, -130)
            }

         VStack(alignment: .leading) {
             Text(entry.name)
                    .font(.title)
                HStack {
                    Text(entry.location ?? "Handen").font(.subheadline)
                    Spacer()
                    Text("Haninge")
                }
                .font(.subheadline)
                    .foregroundColor(.secondary)
             Divider()
             
             Text("About The Farm")
                 .font(.title2)
         
             Text(entry.content)
 
            }
         .padding()
            
            Spacer()
            
            
           }
        }
    }
}
