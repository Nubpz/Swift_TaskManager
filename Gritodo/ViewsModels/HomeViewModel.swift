
//
//  NotificationViewModel.swift
//  Gritodo
//
//  Created by Nabin Poudel on 7/20/24.
//
//

import Foundation
import SwiftUI
import FirebaseFirestore

class HomeViewModel: ObservableObject {
    @Published var tasksForToday: [ToDoListItem] = []
    @Published var tasksComingSoon: [ToDoListItem] = []
    @Published var completedTasks: [ToDoListItem] = []
    @Published var remainingTasks: [ToDoListItem] = [] // New property for remaining tasks
    
    @Published var totalTasks: Int = 0
    @Published var remainingTasksCount: Int = 0 // New property for remaining tasks count
    @Published var completedTasksCount: Int = 0
    @Published var tasksDueToday: Int = 0
    @Published var tasksComingSoonCount: Int = 0
    
    let userId: String
    private var db = Firestore.firestore()
    
    init(userId: String) {
        self.userId = userId
        fetchTasks()
    }
    
    private func fetchTasks() {
        let today = Date()
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: today)
//        let endOfToday = calendar.date(byAdding: .day, value: 1, to: startOfToday)!
        
        let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfToday)!
        let endOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfTomorrow)!
        
        db.collection("users")
            .document(userId)
            .collection("todos")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching tasks: \(error.localizedDescription)")
                    return
                }
                
                let allTasks = snapshot?.documents.compactMap { doc in
                    try? doc.data(as: ToDoListItem.self)
                } ?? []
                
                self.tasksForToday = allTasks.filter {
                    let dueDate = Date(timeIntervalSince1970: $0.dueDate)
                    return Calendar.current.isDate(dueDate, inSameDayAs: today) && !$0.isDone
                }
                
                self.tasksComingSoon = allTasks.filter {
                    let dueDate = Date(timeIntervalSince1970: $0.dueDate)
                    return dueDate >= startOfTomorrow && dueDate < endOfTomorrow && !$0.isDone
                }
                
                self.completedTasks = allTasks.filter { $0.isDone }
                self.remainingTasks = allTasks.filter { !$0.isDone } // Update remaining tasks
                
                self.totalTasks = allTasks.count
                self.remainingTasksCount = allTasks.filter { !$0.isDone }.count // Update remaining tasks count
                self.completedTasksCount = allTasks.filter { $0.isDone }.count
                self.tasksDueToday = allTasks.filter {
                    let dueDate = Date(timeIntervalSince1970: $0.dueDate)
                    return Calendar.current.isDate(dueDate, inSameDayAs: today)
                }.count
                self.tasksComingSoonCount = allTasks.filter {
                    let dueDate = Date(timeIntervalSince1970: $0.dueDate)
                    return dueDate >= startOfTomorrow && dueDate < endOfTomorrow
                }.count
            }
    }
}
