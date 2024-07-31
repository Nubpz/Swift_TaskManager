//
//  MainViewViewModel.swift
//  Gritodo
//
//  Created by Nabin Poudel on 7/13/24.
//

import FirebaseAuth
import Foundation


class ContentViewViewModel: ObservableObject {
    @Published var currentUserId: String = ""
    private var handler: AuthStateDidChangeListenerHandle?
    
    init(){
        setupAuthenticationListener()
    }
    
    private func setupAuthenticationListener() {
        handler = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let user = user else {
                self?.currentUserId = ""
                return
            }
            self?.currentUserId = user.uid
        }
    }
    
        public var isSignedIn: Bool{
            return Auth.auth().currentUser != nil
        }
    
    deinit {
        if let handler = handler {
            Auth.auth().removeStateDidChangeListener(handler)
        }
    }
}
