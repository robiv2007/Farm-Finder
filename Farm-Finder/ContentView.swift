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
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        
                    VStack{
                Text(entry.name)
                        Text(entry.content)
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
            
            
        }
            
}
    }
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
