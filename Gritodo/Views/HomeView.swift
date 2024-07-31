//
//
//
//import SwiftUI
//
//struct HomeView: View {
//    @StateObject private var viewModel: HomeViewModel
//    @State private var expandedSections: Set<String> = [] // Start with no sections expanded
//    @State private var profileImage: UIImage? = nil // State for profile image
//
//    init(userId: String) {
//        self._viewModel = StateObject(wrappedValue: HomeViewModel(userId: userId))
//    }
//
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 0) {
//                headerView
//                    .padding(.horizontal)
//                    .padding(.top, 20)
//                    .background(Color.gray.opacity(0.2))
//
//                ScrollViewReader { proxy in
//                    ScrollView {
//                        VStack(spacing: 8) {
//                            donutChartView
//                                .padding(.top, 10)
//                                .padding(.horizontal, 10)
//                            VStack{
//                                Text("Task Overview")
//                                    .font(.title2)
//                                    .fontWeight(.bold)
//                                    .foregroundColor(.primary)
//                                    .padding(.horizontal, 10)
//                                    .padding(.top, 16)
//                                
//                                sectionsView
//                                    .padding(.horizontal, 10)
//                            }
//                            .offset(y: -5)
//                        }
//                        
//                        .padding(.bottom, 20)
//                        .background(Color.white)
//                    }
//                    .onAppear {
//                        proxy.scrollTo(0, anchor: .top)
//                    }
//                }
//            }
//            .navigationBarHidden(true)
//        }
//    }
//
//    private var headerView: some View {
//        HStack {
//            VStack(alignment: .leading, spacing: 4) {
//                Text("Home")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .foregroundColor(.primary)
//                Text("\(Formatter.dayAndDateFormatter.string(from: Date()))")
//                    .font(.headline)
//                    .padding(.top, 4)
//                    .offset(y: -10)
//            }
//            Spacer()
//            NavigationLink(destination: ProfileView(profileImage: $profileImage)) {
//                if let profileImage = profileImage {
//                    Image(uiImage: profileImage)
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 30, height: 30)
//                        .clipShape(Circle())
//                        .shadow(radius: 4)
//                } else {
//                    Image(systemName: "person.fill")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 30, height: 30)
//                        .foregroundColor(.blue)
//                        .padding(8)
//                        .background(Color.white)
//                        .clipShape(Circle())
//                        .shadow(radius: 4)
//                }
//            }
//        }
//    }
//
//    private var donutChartView: some View {
//        DonutChart(
//            totalTasks: viewModel.totalTasks,
//            remainingTasks: viewModel.remainingTasksCount,
//            completedTasks: viewModel.completedTasksCount,
//            tasksDueToday: viewModel.tasksDueToday,
//            tasksComingSoon: viewModel.tasksComingSoonCount
//        )
//    }
//
//    private var sectionsView: some View {
//        VStack(spacing: 8) {
//            sectionCard(title: "Tasks for Today", items: viewModel.tasksForToday, icon: "calendar.circle", gradientColors: [Color.red.opacity(0.3), Color.red.opacity(0.4)], sectionID: "today")
//            sectionCard(title: "Tasks Due Tomorrow", items: viewModel.tasksComingSoon, icon: "clock.badge", gradientColors: [Color.yellow.opacity(0.3), Color.yellow.opacity(0.4)], sectionID: "tomorrow")
//            sectionCard(title: "Remaining Tasks", items: viewModel.remainingTasks, icon: "list.bullet", gradientColors: [Color.blue.opacity(0.3), Color.blue.opacity(0.4)], sectionID: "remaining")
//            sectionCard(title: "Completed Tasks", items: viewModel.completedTasks, icon: "checkmark.circle", gradientColors: [Color.green.opacity(0.3), Color.green.opacity(0.4)], sectionID: "completed")
//        }
//    }
//
//    private func sectionCard(title: String, items: [ToDoListItem], icon: String, gradientColors: [Color], sectionID: String) -> some View {
//        VStack(alignment: .leading, spacing: 8) {
//            HStack {
//                Image(systemName: icon)
//                    .font(.title2)
//                    .foregroundColor(.blue)
//                Text(title)
//                    .font(.caption)
//                    .fontWeight(.bold)
//                    .foregroundColor(.black)
//                    .padding(.leading, 8)
//                Spacer()
//                Button(action: {
//                    if expandedSections.contains(sectionID) {
//                        expandedSections.remove(sectionID)
//                    } else {
//                        expandedSections.insert(sectionID)
//                    }
//                }) {
//                    Image(systemName: expandedSections.contains(sectionID) ? "chevron.up" : "chevron.down")
//                        .foregroundColor(.blue)
//                        .padding()
//                }
//            }
//
//            if expandedSections.contains(sectionID) {
//                if items.isEmpty {
//                    Text("No Tasks")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                        .padding()
//                } else {
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack(spacing: 12) {
//                            ForEach(items) { item in
//                                VStack(alignment: .leading, spacing: 8) {
//                                    Text(item.title)
//                                        .font(.headline)
//                                        .lineLimit(1)
//                                        .foregroundColor(.primary)
//                                    Text("Due: \(Formatter.dayAndDateFormatter.string(from: Date(timeIntervalSince1970: item.dueDate)))")
//                                        .font(.subheadline)
//                                        .foregroundColor(.secondary)
//
//                                    if item.isDone {
//                                        Label("Completed", systemImage: "checkmark.circle.fill")
//                                            .foregroundColor(.green)
//                                    } else {
//                                        Label("Pending", systemImage: "circle")
//                                            .foregroundColor(.gray)
//                                    }
//                                }
//                                .padding()
//                                .background(Color.white)
//                                .cornerRadius(12)
//                                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
//                                .frame(width: 270)
//                                .scaleEffect(1.02)
//                                .animation(.easeInOut(duration: 0.2))
//                            }
//                        }
//                        .padding(.horizontal)
//                    }
//                }
//            }
//        }
//        .padding()
//        .background(
//            LinearGradient(
//                gradient: Gradient(colors: gradientColors),
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//        )
//        .cornerRadius(16)
//        .padding(.bottom, 4)
//    }
//}




import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    @State private var expandedSections: Set<String> = [] // Start with no sections expanded
    @State private var profileImage: UIImage? = nil // State for profile image

    init(userId: String) {
        self._viewModel = StateObject(wrappedValue: HomeViewModel(userId: userId))
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                headerView
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .background(Color.gray.opacity(0.2))
                
                GradientLine()
                    .frame(height: 7)
              

                GeometryReader { geometry in
                    ScrollView {
                        VStack(spacing: 8) {
                            donutChartView
                                .padding(.top, 10)
                                .padding(.horizontal, 10)
                            VStack {
                                Text("Task Overview")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                    .padding(.horizontal, 10)
                                    .padding(.top, 16)
                                
                                sectionsView
                                    .padding(.horizontal, 10)
                            }
                            .offset(y: -5)
                        }
                        .padding(.bottom, max(geometry.safeAreaInsets.bottom, 70)) // Adjust to ensure the content doesn't hide behind the tab bar
                        .background(Color.white)
                    }
                    .onAppear {
                        // No need to adjust scroll position on appear
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }

    private var headerView: some View {
       
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Home")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.bottom)
                    
                    Text("\(Formatter.dayAndDateFormatter.string(from: Date()))")
                        .font(.headline)
                        .padding(.top, 4)
                        .offset(y: -10)
                }
                Spacer()
                NavigationLink(destination: ProfileView(profileImage: $profileImage)) {
                    if let profileImage = profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    } else {
                        Image(systemName: "person.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                            .padding(8)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                }
            }
           
        }

    private var donutChartView: some View {
        DonutChart(
            totalTasks: viewModel.totalTasks,
            remainingTasks: viewModel.remainingTasksCount,
            completedTasks: viewModel.completedTasksCount,
            tasksDueToday: viewModel.tasksDueToday,
            tasksComingSoon: viewModel.tasksComingSoonCount
        )
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

    private var sectionsView: some View {
        VStack(spacing: 8) {
            sectionCard(title: "Tasks for Today", items: viewModel.tasksForToday, icon: "calendar.circle", gradientColors: [Color.red.opacity(0.3), Color.red.opacity(0.4)], sectionID: "today")
            sectionCard(title: "Tasks Due Tomorrow", items: viewModel.tasksComingSoon, icon: "clock.badge", gradientColors: [Color.yellow.opacity(0.3), Color.yellow.opacity(0.4)], sectionID: "tomorrow")
            sectionCard(title: "Remaining Tasks", items: viewModel.remainingTasks, icon: "list.bullet", gradientColors: [Color.blue.opacity(0.3), Color.blue.opacity(0.4)], sectionID: "remaining")
            sectionCard(title: "Completed Tasks", items: viewModel.completedTasks, icon: "checkmark.circle", gradientColors: [Color.green.opacity(0.3), Color.green.opacity(0.4)], sectionID: "completed")
        }
    }

    private func sectionCard(title: String, items: [ToDoListItem], icon: String, gradientColors: [Color], sectionID: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.leading, 8)
                Spacer()
                Button(action: {
                    if expandedSections.contains(sectionID) {
                        expandedSections.remove(sectionID)
                    } else {
                        expandedSections.insert(sectionID)
                    }
                }) {
                    Image(systemName: expandedSections.contains(sectionID) ? "chevron.up" : "chevron.down")
                        .foregroundColor(.blue)
                        .padding()
                }
            }

            if expandedSections.contains(sectionID) {
                if items.isEmpty {
                    Text("No Tasks")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(items) { item in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(item.title)
                                        .font(.headline)
                                        .lineLimit(1)
                                        .foregroundColor(.primary)
                                    Text("Due: \(Formatter.dayAndDateFormatter.string(from: Date(timeIntervalSince1970: item.dueDate)))")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)

                                    if item.isDone {
                                        Label("Completed", systemImage: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                    } else {
                                        Label("Pending", systemImage: "circle")
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
                                .frame(width: 270)
                                .scaleEffect(1.02)
                                .animation(.easeInOut(duration: 0.2))
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: gradientColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .padding(.bottom, 4)
    }
}
