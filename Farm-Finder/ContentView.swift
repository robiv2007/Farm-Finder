//
//  ContentView.swift
//  Farm-Finder
//
//  Created by vatran robert on 2022-01-12.
//

import SwiftUI
import Firebase
import FirebaseStorage

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
    
    var db = Firestore.firestore()
    @State var showActionSheet = false
    @State var showImagePicker = false
    
    @State var sourceType: UIImagePickerController.SourceType = .camera
    @State var uploadImage : UIImage?
    @State var descriptionText : String = ""
    @State var nameFieldText : String = ""
    @State private var imageURL = URL(string:"")
    
    var body: some View {
        VStack{
            Button(action: {
                // Add photo
                self.showActionSheet = true
                print("ADD PICTURE")
            }
                   , label: {
                if uploadImage != nil {
                    Image(uiImage: uploadImage!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                    
                }else{
                    
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150, alignment: .trailing)
                        .padding()
                }
                
            }).actionSheet(isPresented: $showActionSheet){
                ActionSheet(title: Text("Add a picture to the profile"), message: nil, buttons: [
                    
                    .default(Text("Camera"),action: {
                        self.showImagePicker = true
                        self.sourceType = .camera
                    }),
                    
                        .default(Text("Photo library"), action: {
                            self.showImagePicker = true
                            self.sourceType = .photoLibrary
                        }),
                    .cancel()
                    
                ])
                
            }
            .sheet(isPresented: $showImagePicker){
                imagePicker(image: self.$uploadImage, showImagePicker:
                                self.$showImagePicker, sourceType:
                                self.sourceType)
            }
            
            Text("Add a picture ")
            
            TextField("Farm's name", text: $nameFieldText)
                .font(.title)
                .padding()
            Text("Write down info about your farm")
                .frame(width: 300, height: 20, alignment: .topLeading)
            
            TextEditor(text: $descriptionText)
            
            Button(action: {
                if let image = self.uploadImage {
                    uploadTheImage(image: image)
                }else{
                    print("error in upload")
                }

            }, label: {
                Text("Save")
                    .foregroundColor(Color.white)
                    .frame(width: 200, height:50)
                    .background(Color.blue)
                    .cornerRadius(25)
            })
        }
    }
 
    func uploadTheImage(image: UIImage){
        let storageRef = Storage.storage().reference(withPath: "users")
        if let imageData = image.jpegData(compressionQuality: 1){
            let storage = Storage.storage()
            storage.reference().child("users").putData(imageData, metadata: nil){
                
                (data, err) in
                if let err = err {
                    print("An error has occurred \(err.localizedDescription)")
                }else{
                    print("Succes in uploading")
                }
                
            }
        } else {
            print("culd't unrap")
        }
        storageRef.downloadURL { (url, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
            self.imageURL = url!
            print("URL\(url?.absoluteString as Any)")
            saveToFirestore()
            
        }
    }
    func saveToFirestore() {
        let user = FarmEntry(name: nameFieldText, content: descriptionText, image : imageURL!.absoluteString, latitude: 59.11966, longitude: 18.11518)
        
        do {
            _ = try db.collection("users").addDocument(from: user)
        } catch {
            print("Error in saving the data")
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        //ContentView()
        EditProfileView()
    }
}
