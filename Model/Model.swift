//
//  UploadAndSaveToFirestore.swift
//  Farm-Finder
//
//  Created by Jesper Söderling on 2022-06-02.
//

import Foundation
import SwiftUI
import Firebase

class Model: ObservableObject {
    var db = Firestore.firestore()
    
    func saveToFirestore(farmEntry: FarmEntry) {
        print("save 1")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            _ = try db.collection("farms").document(uid).setData(from: farmEntry)
            
        } catch {
            print("Error in saving the data")
        }
    }
    
    
}

