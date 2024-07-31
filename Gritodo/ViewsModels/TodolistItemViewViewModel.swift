//
//  TodolistItemViewViewModel.swift
//  Gritodo
//
//  Created by Nabin Poudel on 7/15/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class TodolistItemViewViewModel: ObservableObject{
   
    init() {}
    
    func toggleIsDone(item: ToDoListItem){
        var itemCopy = item
        itemCopy.setDone(!item.isDone)
        
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(uid)
            .collection("todos")
            .document(itemCopy.id)
            .setData(itemCopy.asDictionary())
    }
}
