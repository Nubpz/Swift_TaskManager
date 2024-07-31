


import SwiftUI

struct MainView: View {
    
    @State var selectedTab = 0
    @StateObject var viewModel = ContentViewViewModel()
    @State private var newItemPresented: Bool = false
    @State private var profileImage: UIImage? = UIImage(systemName: "person.fill")
    private let tabBarHeight: CGFloat = 50
    
    var body: some View {
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
            accountView
        } else {
            LoginView()
        }
    }
    
    @ViewBuilder
    private var accountView: some View {
        ZStack(alignment: .bottom) {
            // Display selected tab content
            switch selectedTab {
            case 0:
                HomeView(userId: viewModel.currentUserId)
            case 1:
                TodolistView(userId: viewModel.currentUserId)
            case 2:
                NewItemView(newItemPresented: $newItemPresented)
            case 3:
                NotificationView(userId: viewModel.currentUserId)
            case 4:
                ProfileView(profileImage: $profileImage)
            default:
                HomeView(userId: viewModel.currentUserId) // Default view
            }
            
            // Custom Tab Bar
            HStack {
                ForEach([0, 1, 2, 3, 4], id: \.self) { index in
                    Button {
                        if index == 2 {
                            newItemPresented = true
                        } else {
                            selectedTab = index
                        }
                    } label: {
                        CustomTabItem(systemName: tabImageName(forIndex: index), title: tabTitle(forIndex: index), isActive: (selectedTab == index))
                    }
                }
            }
            .padding(5)
            .background(Color.white)
            .cornerRadius(35)
            .overlay(
                RoundedRectangle(cornerRadius: 35)
                    .stroke(Color.black, lineWidth: 0.05)
                    .blendMode(.overlay)
            )
            .padding(.horizontal, 36)
            .padding(.bottom, 5)
            .shadow(color: .black.opacity(0.6), radius: 5, x: 0, y: -2)
            .frame(height: tabBarHeight)
        }
        .sheet(isPresented: $newItemPresented) {
            NewItemView(newItemPresented: $newItemPresented)
        }
    }
    
    private func tabImageName(forIndex index: Int) -> String {
        switch index {
        case 0:
            return "house.fill"
        case 1:
            return "doc.plaintext.fill"
        case 2:
            return "plus.circle"
        case 3:
            return "bell.fill"
        case 4:
            return "person.fill"
        default:
            return ""
        }
    }
    
    private func tabTitle(forIndex index: Int) -> String {
        switch index {
        case 0:
            return "Home"
        case 1:
            return "To-Do"
        case 2:
            return "Add"
        case 3:
            return "Notifications"
        case 4:
            return "Profile"
        default:
            return ""
        }
    }
}

extension MainView {
    private func CustomTabItem(systemName: String, title: String, isActive: Bool) -> some View {
        HStack(spacing: 10) {
            Spacer()
            if systemName == "plus.circle" {
                ZStack {
                    // Background
                    RefinedDiamondShape()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Color.black, Color.white.opacity(0.1)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 60, height: 60)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                    
                    // Icon
                    Image(systemName: systemName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                }
            } else {
                Image(systemName: systemName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(isActive ? .white : .black)
                    .frame(width: 20, height: 20)
            }
            Spacer()
        }
        .frame(width: 50, height: 50)
        .background(
            Group {
                if isActive && systemName != "plus.circle" {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.purple, Color.blue]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                } else {
                    Color.clear
                }
            }
        )
        .cornerRadius(25)
    }
}

struct RefinedDiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        
        let topLeft = CGPoint(x: width * 0.5, y: 0)
        let topRight = CGPoint(x: width, y: height * 0.5)
        let bottomRight = CGPoint(x: width * 0.5, y: height)
        let bottomLeft = CGPoint(x: 0, y: height * 0.5)
        
        path.move(to: topLeft)
        path.addLine(to: topRight)
        path.addLine(to: bottomRight)
        path.addLine(to: bottomLeft)
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    MainView()
}
