//
//  TodolistView.swift
//  Gritodo
//
//  Created by Nabin Poudel on 7/15/24.
//


import SwiftUI
import FirebaseFirestoreSwift

struct TodolistView: View {
    @State private var notifiedItems = Set<String>()
    
    @StateObject var viewModel: TodolistViewViewModel
    @StateObject private var notificationViewModel: NotificationViewModel
    
    init(userId: String) {
        self._viewModel = StateObject(wrappedValue: TodolistViewViewModel(userId: userId))
        self._notificationViewModel = StateObject(wrappedValue: NotificationViewModel(userId: userId))
    }
    
    var body: some View {
        NavigationView {

                VStack (spacing: 0){
                    headerView
                        .background(Color.gray.opacity(0.15))
                    
                    GradientLine()
                        .frame(height: 7)
                       
                    
                    calendarView
                        .offset(y: 4)
                        .zIndex(1)
                    
                    todoListView
                        .offset(y: 9)
                }
            .background(Color.white) // Background for the rest of the view
            .navigationBarHidden(true)
        }
    }
    
    private var headerView: some View {
        VStack {
            HStack {
                Text("Task Manager")
                    .font(.largeTitle)
                    .bold()
                
                Spacer()
                
                NavigationLink(destination: NotificationView(userId: viewModel.userId)) {
                    NotificationIconWithBadge(count: notificationViewModel.notifications.count)
                        .font(.title)
                        .foregroundColor(.black)
                }
                .simultaneousGesture(TapGesture().onEnded {
                    notificationViewModel.resetNotifications()
                })
            }
            .padding()
            
            // Custom date label similar to TasksView
            Text("\(Formatter.dayAndDateFormatter.string(from: viewModel.selectedDate))")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .offset(y: -10)
        }
    }
    
    private var todoListView: some View {
        VStack(alignment: .leading, content: {
            List(viewModel.items) { item in
                TodolistItemView(item: item)
                    .background(alignment: .leading) {
                        if viewModel.items.last?.id != item.id {
                            Rectangle()
                                .frame(width: 1, height: 40) // Adjust height and width
                                .foregroundColor(Color.gray.opacity(0.5)) // Light color
                                .offset(x: 24, y: 20) // Adjust offset
                        }
                    }
                    .swipeActions {
                        Button("Delete") {
                            viewModel.delete(id: item.id)
                            notificationViewModel.addNotification(message: "\(item.title) was deleted from your list.", type: .deleted)
                        }
                        .tint(.red)
                        
                        Button("Mark Done") {
                            if let index = viewModel.items.firstIndex(where: { $0.id == item.id }) {
                                viewModel.items[index].setDone(true)
                                notificationViewModel.addNotification(message: "\(viewModel.items[index].title) is marked as done.", type: .done)
                            }
                        }
                        .tint(.blue)
                    }
            }
            .listStyle(PlainListStyle())
        })
        .padding(.top, 15)
        .overlay {
            if viewModel.items.isEmpty {
                Text("No Tasks Added")
                    .font(.caption)
                    .frame(width: 150)
            }
        }
    }
    
    private func generateDates() -> [Date] {
        let calendar = Calendar.current
        let today = Date()
        var dates = [Date]()
        
        for i in 0...20 {
            if let futureDate = calendar.date(byAdding: .day, value: i, to: today) {
                dates.append(futureDate)
            }
        }
        
        return dates
    }
  
    private var calendarView: some View {
        
        VStack(spacing: 12) {

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(generateDates(), id: \.self) { date in
                        CalendarDateView(
                            date: date,
                            isSelected: Calendar.current.isDate(date, inSameDayAs: viewModel.selectedDate),
                            isToday: Calendar.current.isDate(date, inSameDayAs: Date())
                        ) {
                            viewModel.selectedDate = date
                            checkForNotifications(for: date)
                        }
                    }
                }
                .padding(.horizontal, 12) // Adjusted padding for better fit
                .background(
                    ZStack {
                        // Adding a lighter gradient background for a softer appearance
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white, Color.black.opacity(0.05)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 0.5) // Black border for classic look
                        )
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 5)) // Rounded corners
            }
            .frame(height: 80) // Adjust height as needed
            .offset(y: 8)
        }
    }

    private func checkForNotifications(for date: Date) {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateStyle = .medium

        // Example: Notify about tasks due 24 hours from the given date
        for item in viewModel.items {
            let dueDate = Date(timeIntervalSince1970: item.dueDate)
            let dueDateString = formatter.string(from: dueDate)

            // Check if the given date is 24 hours before the due date
            if let notificationDate = calendar.date(byAdding: .day, value: -1, to: dueDate),
               calendar.isDate(notificationDate, inSameDayAs: date), !item.isDone {

                // Use item ID or title as a unique identifier
                let itemIdentifier = "\(item.id)" // or item.title if IDs are not available

                // Check if notification has already been sent for this item
                if !notifiedItems.contains(itemIdentifier) {
                    notificationViewModel.addNotification(
                        message: "\(item.title) is due on \(dueDateString).",
                        type: .dueSoon
                    )
                    notifiedItems.insert(itemIdentifier) // Mark as notified
                }
            }
        }
    }
}

struct NotificationIconWithBadge: View {
    let count: Int
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(systemName: "bell")
                .font(.title)
            
            if count > 0 {
                Text("\(count)")
                    .font(.caption2)
                    .padding(5)
                    .background(Color.red)
                    .clipShape(Circle())
                    .foregroundColor(.white)
                    .offset(x: 10, y: -10)
            }
        }
    }
}

struct CalendarDateView: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let action: () -> Void
    
    var body: some View {
        VStack {
            Text(Formatter.dayFormatter.string(from: date))
                .font(.caption)
                .foregroundColor(isSelected ? .red : Color.black.opacity(0.8))
                .offset(y: 5)
            
            VStack {
                Text(Formatter.dateFormatter.string(from: date))
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : .primary)
                
                if isToday {
                    Circle()
                        .fill(isSelected ? .green : Color.black)
                        .frame(width: 8, height: 8)
                        .offset(y: 7)
                }
            }
            .padding(8)
            .background(
                Color.black.opacity(0.8)
                .opacity(isSelected ? 1 : 0) // Full gradient for selected, transparent for unselected
            )
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.black : Color.black.opacity(0.1), lineWidth: 1)
            )
        }
        .shadow(color: Color.gray.opacity(0.2), radius: 4, x: 0, y: 2)
        .onTapGesture {
            action()
        }
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
            .onAppear {
                withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: true)) {
                    startColor = Color.purple
                    endColor = Color.orange
                }
            }
    }
}

struct Formatter {
    static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    static let fullDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    static let dayAndDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy, EEEE"
        return formatter
    }()
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
