//
//  UploadAndSaveToFirestore.swift
//  Farm-Finder
//
//  Created by Jesper Söderling on 2022-06-02.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseStorage


class ViewModel: ObservableObject {
    var db = Firestore.firestore()
    
    
//    func uploadImage(image: UIImage) {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        let storageRef = Storage.storage().reference().child("user\(uid)")
//
//        guard let imageData = image.jpegData(compressionQuality: 1) else { return }
//
//        let metaData = StorageMetadata()
//        metaData.contentType = "image/jpg"
//
//        storageRef.putData(imageData, metadata: metaData) {
//            metaData, error in
//            if error == nil , metaData != nil {
//                storageRef.downloadURL {url, error in
//                   self.imageURL = url
//                    saveToFirestore()
//                }
//            }
//            else {
//                print("ERROR IN UPLOAD IMAGE FUNC")
//
//            }
//        }
//    }
    
    func saveToFirestore(farmEntry: FarmEntry) {
        print("save 1")
        guard let uid = Auth.auth().currentUser?.uid else { return }
//        let user = FarmEntry(owner: uid, name: nameFieldText, content: descriptionText, image : imageURL?.absoluteString ?? entry?.image as! String,location: locationTextField , latitude: entry?.latitude ?? 59.11966, longitude: entry?.longitude ?? 18.11518)
        
        do {
            _ = try db.collection("farms").document(uid).setData(from: farmEntry)
            
        } catch {
            print("Error in saving the data")
        }
    }
    
    func changeValue() {
        @State var entry: FarmEntry? = nil
        @State var descriptionText : String = ""
        @State var nameFieldText : String = ""
        @State var locationTextField : String = ""
        
        
        nameFieldText = entry?.name ?? "Farm Name"
        descriptionText = entry?.content ?? "Description of your farm"
        locationTextField = entry?.location ?? "City"
    }
    
    
    
}
