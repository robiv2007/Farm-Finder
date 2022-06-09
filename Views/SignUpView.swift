//
//  SignUpView.swift
//  Farm-Finder
//
//  Created by Jesper Söderling on 2022-06-01.
//

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var viewModel : SignUpOrSignIn
    @State var email  = ""
    @State var password  = ""
    @State var verifyPassword = ""
    @State var passwordIsVisible = false
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
                
                if self.passwordIsVisible {
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
                    self.passwordIsVisible.toggle()
                },label: {
                    
                    Image(systemName: self.passwordIsVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(Color.primary)
                    
                })
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            
            HStack(spacing: 15){
                
                if self.passwordIsVisible {
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
                    self.passwordIsVisible.toggle()
                },label: {
                    
                    Image(systemName: self.passwordIsVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(Color.primary)
                    
                })
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            
            
            NavigationLink(destination: LoginView() ,isActive: $viewModel.isLoggedInView){EmptyView()
            }
            Button(action: {
                
                if password == verifyPassword {
                    viewModel.signUp(email: email, password: password)
                    
                }
                else{
                    passwordIsVisible = true
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

