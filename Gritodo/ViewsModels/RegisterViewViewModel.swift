//
//  RegisterViewViewModel.swift
//  Gritodo
//
//  Created by Nabin Poudel on 7/13/24.
//

import FirebaseFirestore
import FirebaseAuth
import Foundation

class RegisterViewViewModel: ObservableObject{
    @Published  var fullName: String = ""
    @Published  var email: String = ""
    @Published  var password: String = ""
    @Published  var isPressed: Bool = false
    @Published  var animate = false
    @Published  var showingLoginView = false
    
    init() {}
    
    func register() {
        guard validate() else{
            return
        }
        Auth.auth().createUser(withEmail: email, password: password){[weak self]result, error in
            guard let userId = result?.user.uid else{
                return
            }
            self?.insertUserRecord(id: userId)
        }
    }
    
    private func insertUserRecord(id: String){
        let newUser = User(id: id, name: fullName, email: email, joined: Date().timeIntervalSince1970)
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(id)
            .setData(newUser.asDictionary())
    }
    
    private func validate() -> Bool{
        guard !fullName.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else{
            return false
        }
        
        guard email.contains("a") && email.contains(".")else{
            return false
        }
        guard password.count >= 6 else{
            return false
        }
        return true
    }
}
