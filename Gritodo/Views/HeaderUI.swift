//
//  HeaderUI.swift
//  Gritodo
//
//  Created by Nabin Poudel on 7/13/24.
//

import SwiftUI

struct HeaderUI: View {
    @State private var animate = false 
    var body: some View {
        ZStack {
            ChangingShapeView(animate: animate)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color.red, Color.yellow]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .shadow(radius: 20)
                .scaleEffect(animate ? 1.05 : 1.3)
                .animation(Animation.easeInOut(duration: 10).repeatForever(autoreverses: true))
                .offset(y: 20)

            Circle()
                .fill(Color.white.opacity(0.3))
                .frame(width: 150, height: 150)
                .offset(x: -100, y: -100)
                .blur(radius: 20)

            Circle()
                .fill(Color.white.opacity(0.5))
                .frame(width: 100, height: 100)
                .offset(x: 80, y: 100)
                .blur(radius: 20)

            VStack {
                HStack(spacing: 0) {
                    // Yellow filled text with black stroke
                    Text("GriT")
                        .foregroundColor(Color.yellow)
                        .font(.system(size: 70))
                        .bold()
                        .background(
                            Text("GriT")
                                .foregroundColor(Color.black)
                                .font(.system(size: 70))
                                .bold()
                                .offset(x: 2, y: 0) // Offset to create a stroke effect
                        )
                        .offset(y: -18) // Adjust vertical position

                    // All black text
                    Text("oDo")
                        .foregroundColor(Color.black)
                        .font(.system(size: 40))
                        .bold()
                        .offset(y: 0) // Adjust vertical position
                }
                .padding(.bottom, 2)
                .offset(y: 20) 

                Text("Stay On Track")
                    .foregroundColor(Color.black)
                    .font(.system(size: 20))
                    .offset(y: -10) // Adjust vertical position
            }
            .padding(.top, 30)
            .offset(y: 60)
        }
        .frame(width: UIScreen.main.bounds.width * 0.7, height: 300)
        .padding()
        .offset(y: -50)
        .onAppear {
            self.animate = true
        }
    }
}

struct ChangingShapeView: Shape {
    var animate: Bool

    func path(in rect: CGRect) -> Path {
        if animate {
            // Define your custom shape when animate is true (e.g., amoeboid shape)
            return Path { path in
                path.move(to: CGPoint(x: rect.width * 0.5, y: 0))
                path.addQuadCurve(to: CGPoint(x: rect.width, y: rect.height * 0.5), control: CGPoint(x: rect.width, y: 0))
                path.addQuadCurve(to: CGPoint(x: rect.width * 0.5, y: rect.height), control: CGPoint(x: rect.width, y: rect.height))
                path.addQuadCurve(to: CGPoint(x: 0, y: rect.height * 0.5), control: CGPoint(x: 0, y: rect.height))
                path.addQuadCurve(to: CGPoint(x: rect.width * 0.5, y: 0), control: CGPoint(x: 0, y: 0))
            }
        } else {
            // Define your custom shape when animate is false (e.g., rectangle)
            return Path { path in
                path.addRect(rect)
            }
        }
    }
}

#Preview {
    HeaderUI()
}

