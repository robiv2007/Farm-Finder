//
//  LoginView.swift
//  Farm-Finder
//
//  Created by vatran robert on 2022-01-14.
//

import SwiftUI

struct LoginView: View {
    
    @State var email : String = ""
    @State var password : String = ""
   
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
                    .foregroundColor(Color.white)
                    .background(Color(
                    .secondarySystemBackground))
                        
                       
                
                TextField("Email Adress",text: $email)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                    Button(action: {
                        
                        
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
            .navigationTitle("Farm Finder")
            
        }
        
       
    
    }
       
        
       
        
}
    


struct SignUpView: View {
    
    @State var email : String = ""
    @State var password : String = ""
    var body: some View {
        
        NavigationView{
            VStack{
                
               
        Image("logo")
            .resizable()
           // .scaledToFit()
            .position(x: 225, y: 50)
            .frame(width: 450, height: 300)
            
   
            TextField("Email Adress",text: $email)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                
                    Button(action: {
                        
                        
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
           
        }
        .navigationTitle("Register")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
