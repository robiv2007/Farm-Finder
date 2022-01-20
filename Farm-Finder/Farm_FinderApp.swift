//
//  Farm_FinderApp.swift
//  Farm-Finder
//
//  Created by vatran robert on 2022-01-12.
//

import SwiftUI
import Firebase

@main
struct Farm_FinderApp: App {
   
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            let viewModel = AppViewModel()
            
            LoginView()
                .environmentObject(viewModel)
            //EditProfileView()
           
          

        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
       
        FirebaseApp.configure()
        
        return true
    }
}
