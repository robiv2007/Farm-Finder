//
//  ContentView.swift
//  Farm-Finder
//
//  Created by vatran robert on 2022-01-12.
//

import SwiftUI
import Firebase
import FirebaseStorage
import MapKit

struct ContentView: View {
    var db = Firestore.firestore()
    var auth = Auth.auth()
    @State var farms = [FarmEntry]()
    var columns = [
        GridItem(.adaptive(minimum: 400)),
        //GridItem(.adaptive(minimum: 200))
    ]
    
    var body: some View {
        //List(){
        ScrollView{
        LazyVGrid(columns: columns){
            ForEach(farms)
            { entry in
                NavigationLink(destination: FarmEntryView(entry: entry)) {
                    
                    VStack{
                       
                        AsyncImage(url: URL(string: entry.image)){image in
                            image
                                .resizable()
                                //.scaledToFit()
                                .frame(width: 300, height: 300)
                                
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                        }  placeholder: {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 350)
                               
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                        }
                        VStack{
                            Text(entry.name)
                                .font(.headline)
                            
                            Text(entry.content)
                                .lineLimit(1)
                                .padding(2)
                                .foregroundColor(Color.white)
                              
                        }
                    }
                    .frame(width: 350, height: 400)
                    .background(.thinMaterial)
                    .cornerRadius(20)
                }
            }
            
            //.listRowInsets(.init(top: 5, leading: 10, bottom: 5, trailing: 10))
//            .background(Color.clear)
//            .padding(5)
//            .cornerRadius(20)
        
          }
        }
        .onAppear(){
            listenToFirestore()
        }
    }
    func listenToFirestore() {
        db.collection("farms").addSnapshotListener { snapshot, err in
            guard let snapshot = snapshot else { return }
            
            if let err = err {
                print("Error to get documents \(err)")
            } else {
                farms.removeAll()
                for document in snapshot.documents {
                    let result = Result {
                        try document.data(as: FarmEntry.self)
                    }
                    switch result {
                    case.success(let item ) :
                        if let item = item {
                            farms.append(item)
                            for i in farms {
                                print(i)
                            }
                        } else {
                            print("Document does not exist")
                        }
                        
                    case.failure(let error) :
                        print("Error decoding item \(error)")
                        
                    }
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        //EditProfileView()
    }
}
