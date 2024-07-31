//
//  NotificationView.swift
//  Gritodo
//
//  Created by Nabin Poudel on 7/20/24.
//


import SwiftUI

struct NotificationView: View {
    let userId: String
    @StateObject var viewModel: NotificationViewModel

    init(userId: String) {
        self.userId = userId
        _viewModel = StateObject(wrappedValue: NotificationViewModel(userId: userId))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            VStack(spacing: 0){
                Text("Notifications")
                    .font(.largeTitle)
                    .bold()
                    .padding()
            }
          
            GradientLine()
                .frame(height: 7)
            
            if viewModel.notifications.isEmpty {
                Spacer()
                
                    Text("No notifications")
                        .foregroundColor(.gray)
                        .padding(50)
                        .offset(x: 80)
                Spacer()
            } else {
                List {
                    ForEach(viewModel.notifications) { notification in
                        HStack(alignment: .top) {
                            Image(systemName: notification.type.iconName)
                                .resizable()
                                .frame(width: 24, height: 24)  // Adjusted icon size
                                .padding(8)
                                .background(notification.type.backgroundColor)
                                .cornerRadius(12)
                                .foregroundColor(.white)
                            

                
                            VStack(alignment: .leading) {
                                Text(notification.message)
                                    .font(.body)
                                    .padding(.bottom, 2)
                                
                                Text(Formatter.dateFormatter.string(from: Date(timeIntervalSince1970: notification.timestamp)))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    }
                    .onDelete(perform: viewModel.deleteNotification)
                }
                .listStyle(PlainListStyle())
            }
        }
        .onAppear {
            viewModel.fetchNotifications()
        }
    }
      struct GradientLine: View {
            @State private var startColor = Color.red
            @State private var endColor = Color.blue
    
            var body: some View {
                LinearGradient(gradient: Gradient(colors: [startColor, endColor]),
                               startPoint: .leading,
                               endPoint: .trailing)
                    .shadow(color: Color.white.opacity(0.6), radius: 10, x: 0, y: 0) // Glowing effect
            }
        }
}

extension NotificationType {
    var iconName: String {
        switch self {
        case .added:
            return "plus.circle.fill"
        case .deleted:
            return "trash.circle.fill"
        case .done:
            return "checkmark.circle.fill"
        case .reminder:
            return "bell.circle.fill"
        case .dueSoon:
            return "clock.fill"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .added:
            return .green
        case .deleted:
            return .red
        case .done:
            return .blue
        case .reminder:
            return .orange
        case .dueSoon:
            return .purple
        }
    }
}


//
//import SwiftUI
//
//struct NotificationView: View {
//    let userId: String
//    @StateObject private var viewModel: NotificationViewModel
//
//    init(userId: String) {
//        self.userId = userId
//        _viewModel = StateObject(wrappedValue: NotificationViewModel(userId: userId))
//    }
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            headerView
//                .background(Color.gray.opacity(0.2))
//                
//           
//            
//            content
//        }
//        .onAppear {
//            viewModel.fetchNotifications()
//        }
//        .navigationBarTitleDisplayMode(.inline)
//    }
//    
//    private var headerView: some View {
//        VStack(alignment: .leading) {
//            Text("Notifications")
//                .font(.largeTitle)
//                .fontWeight(.bold)
//                .padding()
//                .padding(.leading, 10) // Align text to the leading edge
//            
//            GradientLine()
//                .frame(height: 7)
//        }
//        .frame(maxWidth: .infinity, alignment: .leading) // Ensure header view spans full width and aligns content to leading edge
//    
//    }
//    
//    @ViewBuilder
//    private var content: some View {
//        VStack(spacing: 0){
//            
//            if viewModel.notifications.isEmpty {
//                Text("No notifications")
//                    .foregroundColor(.gray)
//                    .padding(50)
//            } else {
//                notificationsList
//            }}
//    }
//    
//    private var notificationsList: some View {
//        List {
//            ForEach(viewModel.notifications) { notification in
//                notificationRow(for: notification)
//            }
//            .onDelete(perform: viewModel.deleteNotification)
//        }
//        .listStyle(PlainListStyle())
//    }
//    
//    private func notificationRow(for notification: NotificationItem) -> some View {
//        HStack(alignment: .top) {
//            icon(for: notification.type)
//            
//            VStack(alignment: .leading) {
//                Text(notification.message)
//                    .font(.body)
//                    .padding(.bottom, 2)
//                
////                Text(Formatter.dateFormatter.string(from: Date(timeIntervalSince1970: notification.timestamp)))
////                    .font(.caption)
////                    .foregroundColor(.gray)
//            }
//            
//            Spacer()
//        }
//        .padding(.vertical, 8)
//    }
//    
//    private func icon(for type: NotificationType) -> some View {
//        Image(systemName: type.iconName)
//            .resizable()
//            .frame(width: 24, height: 24)
//            .padding(8)
//            .background(type.backgroundColor)
//            .cornerRadius(12)
//            .foregroundColor(.white)
//    }
//    
//    struct GradientLine: View {
//        @State private var startColor = Color.red
//        @State private var endColor = Color.blue
//
//        var body: some View {
//            LinearGradient(gradient: Gradient(colors: [startColor, endColor]),
//                           startPoint: .leading,
//                           endPoint: .trailing)
//                .shadow(color: Color.white.opacity(0.6), radius: 10, x: 0, y: 0)
//        }
//    }
//}
//
//
//extension NotificationType {
//    var iconName: String {
//        switch self {
//        case .added:
//            return "plus.circle.fill"
//        case .deleted:
//            return "trash.circle.fill"
//        case .done:
//            return "checkmark.circle.fill"
//        case .reminder:
//            return "bell.circle.fill"
//        case .dueSoon:
//            return "clock.fill"
//        }
//    }
//    
//    var backgroundColor: Color {
//        switch self {
//        case .added:
//            return .green
//        case .deleted:
//            return .red
//        case .done:
//            return .blue
//        case .reminder:
//            return .orange
//        case .dueSoon:
//            return .purple
//        }
//    }
//}
