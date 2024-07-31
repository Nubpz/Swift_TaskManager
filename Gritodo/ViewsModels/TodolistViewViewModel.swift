////
////  TodolistViewViewModel.swift
////  Gritodo
////
////  Created by Nabin Poudel on 7/15/24.
////


//
//import Foundation
//import FirebaseFirestore
//import FirebaseFirestoreSwift
//


import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class TodolistViewViewModel: ObservableObject {
    @Published var showNewItemView = false
    @Published var selectedDate: Date = Date() {
        didSet {
            fetchItemsForDate()
        }
    }
    
    let userId: String
    @Published var items: [ToDoListItem] = []
    @Published var overdueItems: [ToDoListItem] = []
    @Published var historyItems: [ToDoListItem] = []
    private var db = Firestore.firestore()
    
    init(userId: String) {
        self.userId = userId
        fetchItemsForDate()
        deleteOldItems() // Call this at initialization to clean up old items
    }
    
    func delete(id: String) {
        db.collection("users")
            .document(userId)
            .collection("todos")
            .document(id)
            .delete()
    }
    
    private func fetchItemsForDate() {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: selectedDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let startOfDayInterval = startOfDay.timeIntervalSince1970
        let endOfDayInterval = endOfDay.timeIntervalSince1970
        
        db.collection("users")
            .document(userId)
            .collection("todos")
            .whereField("dueDate", isGreaterThanOrEqualTo: startOfDayInterval)
            .whereField("dueDate", isLessThan: endOfDayInterval)
            .addSnapshotListener { [self] snapshot, error in
                if let error = error {
                    print("Error fetching items: \(error.localizedDescription)")
                    return
                }
                
                let sortedItems = snapshot?.documents.compactMap { doc in
                    try? doc.data(as: ToDoListItem.self)
                }.sorted(by: { $0.dueDate < $1.dueDate }) ?? []
                
                self.items = sortedItems
            }
        
        fetchOverdueItems()
    }
    
    private func fetchOverdueItems() {
        let calendar = Calendar.current
        let fiveDaysAgo = calendar.date(byAdding: .day, value: -5, to: Date())!
        let fiveDaysAgoInterval = fiveDaysAgo.timeIntervalSince1970
        let now = Date().timeIntervalSince1970
        
        db.collection("users")
            .document(userId)
            .collection("todos")
            .whereField("dueDate", isGreaterThanOrEqualTo: fiveDaysAgoInterval)
            .whereField("dueDate", isLessThan: now)
            .getDocuments { [self] snapshot, error in
                if let error = error {
                    print("Error fetching overdue items: \(error.localizedDescription)")
                    return
                }
                
                self.overdueItems = snapshot?.documents.compactMap { doc in
                    try? doc.data(as: ToDoListItem.self)
                }.sorted(by: { $0.dueDate < $1.dueDate }) ?? []
            }
    }
    
    private func deleteOldItems() {
        let calendar = Calendar.current
        let fiveDaysAgo = calendar.date(byAdding: .day, value: -5, to: Date())!
        let fiveDaysAgoInterval = fiveDaysAgo.timeIntervalSince1970
        
        db.collection("users")
            .document(userId)
            .collection("todos")
            .whereField("dueDate", isLessThan: fiveDaysAgoInterval)
            .getDocuments { [self] snapshot, error in
                if let error = error {
                    print("Error fetching old items: \(error.localizedDescription)")
                    return
                }
                
                for document in snapshot?.documents ?? [] {
                    document.reference.delete()
                }
            }
    }
}
