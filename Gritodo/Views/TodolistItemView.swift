//
//  TodolistItemView.swift
//  Gritodo
//
//  Created by Nabin Poudel on 7/15/24.
//
//
//import SwiftUI
//
//struct TodolistItemView: View {
//    @StateObject var viewModel = TodolistItemViewViewModel()
//    let item: ToDoListItem
//    @State private var showCheckmark: Bool = false // State to manage checkmark animation
//
//    var body: some View {
//        HStack(alignment: .top, spacing: 15) { // Align to top to ensure the layout is consistent
//            ZStack {
//                if item.isDone {
//                    Image(systemName: showCheckmark ? "checkmark.circle.fill" : "circle")
//                        .foregroundColor(.green)
//                        .frame(width: 24, height: 24)
//                        .onAppear {
//                            withAnimation(.easeIn(duration: 0.3)) {
//                                showCheckmark = true
//                            }
//                        }
//                } else {
//                    Circle()
//                        .fill(Color(item.tint).opacity(0.8))
//                        .frame(width: 24, height: 24)
//                        .background(.white.shadow(.drop(color: .black.opacity(0.5), radius: 3)), in: .circle)
//                }
//            }
//            .onTapGesture {
//                handleItemTap()
//            }
//            
//            VStack(alignment: .leading, spacing: 8) {
//                GeometryReader { geometry in
//                    VStack(alignment: .leading, spacing: 8) {
//                        HStack {
//                            Text(item.title)
//                                .font(.system(size: 20, weight: .semibold))
//                            
//                            Spacer()
//                            
//                            HStack(spacing: 4) {
//                                Image(systemName: "clock")
//                                    .font(.system(size: 10)) // Smaller clock image
//                                
//                                if let dueDate = Date(timeIntervalSince1970: item.dueDate) as Date? {
//                                    Text(dueDate.formatted(.dateTime.month(.abbreviated).day().hour().minute()))
//                                        .font(.callout)
//                                        .minimumScaleFactor(0.4)
//                                }
//                            }
//                            .frame(width: geometry.size.width / 3, alignment: .trailing)
//                        }
//                        .frame(height: 24)
//                        
//                        Text(item.caption)
//                            .font(.callout)
//                            .fixedSize(horizontal: false, vertical: true) // Ensure multiline text
//                            .lineLimit(nil) // Allow unlimited lines
//                        
//                        Spacer() // Pushes the time remaining text to the bottom
//                    }
//                }
//                .frame(maxWidth: .infinity) // Ensure it expands to fit the content
//                
//                if let dueDate = Date(timeIntervalSince1970: item.dueDate) as Date? {
//                    let timeRemaining = calculateTimeRemaining(dueDate: dueDate)
//                    
//                    Text(timeRemaining)
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                        .clipShape(RoundedRectangle(cornerRadius: 5))
//                        .padding(5)
//                        .frame(maxWidth: .infinity, alignment: .trailing) // Align to bottom right
//                        .padding(.top, 20) // Add padding at the top
//                        .offset(y: 10)
//                        .offset(x: 8)
//                }
//            }
//            .padding()
//            .background(
//                Color(item.tint).opacity(0.3)
//            )
//            .clipShape(RoundedRectangle(cornerRadius: 20))
//            .overlay(
//                RoundedRectangle(cornerRadius: 20)
//                    .stroke(Color.gray.opacity(0.3), lineWidth: 1) // Added border
//            )
//            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3) // Added shadow for depth
//        }
//        .padding(.horizontal)
//    }
//    
//    // Function to handle item tap
//    private func handleItemTap() {
//        withAnimation(.snappy) {
//            viewModel.toggleIsDone(item: item)
//            showCheckmark = false // Reset the checkmark animation
//        }
//    }
//    
//    // Function to calculate time remaining or elapsed
//    func calculateTimeRemaining(dueDate: Date) -> String {
//        let now = Date()
//        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: now, to: dueDate)
//        
//        if components.day ?? 0 > 0 {
//            return "\(components.day!) days left"
//        } else if components.hour ?? 0 > 0 {
//            return "\(components.hour!) hours left"
//        } else if components.minute ?? 0 > 0 {
//            return "\(components.minute!) minutes left"
//        } else {
//            // Handle overdue cases
//            let pastComponents = Calendar.current.dateComponents([.day, .hour, .minute], from: dueDate, to: now)
//            
//            if pastComponents.day ?? 0 > 0 {
//                return "\(pastComponents.day!) days ago"
//            } else if pastComponents.hour ?? 0 > 0 {
//                return "\(pastComponents.hour!) hours ago"
//            } else if pastComponents.minute ?? 0 > 0 {
//                return "\(pastComponents.minute!) minutes ago"
//            } else {
//                return "Due now"
//            }
//        }
//    }
//}
//
//#Preview {
//    TodolistItemView(item: .init(id: "123", title: "Hello", caption: "Hurray Hurray Hurray Hurray Hurray Hurray Hurray Hurray Hurray Hurray Hurray Hurray Hurray Hurray Hurray Hurray Hurray Hurray Hurray Hurray", dueDate: Date().timeIntervalSince1970 - 3600, createdDate: Date().timeIntervalSince1970, isDone: false, tint: "black"))
//}
//



