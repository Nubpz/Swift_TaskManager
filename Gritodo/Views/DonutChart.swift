

import SwiftUI

struct DonutChart: View {
    let totalTasks: Int
    let remainingTasks: Int
    let completedTasks: Int
    let tasksDueToday: Int
    let tasksComingSoon: Int
    
    @State private var rotationAmount: Double = 0
    @State private var currentTextIndex: Int = 0
    @State private var selectedSegment: Int? = nil // Track selected segment
    @State private var isPoppedUp: Bool = false // Track pop-up effect
    
    private var chartData: [(color: Color, value: Double, label: String, count: Int)] {
        [
            (color: .red, value: Double(tasksDueToday), label: "Due Today", count: tasksDueToday),
            (color: .yellow, value: Double(tasksComingSoon), label: "Due Tomorrow", count: tasksComingSoon),
            (color: .green, value: Double(completedTasks), label: "Completed", count: completedTasks),
            (color: .blue, value: Double(remainingTasks), label: "Remaining", count: remainingTasks)
        ]
    }
    
    var body: some View {
        HStack {
            ZStack {
                // Rotating donut chart with bubbly 3D effect
                ZStack {
                    ForEach(chartData.indices) { index in
                        let data = chartData[index]
                        DonutSegment(startAngle: angle(for: index), endAngle: angle(for: index + 1))
                            .fill(LinearGradient(gradient: Gradient(colors: [data.color.opacity(0.9), data.color]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .overlay(
                                DonutSegment(startAngle: angle(for: index), endAngle: angle(for: index + 1))
                                    .stroke(Color.white.opacity(0.9), lineWidth: 3)
                            )
                            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 5, y: 5) // Adjust shadow for depth
                            .overlay(
                                DonutSegment(startAngle: angle(for: index), endAngle: angle(for: index + 1))
                                    .stroke(LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.7), Color.clear]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 4) // Add highlight border
                            )
                            .overlay(
                                // Inner glow to enhance the bubbly effect
                                DonutSegment(startAngle: angle(for: index), endAngle: angle(for: index + 1))
                                    .stroke(RadialGradient(gradient: Gradient(colors: [Color.white.opacity(0.5), Color.clear]), center: .center, startRadius: 0, endRadius: 50), lineWidth: 10)
                            )
                            .scaleEffect(isPoppedUp && selectedSegment == index ? 1.1 : 1.0) // Add pop-up effect
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPoppedUp) // Spring animation for pop-up
                            .onTapGesture {
                                // Set selected segment and pop up effect
                                selectedSegment = index
                                isPoppedUp.toggle()
                            }
                    }
                }
                .rotationEffect(.degrees(rotationAmount))
                .animation(.linear(duration: 120).repeatForever(autoreverses: false), value: rotationAmount) // Keep rotation animation
                
                // Center circle to make it look like a donut
                Circle()
                    .fill(Color.white)
                    .frame(width: 60, height: 60)
                
                // Display dynamic text in the center with animation
                VStack {
                    Text(centerText)
                        .font(.footnote) // Smaller font size
                        .bold()
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center) // Center align the text
                        .lineLimit(2) // Limit to 2 lines
                        .frame(width: 80, height: 40) // Adjust frame to fit the text
                        .animation(.easeInOut(duration: 1), value: centerText) // Animation for text change
                }
                .frame(width: 120, height: 120) // Adjust frame to fit the text
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3) // Add shadow to center text for better readability
            }
            .frame(width: 185, height: 185)
            .offset(x: -8, y: 0)
            .padding()
            .onAppear {
                self.rotationAmount = 360
                // Timer to update text every 10 seconds
                Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
                    self.currentTextIndex = (self.currentTextIndex + 1) % chartData.count
                }
            }
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    ForEach(chartData.indices, id: \.self) { index in
                        let data = chartData[index]
                        HStack {
                            Circle()
                                .fill(data.color)
                                .frame(width: 8, height: 8) // Smaller color circles
                            Text("\(data.label): \(data.count)")
                                .font(.caption2) // Very small font
                                .bold()
                                .padding(.leading, 4)
                        }
                        .padding(.bottom, 2) // Reduced vertical padding
                        .opacity(selectedSegment == index ? 1 : 0.5) // Highlight selected segment
                    }
                }
                .padding(6)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 2)
                .frame(width: 150, alignment: .leading) // Smaller box for the legend
                .padding(.trailing, 10) // Align box to the right
                .offset(x: 10, y: 40)
            }
        }
    }
    
    private func angle(for index: Int) -> Angle {
        let totalValue = chartData.reduce(0) { $0 + $1.value }
        let previousValue = chartData.prefix(index).reduce(0) { $0 + $1.value }
        let startAngle = Angle(degrees: 360 * (previousValue / totalValue))
        return startAngle
    }
    
    private var centerTexts: [String] {
        [
            "\(tasksDueToday) Tasks Due Today",
            "\(tasksComingSoon) Due Tomorrow",
            "\(remainingTasks) Tasks To Do",
            "\(completedTasks) Completed"
        ]
    }
    
    private var centerText: String {
        centerTexts[currentTextIndex]
    }
}

struct DonutSegment: Shape {
    let startAngle: Angle
    let endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius: CGFloat = min(rect.width, rect.height) / 2
        let innerRadius: CGFloat = radius * 0.6
        
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.addArc(center: center, radius: innerRadius, startAngle: endAngle, endAngle: startAngle, clockwise: true)
        path.closeSubpath()
        
        return path
    }
}
