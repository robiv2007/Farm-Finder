//
//  EditProfleViewModel.swift
//  Farm-Finder
//
//  Created by vatran robert on 2022-10-07.
//

import Foundation
import SwiftUI
import FirebaseAuth
import Firebase

class EditProfileVIewModel: ObservableObject {
    
    @Published var showActionSheet = false
    @Published var showImagePicker = false
    @Published var anotherView = false
    @Published var secondView = false
    @Published var sourceType: UIImagePickerController.SourceType = .camera
    @Published var uploadImage : UIImage?
    @Published var descriptionText : String = ""
    @Published var nameFieldText : String = ""
    @Published var locationTextField : String = ""
    @Published var imageURL = URL(string:"")
    @Published var showingSheet = false
    var entry: FarmEntry? = nil
    
    @Published var db = Firestore.firestore()
   
    func changeValue(){
        self.nameFieldText = entry?.name ?? "Farm Name"
        self.descriptionText = entry?.content ?? "Description of your farm"
        self.locationTextField = entry?.location ?? "City"
    }
    
    func saveToFirestore() {
        print("save 1")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let user = FarmEntry(owner: uid, name: nameFieldText, content: descriptionText, image : imageURL?.absoluteString ?? entry?.image as! String,location: locationTextField , latitude: entry?.latitude ?? 59.11966, longitude: entry?.longitude ?? 18.11518)
        
        do {
            _ = try db.collection("farms").document(uid).setData(from: user)
            
        } catch {
            print("Error in saving the data")
        }
    }
    
    
    
}