import SwiftUI

struct TodolistItemView: View {
    @StateObject var viewModel = TodolistItemViewViewModel()
    let item: ToDoListItem
    @State private var showCheckmark: Bool = false // State to manage checkmark animation

    var body: some View {
        HStack(alignment: .top, spacing: 15) { // Align to top to ensure the layout is consistent
            ZStack {
                if item.isDone {
                    Image(systemName: showCheckmark ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(.green)
                        .frame(width: 24, height: 24)
                        .onAppear {
                            withAnimation(.easeIn(duration: 0.3)) {
                                showCheckmark = true
                            }
                        }
                } else {
                    Circle()
                        .fill(Color(item.tint).opacity(0.8))
                        .frame(width: 24, height: 24)
                        .background(.white.shadow(.drop(color: .black.opacity(0.5), radius: 3)), in: .circle)
                }
            }
            .onTapGesture {
                handleItemTap()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(item.title)
                        .font(.system(size: 20, weight: .semibold))
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 10)) // Smaller clock image
                        
                        if let dueDate = Date(timeIntervalSince1970: item.dueDate) as Date? {
                            Text(dueDate.formatted(.dateTime.month(.abbreviated).day().hour().minute()))
                                .font(.callout)
                                .minimumScaleFactor(0.4)
                        }
                    }
                }
                
                Text(item.caption)
                    .font(.callout)
                    .fixedSize(horizontal: false, vertical: true) // Ensure multiline text
                    .lineLimit(nil) // Allow unlimited lines
                
                if let dueDate = Date(timeIntervalSince1970: item.dueDate) as Date? {
                    let timeRemaining = calculateTimeRemaining(dueDate: dueDate)
                    
                    Text(timeRemaining)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .frame(maxWidth: .infinity, alignment: .trailing) // Align to bottom right

                }
            }
            .padding()
            .background(
                Color(item.tint).opacity(0.3)
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1) // Added border
            )
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3) // Added shadow for depth
        }
        .padding(.horizontal)
    }
    
    // Function to handle item tap
    private func handleItemTap() {
        withAnimation(.snappy) {
            viewModel.toggleIsDone(item: item)
            showCheckmark = false // Reset the checkmark animation
        }
    }
    
    // Function to calculate time remaining or elapsed
    func calculateTimeRemaining(dueDate: Date) -> String {
        let now = Date()
        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: now, to: dueDate)
        
        if components.day ?? 0 > 0 {
            return "\(components.day!) days left"
        } else if components.hour ?? 0 > 0 {
            return "\(components.hour!) hours left"
        } else if components.minute ?? 0 > 0 {
            return "\(components.minute!) minutes left"
        } else {
            // Handle overdue cases
            let pastComponents = Calendar.current.dateComponents([.day, .hour, .minute], from: dueDate, to: now)
            
            if pastComponents.day ?? 0 > 0 {
                return "\(pastComponents.day!) days ago"
            } else if pastComponents.hour ?? 0 > 0 {
                return "\(pastComponents.hour!) hours ago"
            } else if pastComponents.minute ?? 0 > 0 {
                return "\(pastComponents.minute!) minutes ago"
            } else {
                return "Due now"
            }
        }
    }
}

#Preview {
    TodolistItemView(item: .init(id: "123", title: "Hello", caption: "Hurray Hurray Hurray Hurray Hurray Hurray Hurray Hurray Hurray Hurray Hurray Hurray Hurray Hurray Hurray Hurray Hurray Hurray Hurray Hurray", dueDate: Date().timeIntervalSince1970 - 3600, createdDate: Date().timeIntervalSince1970, isDone: false, tint: "black"))
}
