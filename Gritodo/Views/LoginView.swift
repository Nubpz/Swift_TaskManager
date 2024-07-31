//
//  LoginView.swift
//  Gritodo
//
//  Created by Nabin Poudel on 7/13/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewViewModel()
    @State private var isPressed: Bool = false
    
    var body: some View {
        NavigationView{
            VStack{
             HeaderUI()
                VStack {
                    VStack(spacing: 20) {
                        if !viewModel.errorMessage.isEmpty{
                            Text(viewModel.errorMessage)
                                .foregroundColor(Color.red)
                        }
                        // Email Address Field
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.gray)
                            TextField("Email Address", text: $viewModel.email)
                                .padding()
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                        }
                        
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.red.opacity(0.1), Color.yellow.opacity(0.1)]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(10)
                        .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
                        
                        // Password Field
                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.gray)
                            SecureField("Password", text: $viewModel.password)
                                .padding()
                        }
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.red.opacity(0.1), Color.yellow.opacity(0.1)]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(10)
                        .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
                        
                        // Login Button
                        Button(action: {
                            viewModel.login()
                        }) {
                            Text("Login")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 300, height: 50)
                                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(10)
                                .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
                                .scaleEffect(self.isPressed ? 0.95 : 1.0)
                                .animation(.spring(), value: isPressed)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .onLongPressGesture(minimumDuration: .infinity, pressing: { isPressing in
                            self.isPressed = isPressing
                        }) {}
                        
                        // Create Account Link
                        VStack {
                            Text("New around here?")
                            NavigationLink("Create An Account", destination: RegisterView())
                                .padding(.top, 10)
                        }
                    }
                    .offset(y: 60)
                    .padding(.horizontal, 30)
                    
                    Spacer()
                }
            }
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
