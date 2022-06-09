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
    
    var body: some View {
        List(){
            ForEach(farms)
            { entry in
                NavigationLink(destination: FarmEntryView(entry: entry)) {
                    HStack{
                        
                        AsyncImage(url: URL(string: entry.image)){image in
                            image
                                .resizable()
                                .frame(width: 130, height: 130)
                                .scaledToFit()
                                .clipShape(Circle())
                        }  placeholder: {
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 130, height: 130)
                                .scaledToFit()
                                .clipShape(Circle())
                        }
                        VStack{
                            Text(entry.name)
                                .font(.headline)
                            
                            Text(entry.content)
                                .lineLimit(1)
                                .padding()
                        }
                    }
                }
            }
            .background(Color.clear)
            .padding(5)
            .cornerRadius(20)
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


   
   
