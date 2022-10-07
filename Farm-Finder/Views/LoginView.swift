//
//  LoginView.swift
//  Farm-Finder
//
//  Created by vatran robert on 2022-01-14.
//

import SwiftUI
import FirebaseAuth


struct LoginView: View {

    @StateObject var vm = LoginViewModel()
    @State private var keyboardHeight: CGFloat = 140
    
    var body: some View {
        
        NavigationView{
            
            VStack{
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 200)
                    .lineLimit(100)
                    .overlay {
                        Text("Farm Finder")
                            .font(.largeTitle)
                            .bold()
                            .offset(y: 85)
                            .padding()
                            
                    }
                
                NavigationLink(destination: ContentView())
                {
                    Text("Browse the farms")
                        .foregroundColor(Color.white)
                        .frame(width: 300, height: 50)
                        .font(.title2)
                        .background(Color.blue)
                        .cornerRadius(25)
                        .padding()
                }
                Text("Or Login with your farm")
                    //.foregroundColor(Color.secondary)
                
                
                TextField("Email Adress",text: $vm.email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(20)
                   
                HStack(spacing: 15){
                    
                    if vm.visible {
                        TextField("Password", text: $vm.password)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                          
                    }
                    else {
                        SecureField("Password", text: $vm.password)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                 
                    }
                    Button(action: {
                        vm.visible.toggle()
                    },label: {
                        
                        Image(systemName: vm.visible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(Color.primary)
                    })
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(25)
                
                NavigationLink(destination: EditProfileView(),isActive: $vm.anotherView){EmptyView()
                }
                Button(action: {
                    
                    vm.signIn(email: vm.email, password: vm.password)
                    
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
            .padding()
            .padding(.bottom,keyboardHeight)
            //.navigationTitle("Login Page")
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
