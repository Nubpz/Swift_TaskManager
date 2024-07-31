//
//  RegisterView.swift
//  Gritodo
//
//  Created by Nabin Poudel on 7/13/24.
//


import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.red.opacity(0.3), Color.yellow]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .rotationEffect(Angle(degrees: -12))
                    .scaleEffect(viewModel.animate ? 1.10 : 0.9)
                    .animation(Animation.easeInOut(duration: 8).repeatForever(autoreverses: true))
                    .frame(width: UIScreen.main.bounds.width * 1, height: 800)
                    .shadow(radius: 10)
                    
                
                LinearGradient(gradient: Gradient(colors: [Color.red.opacity(0.3), Color.yellow.opacity(0.3)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all) // Light gradient background

                VStack(spacing: 30) {

                    // Full Name Field with Icon
                    VStack {
                        HStack(spacing: 0) {
                            // Yellow filled text with black stroke
                            Text("Create a New Account")
                                .foregroundColor(Color.black)
                                .font(.system(size: 30))
                                .bold()
                                .offset(y: -18) // Adjust vertical position
                        }
                            Text("Set Up in Seconds")
                                .foregroundColor(Color.black)
                                .font(.system(size: 20))
                                .offset(y: -10) // Adjust vertical position
                        }
                        .offset(y: 100)
                   
                    VStack{
                        HStack {
                            Image(systemName: "person")
                                .foregroundColor(.black)
                            
                            TextField("Full Name", text: $viewModel.fullName)
                                .foregroundColor(.black)
                                .autocorrectionDisabled()
                        }
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.8), Color.yellow.opacity(0.3)]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3.5)
                        
                        .padding(.horizontal)
                        
                        // Email Address Field with Icon
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.black)
                            
                            TextField("Email Address", text: $viewModel.email)
                                .foregroundColor(.black)
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                        }
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.8), Color.yellow.opacity(0.3)]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3.5)
                        .padding(.horizontal)
                        
                        // Password Field with Icon
                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.black)
                            
                            SecureField("Password", text: $viewModel.password)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.8), Color.yellow.opacity(0.3)]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3.5)
                        .padding(.horizontal)
                        
                        
                        
                        // Register Button with 3D Effect
                        Button(action: {
                            // Attempt registration
                            viewModel.register()
                        }) {
                            Text("Register")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 300, height: 50)
                                .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(10)
                                .shadow(color: Color.green.opacity(0.5), radius: 10, x: 0, y: 10)
                                .scaleEffect(viewModel.isPressed ? 0.9 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0.6), value: viewModel.isPressed)
                                .offset(y: 50)
                        }
                        .onLongPressGesture(minimumDuration: .infinity, pressing: { isPressing in
                            self.viewModel.isPressed = isPressing
                        }) {}
                        
                        Button("Already have an account?") { dismiss() }
                            .offset(y: 80)
                    }
                    .offset(y: 100)
                    Spacer()
                }
                .padding(.top, 50)
            }
            .navigationBarTitleDisplayMode(.inline)
            }
        }
    }


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}


