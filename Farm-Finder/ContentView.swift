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
    var db = Firestore.firestore()
    var auth = Auth.auth()
    @State var farms = [FarmEntry]()
    @State var downloadImage : UIImage?
    
    var body: some View {
        List(){
            ForEach(farms)
            { entry in
                NavigationLink(destination: FarmEntryView(entry: entry ,downloadImage: self.$downloadImage )) {
                HStack{
           
                        AsyncImage(url: URL(string: entry.image)){image in
                            image
                                .resizable()
                                .frame(width: 130, height: 130)
                                .scaledToFit()
                                .clipShape(Circle())
                        }  placeholder: {
                            //ProgressView()
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 130, height: 130)
                                .scaledToFit()
                                .clipShape(Circle())
                        }
                    VStack{
                           Text(entry.name)
                        
                           Text(entry.content)
                            .lineLimit(1)
                            .padding()
                    }
//                    var date : String {
//                        let dateFormatter = dateFormatter()
//                        dateFormatter.dateStyle = .medium
//
//                        return dateFormatter.string(from: entry.date)
//                    }
                    }
                }
            }
                .background(Color.blue)
                .cornerRadius(20)
        }
        .onAppear(){
            listenToFirestore()
        }
    }
    func listenToFirestore() {
        //guard let uid = Auth.auth().currentUser?.uid else { return }
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
                            //print("Item: \(item)")
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

struct EditProfileView : View {
    @EnvironmentObject var viewModel : AppViewModel
   
    var db = Firestore.firestore()
    @State var showActionSheet = false
    @State var showImagePicker = false
    @State var anotherView = false
    @State var secondView = false
    @State var sourceType: UIImagePickerController.SourceType = .camera
    @State var uploadImage : UIImage?
    @State var descriptionText : String = ""
    @State var nameFieldText : String = ""
    @State private var imageURL = URL(string:"")
    //var entry: FarmEntry
   
    var body: some View {
        VStack{
            Button(action: {
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
           // if entry.name == "" {
            TextField("Farm's name", text: $nameFieldText)
                .font(.title)
                .padding()
           // }
//            else {
//                
//                TextField("\(entry.name)",text: $nameFieldText)
//            }
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
//            NavigationLink(destination: ContentView() ,isActive: $viewModel.secondView){EmptyView()
//            }
          }
    }
    func uploadTheImage(image: UIImage) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("user\(uid)")
        
        guard let imageData = image.jpegData(compressionQuality: 1) else { return }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) {
            metaData, error in
            if error == nil , metaData != nil {
                storageRef.downloadURL {url, error in
                    self.imageURL = url
                    saveToFirestore()
                }
            }
            else {
                print("ERROR IN UPLOAD IMAGE FUNC")
            }
        }
    }
    func saveToFirestore() {
        print("save 1")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let user = FarmEntry(name: nameFieldText, content: descriptionText, image : imageURL?.absoluteString ?? "", latitude: 59.11966, longitude: 18.11518)

        do {
            _ = try db.collection("farms").document(uid).setData(from: user)

        } catch {
            print("Error in saving the data")
        }
    }
}
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        //ContentView()
//        //EditProfileView()
//    }
//}
