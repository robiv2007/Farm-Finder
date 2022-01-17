//
//  ContentView.swift
//  Farm-Finder
//
//  Created by vatran robert on 2022-01-12.
//

import SwiftUI

struct ContentView: View {
  
    var farm = FarmPage()
    var body: some View {
        NavigationView{
        List(){
            ForEach(farm.entries)
            { entry in
                NavigationLink(destination: FarmEntryView(entry: entry)) {
                HStack{
                    Image(entry.image)
                        .resizable()
                        .frame(width: 130, height: 130)
                        .scaledToFit()
                        .clipShape(Circle())
                        
                        
                        
                    VStack{
                Text(entry.name)
                        Text(entry.content)
                            .lineLimit(1)
                            .padding()
                    }
                    }
                
                    /*var date : String {
                        let dateFormatter = dateFormatter()
                        dateFormatter.dateStyle = .medium
                        
                        return dateFormatter.string(from: entry.date)
                    }*/
                
                }
               
            }
                .padding()
                .background(Color.blue)
                .cornerRadius(20)
            
           }
    
       }
        
        .navigationBarHidden(true)
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
