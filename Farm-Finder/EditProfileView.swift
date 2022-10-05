//
//  EditProfileView.swift
//  Farm-Finder
//
//  Created by vatran robert on 2022-09-05.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseStorage
import MapKit


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
    @State var locationTextField : String = ""
    @State private var imageURL = URL(string:"")
    @State private var showingSheet = false
    @State var entry: FarmEntry? = nil
    @ObservedObject private var locationManager = LocationManager()
    @State var tapped = false
    
    var tap: some Gesture {
        TapGesture(count: 1)
            .onEnded { _ in self.tapped = !self.tapped
                showingSheet = false
            }
    }
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    var body: some View {
        let coordinate = locationManager.location?.coordinate ?? CLLocationCoordinate2D()
        ScrollView {
            VStack{
                Button(action: {
                    self.showActionSheet = true
                    print("ADD PICTURE")
                }
                       , label: {
                    if uploadImage != nil {
                        Image(uiImage: uploadImage!)
                            .resizable()
                            .frame(width: .infinity, height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                        
                    }else{
                        if let entry = entry {
                            AsyncImage(url: URL(string: entry.image)){image in
                                image
                                    .resizable()
                                    .frame(width: .infinity, height: 300)
                                    .clipShape(RoundedRectangle(cornerRadius: 25))
                            }  placeholder: {
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width: .infinity, height: 300)
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 25))
                            }
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 200, alignment: .trailing)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                        }
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
                if entry != nil {
                    TextField("Farm Name",text: $nameFieldText)
                        .font(.headline)
                        .padding(10)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(20)
                }
                if entry != nil {
                    TextField("City",text: $locationTextField)
                        .font(.headline)
                        .padding(10)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(20)
                }
                Button("Save location on map") {
                    showingSheet.toggle()
                }
                
                
                .sheet(isPresented: $showingSheet){
                    if let entry = entry {
                        
                        MapView(coordinate: coordinate, entry: entry)
                            .overlay {
                                Image(systemName: "x.circle.fill")
                                    .frame(width: 50, height: 50, alignment: .topLeading)
                                    .font(.title)
                                    .offset(x: -160, y: -300)
                                    .gesture(tap)
                            }
                        
                        Text("\(coordinate.latitude), \(coordinate.longitude)")
                            .foregroundColor(.white)
                            .background(.green)
                            .padding(10)
                        Button(action: {
                            self.entry?.latitude = coordinate.latitude
                            self.entry?.longitude = coordinate.longitude
                            showingSheet = false
                        }, label: {
                            Text("Save Location")
                                .font(.title)
                                .frame(width: 200, height: 60)
                                .foregroundColor(.white)
                                .background(.red)
                                .cornerRadius(25)
                        })
                    }
                }
                Text("Write down info about your farm")
                    .frame(width: 300, height: 20, alignment: .center)
                
                ScrollView{
                    if entry != nil {
                        
                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Color(UIColor.secondarySystemBackground))
                            
                            if descriptionText.isEmpty {
                                Text("Write here")
                                    .foregroundColor(Color(UIColor.placeholderText))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 12)
                            } else {
                                TextEditor(text: $descriptionText)
                                    .font(.body)
                                    .frame(width: 400, height: 250, alignment: .topLeading)
                                    .disableAutocorrection(true)
                            }
                            
                            if entry?.content == "" {
                                TextEditor(text: $descriptionText)
                                    .font(.body)
                                    .frame(width: 400, height: 250, alignment: .topLeading)
                                    .disableAutocorrection(true)
                                
                            }
                        }
                    }
                }
                
                Button(action: {
                    if let image = self.uploadImage {
                        uploadTheImage(image: image)
                        secondView = true
                        
                    }else{
                        print("error in upload")
                        saveToFirestore()
                        secondView = true
                    }
                    
                }, label: {
                    Text("Save")
                        .foregroundColor(Color.white)
                        .frame(width: 200, height:50)
                        .background(Color.blue)
                        .cornerRadius(25)
                })
                Spacer()
                NavigationLink(destination: ContentView() ,isActive: $secondView) {EmptyView()}
                
            }
            .padding()
        }
        .onAppear(){
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            print("THIS IS UID \(uid)")
            self.entry = FarmEntry(owner: uid ,name: "", content: "", image: "",location: "", latitude: 0.0, longitude: 0.0)
            
            print("EMPTY ENTRY:NAME")
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
                                if nameFieldText == "" {
                                    changeValue()
                                }
                                if descriptionText == "" {
                                    changeValue()
                                }
                                if locationTextField == "" {
                                    changeValue()
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
    func changeValue(){
        nameFieldText = entry?.name ?? "Farm Name"
        descriptionText = entry?.content ?? "Description of your farm"
        locationTextField = entry?.location ?? "City"
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
