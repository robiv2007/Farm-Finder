//
//  GetFarm.swift
//  Farm-Finder
//
//  Created by Jesper Söderling on 2022-06-08.
//

import Foundation
import FirebaseAuth
import Firebase


class GetUserFarm: ObservableObject {
    var db = Firestore.firestore()
    @Published var entry: FarmEntry? = nil
   
    
    
    func getFarm() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        self.entry = FarmEntry(owner: uid ,name: "", content: "", image: "",location: "", latitude: 0.0, longitude: 0.0)
        
        db.collection("farms").whereField("owner", isEqualTo: uid).getDocuments() {
            snapshot, err in
            print("DB Collection")
            guard let snapshot = snapshot else{ print("Snapshot")
                return }
            
            if let err = err {
                print("Error to get documents \(err)")
            } else {
                for document in snapshot.documents {
                    let result = Result {
                        try document.data(as: FarmEntry.self)
                    }
                    switch result {
                    case.success(let item ) :
                        if let item = item {
                            print("item")
                            self.entry = item
                            print("ITEM!!: \(item)")
                          
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
