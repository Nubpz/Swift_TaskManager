//
//  NotificationViewModel.swift
//  Gritodo
//
//  Created by Nabin Poudel on 7/20/24.
//
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class NotificationViewModel: ObservableObject {
    @Published var notifications: [NotificationItem] = []
    let userId: String
    private var db = Firestore.firestore()

    init(userId: String) {
        self.userId = userId
        fetchNotifications()
    }
    
    func fetchNotifications() {
        db.collection("users")
            .document(userId)
            .collection("notifications")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching notifications: \(error.localizedDescription)")
                    return
                }
                
                self.notifications = snapshot?.documents.compactMap { doc in
                    try? doc.data(as: NotificationItem.self)
                } ?? []
            }
    }
    
    func addNotification(message: String, type: NotificationType) {
        let newNotification = NotificationItem(id: UUID().uuidString, message: message, type: type, timestamp: Date().timeIntervalSince1970)
        do {
            let _ = try db.collection("users")
                .document(userId)
                .collection("notifications")
                .document(newNotification.id)
                .setData(from: newNotification)
        } catch let error {
            print("Error adding notification: \(error.localizedDescription)")
        }
    }
    
    func deleteNotification(at offsets: IndexSet) {
        offsets.forEach { index in
            let notification = notifications[index]
            db.collection("users")
                .document(userId)
                .collection("notifications")
                .document(notification.id)
                .delete { error in
                    if let error = error {
                        print("Error deleting notification: \(error.localizedDescription)")
                    }
                }
        }
        notifications.remove(atOffsets: offsets)
    }
    
    
    func resetNotifications() {
        notifications.removeAll()
    }
}

enum NotificationType: String, Codable {
    case added
    case deleted
    case done
    case reminder
    case dueSoon
}

struct NotificationItem: Identifiable, Codable {
    let id: String
    let message: String
    let type: NotificationType
    let timestamp: TimeInterval
}
