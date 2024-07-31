////
////  ProfileViewViewModel.swift
////  Gritodo
////
////  Created by Nabin Poudel on 7/15/24.
////
//
//import FirebaseAuth
//import FirebaseFirestore
//import Foundation
//
//class ProfileViewViewModel: ObservableObject {
//    init() {}
//    @Published var user: User? = nil
//    
//    func fetchUser(){
//        guard let userId = Auth.auth().currentUser?.uid else {
//            return
//        }
//        let db = Firestore.firestore()
//        db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
//            guard let data = snapshot?.data(), error == nil else {
//                return
//            }
//            
//            DispatchQueue.main.async{
//                self?.user = User(
//                    id: data["id"] as? String ?? "",
//                    name: data["name"] as? String ?? "",
//                    email: data["email"] as? String ?? "",
//                    joined: data["joined"] as? TimeInterval ?? 0
//                )
//            }
//        }
//    }
//    
//    func logOut() {
//        do{
//            try Auth.auth().signOut()
//        }catch{
//            print(error)
//        }
//    }
//    
//    func deleteAccount(completion: @escaping (Bool) -> Void) {
//            guard let user = Auth.auth().currentUser else {
//                completion(false)
//                return
//            }
//            
//            let userId = user.uid
//            let db = Firestore.firestore()
//            
//            // Start a batch to delete user data and then the user account
//            let batch = db.batch()
//            
//            // Reference to the user's document
//            let userDoc = db.collection("users").document(userId)
//            batch.deleteDocument(userDoc)
//            
//        let userDoc1 = db.collection("notifications").document(userId)
//        batch.deleteDocument(userDoc1)
//        
//            // Commit the batch
//            batch.commit { error in
//                if error != nil {
//                    completion(false)
//                    return
//                }
//                
//                // If user data deletion is successful, delete the user account
//                user.delete { error in
//                    if error != nil {
//                        completion(false)
//                    } else {
//                        completion(true)
//                    }
//                   
//                }
//            }
//        }
//}
//
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class ProfileViewViewModel: ObservableObject {
    init() {}
    @Published var user: User? = nil
    
    
    func fetchUser(){
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            
            DispatchQueue.main.async{
                self?.user = User(
                    id: data["id"] as? String ?? "",
                    name: data["name"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    joined: data["joined"] as? TimeInterval ?? 0
                )
            }
        }
    }
    
    func logOut() {
        do{
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.user = nil
            }
        }catch{
            print(error)
        }
    }
    
    func deleteAccount(completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(false)
            return
        }
        
        let userId = user.uid
        let db = Firestore.firestore()
        
        // Start a batch to delete user data and then the user account
        let batch = db.batch()
        
        // Reference to the user's document
        let userDoc = db.collection("users").document(userId)
        batch.deleteDocument(userDoc)
        
        // Commit the batch
        batch.commit { error in
            if error != nil {
                completion(false)
                return
            }
            
            // If user data deletion is successful, delete the user account
            user.delete { error in
                if error != nil {
                    completion(false)
                } else {
                    DispatchQueue.main.async {
                        self.user = nil
                    }
                    completion(true)
                }
            }
        }
    }
}
