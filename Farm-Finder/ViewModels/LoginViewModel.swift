//
//  LoginViewModel.swift
//  Farm-Finder
//
//  Created by vatran robert on 2022-10-07.
//

import Foundation
import FirebaseAuth


class LoginViewModel: ObservableObject {
    
    let auth = Auth.auth()
    @Published var signedIn = false
    @Published var anotherView = false
    @Published var secondView = false
    @Published var email  = ""
    @Published var password  = ""
    @Published var visible = false
    
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

