//
//  ToDoListItem.swift
//  Gritodo
//
//  Created by Nabin Poudel on 7/13/24.
//

import Foundation

struct ToDoListItem: Codable, Identifiable {
    let id: String
    let title: String
    let caption: String
    let dueDate: TimeInterval
    let createdDate: TimeInterval
    var isDone: Bool
    
    var tint: String
    
    
    
    mutating func setDone(_ state: Bool){
        isDone = state
    }
    
    func asDictionary() -> [String: Any] {
         return [
             "id": id,
             "title": title,
             "caption": caption,
             "dueDate": dueDate,
             "createdDate": createdDate,
             "isDone": isDone,
             "tint": tint
            
         ]
     }
}


