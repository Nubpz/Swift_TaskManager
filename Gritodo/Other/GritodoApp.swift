//
//  GritodoApp.swift
//  Gritodo
//
//  Created by Nabin Poudel on 7/13/24.
//
import FirebaseCore
import SwiftUI

@main
struct GritodoApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
