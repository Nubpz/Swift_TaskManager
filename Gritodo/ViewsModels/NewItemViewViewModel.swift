//
//  NewItemViewViewModel.swift
//  Gritodo
//
//  Created by Nabin Poudel on 7/15/24.
//

//import Foundation
//import FirebaseAuth
//import FirebaseFirestore
//
//class NewItemViewViewModel: ObservableObject{
//    @Published var title = ""
//    @Published var dueDate = Date()
//    @Published var showAlert = false
//    
//    init() {}
//    
//    func save(){
//        guard canSave else {
//                   showAlert = true
//                   return
//               }
//        guard let uId = Auth.auth().currentUser?.uid else{
//            return
//        }
//        
//        //Create Model
//        let newId = UUID().uuidString
//        let newItem = ToDoListItem(id: newId, title: title, dueDate: dueDate.timeIntervalSince1970, createdDate: Date().timeIntervalSince1970, isDone: false)
//        
//        //Save Model
//        let db = Firestore.firestore()
//        
//        db.collection("users")
//            .document(uId)
//            .collection("todos")
//            .document(newId)
//            .setData(newItem.asDictionary())
//        
//    }
//    
//    var canSave: Bool{
//        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else{
//            return false
//        }
//        guard dueDate >= Date().addingTimeInterval(-86400) else {
//            return false
//        }
//        return true
//    }
//}

import Foundation
import FirebaseAuth
import FirebaseFirestore

class NewItemViewViewModel: ObservableObject{
    @Published var title = ""
    @Published var caption = ""
    @Published var dueDate = Date()
    @Published var showAlert = false
    @Published var tint = "taskColor 1"
    
    
    init() {}
    
    func save(){
        guard canSave else {
                   showAlert = true
                   return
               }
        guard let uId = Auth.auth().currentUser?.uid else{
            return
        }
        
        //Create Model
        let newId = UUID().uuidString
        let newItem = ToDoListItem(id: newId, title: title, caption: caption, dueDate: dueDate.timeIntervalSince1970, createdDate: Date().timeIntervalSince1970, isDone: false, tint: tint)
        
        //Save Model
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(uId)
            .collection("todos")
            .document(newId)
            .setData(newItem.asDictionary())
        
      
        
    }
    
    var canSave: Bool{
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else{
            return false
        }
        guard dueDate >= Date().addingTimeInterval(-86400) else {
            return false
        }
        return true
    }
}


//
//import Foundation
//import FirebaseAuth
//import FirebaseFirestore
//
//class NewItemViewViewModel: ObservableObject {
//    @Published var title = ""
//    @Published var caption = ""
//    @Published var dueDate = Date()
//    @Published var showAlert = false
//    @Published var tint = "taskColor 1"
//    
//    var notificationViewModel: NotificationViewModel?
//    
//    init(notificationViewModel: NotificationViewModel? = nil) {
//        self.notificationViewModel = notificationViewModel
//    }
//    
//    func save() {
//        guard canSave else {
//            showAlert = true
//            return
//        }
//        guard let uId = Auth.auth().currentUser?.uid else {
//            return
//        }
//        
//        // Create Model
//        let newId = UUID().uuidString
//        let newItem = ToDoListItem(id: newId, title: title, caption: caption, dueDate: dueDate.timeIntervalSince1970, createdDate: Date().timeIntervalSince1970, isDone: false, tint: tint)
//        
//        // Save Model
//        let db = Firestore.firestore()
//        db.collection("users")
//            .document(uId)
//            .collection("todos")
//            .document(newId)
//            .setData(newItem.asDictionary()) { [weak self] error in
//                if let error = error {
//                    print("Error saving item: \(error.localizedDescription)")
//                } else {
//                    // Notify user about the new item
//                    let dueDateString = Formatter.fullDateFormatter.string(from: self?.dueDate ?? Date())
//                    self?.notificationViewModel?.addNotification(
//                        message: "\(self?.title ?? "A task") is added to your list due for \(dueDateString).",
//                        type: .added
//                    )
//                }
//            }
//    }
//    
//    var canSave: Bool {
//        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
//            return false
//        }
//        guard dueDate >= Date().addingTimeInterval(-86400) else {
//            return false
//        }
//        return true
//    }
//}
//

