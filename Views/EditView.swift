//
//  EditView.swift
//  Farm-Finder
//
//  Created by Jesper Söderling on 2022-06-02.
//

import SwiftUI
import Firebase
import FirebaseStorage
import MapKit


struct EditProfilePicture : View {
    @EnvironmentObject var getFarm : GetUserFarm
    @State var showActionSheet = false
    @State var showImagePicker = false
    @State var sourceType: UIImagePickerController.SourceType = .camera
    @State var uploadImage : UIImage?
    @State var entry: FarmEntry? = nil
   
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    var body: some View {
        ScrollView {
            VStack{
                Button(action: {
                    self.showActionSheet = true                }
                       , label: {
                    if uploadImage != nil {
                        if let uploadImage = uploadImage {
                            Image(uiImage: uploadImage)
                                .resizable()
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                        }
                    }else{
                        if let entry = entry {
                            AsyncImage(url: URL(string: entry.image)){image in
                                image
                                    .resizable()
                                    .frame(width: 200, height: 200)
                                    .clipShape(Circle())
                            }  placeholder: {
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width: 200, height: 200)
                                    .scaledToFit()
                                    .clipShape(Circle())
                            }
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200, alignment: .trailing)
                                .clipShape(Circle())
                        }
                    }
                    
                }).actionSheet(isPresented: $showActionSheet) {
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
            }
            .sheet(isPresented: $showImagePicker){
                imagePicker(image: self.$uploadImage, showImagePicker:
                                self.$showImagePicker, sourceType:
                                self.sourceType)
            }
            
            Text("Add a picture ")
            EditFarmNameAndLocation()
            EditDescription()
        }
        .onAppear() {
            getFarm.getFarm()
        }
        
    }
}

struct EditFarmNameAndLocation: View {
    @ObservedObject private var locationManager = LocationManager()
    @EnvironmentObject var getFarm : GetUserFarm
    @StateObject var model = SaveFarm()
    
    @State var descriptionText : String = ""
    @State var nameFieldText : String = ""
    @State var locationTextField : String = ""
    @State private var imageURL = URL(string:"")
    @State private var showingSheet = false
    @State var tapped = false
    var db = Firestore.firestore()
    
    var tap: some Gesture {
        TapGesture(count: 1)
            .onEnded { _ in self.tapped = !self.tapped
                showingSheet = false
            }
    }
    
    var body: some View {
        let coordinate = locationManager.location?.coordinate ?? CLLocationCoordinate2D()
        if getFarm.entry != nil {
            TextField("Farm Name",text: $nameFieldText)
                .font(.largeTitle)
                .padding(5)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(20)
                .disableAutocorrection(true)
        }
        
        if getFarm.entry != nil {
            TextField("City",text: $locationTextField)
                .font(.title)
                .padding(6)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(20)
                .disableAutocorrection(true)
        }
        Button("Save location on map") {
            showingSheet.toggle()
        }
        
        .sheet(isPresented: $showingSheet){
            if getFarm.entry != nil {
                
                MapView(coordinate: coordinate, entry: getFarm.entry!)
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
                    self.getFarm.entry?.latitude = coordinate.latitude
                    self.getFarm.entry?.longitude = coordinate.longitude
                    showingSheet = false
                }, label: {
                    Text("Save Location")
                        .font(.headline)
                        .frame(width: 200, height: 60)
                        .foregroundColor(.white)
                        .background(.red)
                        .cornerRadius(25)
                })
            }
        }
        .onAppear() {
           
        }
        
    }

    func changeValueOfTextfields(){
        if nameFieldText == "" {
            nameFieldText = getFarm.entry?.name ?? "Farm Name"
        }
        if descriptionText == "" {
            descriptionText = getFarm.entry?.content ?? "Description of your farm"
        }
        if locationTextField == "" {
            locationTextField = getFarm.entry?.location ?? "City"
        }
        
    }
}

struct EditDescription: View {
    @StateObject var saveFarm = SaveFarm()
    @EnvironmentObject var getFarm : GetUserFarm
    @State var descriptionText : String = ""
    @State var nameFieldText : String = ""
    @State var locationTextField : String = ""
    @State private var imageURL = URL(string:"")
    @State var secondView = false
    @State var uploadImage : UIImage?
    var db = Firestore.firestore()
    
    var body: some View {
        Text("Write down info about your farm")
            .frame(width: 300, height: 20, alignment: .center)
        VStack{
            if getFarm.entry != nil {
                
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
                            .font(.title)
                            .frame(width: 400, height: 250, alignment: .topLeading)
                            .disableAutocorrection(true)
                    }
                    
                    if getFarm.entry?.content != "" {
                        TextEditor(text: $descriptionText)
                            .font(.title)
                            .frame(width: 400, height: 250, alignment: .topLeading)
                            .disableAutocorrection(true)
                        
                    }
                }
            }
        }
        Button(action: {
            if let image = self.uploadImage {
                uploadImage(image: image)
                secondView = true
                
            }else{
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let farmEntry = FarmEntry(owner: uid, name: nameFieldText, content: descriptionText, image : imageURL?.absoluteString ?? getFarm.entry?.image as! String ,location: locationTextField , latitude: getFarm.entry?.latitude ?? 59.11966, longitude: getFarm.entry?.longitude ?? 18.11518)
                changeValueOfTextfields(farm: farmEntry)
                saveFarm.saveToFirestore(farmEntry: farmEntry)
                secondView = true
            }
            
        }, label: {
            Text("Save")
                .foregroundColor(Color.white)
                .frame(width: 200, height:50)
                .background(Color.blue)
                .cornerRadius(25)
        })
        NavigationLink(destination: ContentView() ,isActive: $secondView) {EmptyView()}
        
        
        
    }

    func uploadImage(image: UIImage) {
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
                    guard let uid = Auth.auth().currentUser?.uid else { return }
                    let farmEntry = FarmEntry(owner: uid, name: nameFieldText, content: descriptionText, image : imageURL?.absoluteString ?? getFarm.entry?.image as! String,location: locationTextField , latitude: getFarm.entry?.latitude ?? 59.11966, longitude: getFarm.entry?.longitude ?? 18.11518)
                    changeValueOfTextfields(farm: farmEntry)
                    saveFarm.saveToFirestore(farmEntry: farmEntry)
                }
            }
            else {
                print("ERROR IN UPLOAD IMAGE FUNC")
                
            }
        }
    }
    func changeValueOfTextfields(farm: FarmEntry){
        if getFarm.entry?.name == "" {
            nameFieldText = getFarm.entry?.name ?? "Farm Name"
        }
        if descriptionText == "" {
            descriptionText = getFarm.entry?.content ?? "Description of your farm"
        }
        if locationTextField == "" {
            locationTextField = getFarm.entry?.location ?? "City"
        }
        
    }
}

