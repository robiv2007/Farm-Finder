//
//  LoginView.swift
//  Farm-Finder
//
//  Created by vatran robert on 2022-01-14.
//

import SwiftUI
import FirebaseAuth

class AppViewModel: ObservableObject {
    
    let auth = Auth.auth()
    @Published var signedIn = false
    @Published var anotherView = false
    @Published var secondView = false

    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    func signIn(email: String, password: String){
        
        auth.signIn(withEmail: email, password: password) {
            [weak self] result, error in
            guard result != nil, error == nil
            else {
                return
            }
            self?.signedIn = true
            if self?.signedIn == true{
                self?.anotherView = true
            }
        }
    }
    
    func signUp(email: String, password: String){
        auth.createUser(withEmail: email, password: password) {
            [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            
            self?.signedIn = true
            if self?.signedIn == true {
                self?.anotherView = true
            }
            
        }
    }
}

struct LoginView: View {
    
    @State var email  = ""
    @State var password  = ""
    @State var visible = false
    @EnvironmentObject var viewModel : AppViewModel
    //var entry : FarmEntry
    
    var body: some View {
        
            NavigationView{
        
       VStack{
                Image("logo")
            .resizable()
            .scaledToFit()
            .frame(width: 350, height: 200)
            .lineLimit(100)
            
           NavigationLink(destination: ContentView())
                   {
                           Text("Browse the farms")
                              .foregroundColor(Color.white)
                              .frame(width: 300, height: 70 )
                              .background(Color.blue)
                              .cornerRadius(25)
                              .padding()
                   }
                Text("Or Login with your farm")
               .frame(width: 200, height: 20, alignment: .center)
                    .foregroundColor(Color.white)
                    .background(Color.green)
                    .cornerRadius(20)
                    .padding()
           
                TextField("Email Adress",text: $email)
               .disableAutocorrection(true)
               .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
           
           HStack(spacing: 15){
               
           if self.visible {
           TextField("Password", text: $password)
               .disableAutocorrection(true)
               .autocapitalization(.none)

           }
           else {
               SecureField("Password", text: $password)
                   .disableAutocorrection(true)
                   .autocapitalization(.none)
                    
           }
               Button(action: {
                   self.visible.toggle()
               },label: {
                   
                   Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                       .foregroundColor(Color.primary)
                    
               })
            
           }
           .padding()
           .background(Color(.secondarySystemBackground))

           NavigationLink(destination: EditProfileView(),isActive: $viewModel.anotherView){EmptyView()
               }
                    Button(action: {
                
                        viewModel.signIn(email: email, password: password)

                    }, label: {
                            Text("Login")
                                .foregroundColor(Color.white)
                                .frame(width: 200, height:50)
                                .background(Color.blue)
                                .cornerRadius(25)
                                .padding()
                    })
          
               NavigationLink("Register your farm",destination: SignUpView())
                Spacer()
           }
            .navigationTitle("Login Page")
        }
    }
}
    
struct SignUpView: View {
    
    @EnvironmentObject var viewModel : AppViewModel
    @State var email  = ""
    @State var password  = ""
    @State var verifyPassword = ""
    @State var visible = false
    var body: some View {
        
            VStack{
        Image("logo")
            .resizable()
            .position(x: 225, y: 50)
            .frame(width: 450, height: 300)
            
            TextField("Email Adress",text: $email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                HStack(spacing: 15){
                    
                if self.visible {
                TextField("Password", text: $password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                }
                else {
                    SecureField("Password", text: $password)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                }
                    Button(action: {
                        self.visible.toggle()
                    },label: {
                        
                        Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(Color.primary)
                        
                    })
          
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                
                HStack(spacing: 15){
                    
                if self.visible {
                TextField("Retype Password", text: $verifyPassword)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                }
                else {
                    SecureField("Retype Password", text: $verifyPassword)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                }
                    Button(action: {
                        self.visible.toggle()
                    },label: {
                        
                        Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(Color.primary)
                        
                    })
          
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                
            
                NavigationLink(destination: LoginView() ,isActive: $viewModel.anotherView){EmptyView()
                }
                    Button(action: {
                        
                        if password == verifyPassword {
                            viewModel.signUp(email: email, password: password)
                            
                        }
                        else{
                            visible = true
                            password = "Type missmatch"
                           verifyPassword = "Type missmatch"
                            
                        }
                        
  
                    }, label: {
                        Text("Create Account")
                            .foregroundColor(Color.white)
                            .frame(width: 200, height:50)
                            .background(Color.blue)
                            .cornerRadius(25)
                        
                    })
                    .padding()
                 Spacer()
            }
        .navigationTitle("Register")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
