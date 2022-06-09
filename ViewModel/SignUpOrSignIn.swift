//
//  SignUpOrSignIn.swift
//  Farm-Finder
//
//  Created by Jesper Söderling on 2022-06-01.
//

import Foundation
import FirebaseAuth

class SignUpOrSignIn: ObservableObject {
    
    let auth = Auth.auth()
    @Published var signedIn = false
    @Published var isLoggedInView = false
    
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
                self?.isLoggedInView = true
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
                self?.isLoggedInView = true
            }
            
        }
    }
}
