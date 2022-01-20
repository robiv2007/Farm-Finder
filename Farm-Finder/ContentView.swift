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
                .background(Color.blue)
                .cornerRadius(20)
            
        }
    }
}

struct EditProfileView : View {
    
    @State var descriptionText : String = ""
    @State var nameFieldText : String = ""
    
    var body: some View {
        VStack{
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150, alignment: .trailing)
            
            Text("Add a picture ")
                
            TextField("Farm's name", text: $nameFieldText)
                .font(.title)
                .padding()
            Text("Write down info about your farm")
                .frame(width: 300, height: 20, alignment: .topLeading)
            
            TextEditor(text: $descriptionText)
            
            Button(action: {
               // save to firebase
                
            }, label: {
                Text("Save")
                    .foregroundColor(Color.white)
                    .frame(width: 200, height:50)
                    .background(Color.blue)
                    .cornerRadius(25)
            })
        }
        
        
    }
    
    
    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        //ContentView()
        EditProfileView()
    }
}
