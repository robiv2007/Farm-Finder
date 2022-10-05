//
//  SignUpView.swift
//  Farm-Finder
//
//  Created by vatran robert on 2022-09-05.
//

import Foundation
import SwiftUI
import FirebaseAuth


struct SignUpView: View {
    
    @EnvironmentObject var viewModel : AppViewModel
    @State var email  = ""
    @State var password  = ""
    @State var verifyPassword = ""
    @State var visible = false
    @State private var keyboardHeight: CGFloat = 100
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
        .padding()
        .padding(.bottom,keyboardHeight)
        .navigationTitle("Register")
        
        
    }
}

