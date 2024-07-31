


import SwiftUI
import PhotosUI

struct ProfileView: View {
    @Binding var profileImage: UIImage? // Binding for profile image
    @StateObject var viewModel = ProfileViewViewModel() // Assuming a ViewModel is used for profile management
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = nil
    @State private var showAlert = false
    @State private var navigateToLogin = false
    @State private var errorMessage = ""
    @State private var showErrorAlert: Bool = false

    var body: some View {
        NavigationView {
            
            VStack(spacing: 20) {
                if let user = viewModel.user {
                    VStack(spacing: 0){
                        headerView
                            .background(Color.gray.opacity(0.15))
                            
                        GradientLine()
                            .frame(height: 7)
                    }
              
                    VStack(spacing: 20) {
                        // Avatar
                        VStack {
                            if let selectedImage = selectedImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .shadow(radius: 8)
                                    .onAppear {
                                        profileImage = selectedImage // Update profile image
                                    }
                            } else {
                                Image(uiImage: profileImage ?? UIImage(systemName: "person.fill")!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .shadow(radius: 8)
                                    .onAppear {
                                        profileImage = profileImage // Ensure existing profile image is used
                                    }
                            }
                        }
                        .padding(20)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 8)
                        .offset(y: 40)
                        
                        Text("Update Picture")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .padding(.top, 60)
                            .onTapGesture {
                                showImagePicker = true
                            }
                        
                        // Info
                        VStack(alignment: .leading, spacing: 8) {
                            ProfileInfoRow(label: "Name:", value: user.name)
                            ProfileInfoRow(label: "Email:", value: user.email)
                            ProfileInfoRow(label: "Member Since:", value: "\(Date(timeIntervalSince1970: user.joined).formatted(date: .abbreviated, time: .shortened))")
                        }
                        .offset(y: 30)
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                        
                        // Sign Out Button with animation
                        Button(action: {
                            viewModel.logOut()
                            navigateToLogin = true
                        }) {
                            Text("Log Out")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(10)
                                .padding(.horizontal, 20)
                                .shadow(radius: 5)
                                .scaleEffect(self.isPressed ? 0.95 : 1.0)
                                .animation(.spring(), value: isPressed)
                        }
                        .offset(y: 40)
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal, 40)
                        .padding(.vertical, 10)
                        .onLongPressGesture(minimumDuration: .infinity, pressing: { isPressing in
                            self.isPressed = isPressing
                        }) {}
                        
                        Spacer()
                        
                        VStack {
                            Text("Delete Account")
                                .font(.headline)
                                .foregroundColor(.red)
                                .padding(.horizontal, 20)
                                .onTapGesture {
                                    showAlert = true
                                }
                                .alert(isPresented: $showAlert) {
                                    Alert(
                                        title: Text("Delete Account"),
                                        message: Text("Are you sure you want to delete your account? This will delete all your data and cannot be undone."),
                                        primaryButton: .destructive(Text("Delete")) {
                                            viewModel.deleteAccount { success in
                                                if success {
                                                    viewModel.logOut()
                                                    navigateToLogin = true
                                                } else {
                                                    errorMessage = "Failed to delete the account. Please try again."
                                                    showErrorAlert = true
                                                }
                                            }
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }

                            // Developer Info
                            Text("@ Developed by Nabin Poudel")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.bottom, 20) // Add padding to ensure it's visible
                                .offset(y: 30)
                        }
                        .offset(y: -80)
                    }
                    
                } else {
                    LoadingView()
                        .padding()
                   
                }
            }
            .onAppear {
                viewModel.fetchUser()
            }
            .background(
                NavigationLink(
                    destination: LoginView(),
                    isActive: $navigateToLogin,
                    label: { EmptyView() }
                )
            )
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage)
                    .onDisappear {
                        if let newImage = selectedImage {
                            profileImage = newImage
                        }
                    }
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
    
    // Profile Header View
    private var headerView: some View {
        VStack(alignment: .leading) {
            Text("Profile")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .padding(.leading, 10) // Align text to the leading edge
            
//            GradientLine()
//                .frame(height: 7)
        }
        .frame(maxWidth: .infinity, alignment: .leading) // Ensure header view spans full width and aligns content to leading edge
    
    }
    
    @State private var isPressed = false
}

// Profile Info Row
struct ProfileInfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
                .foregroundColor(.secondary)
            Text(value)
                .font(.body)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// Image Picker
struct ImagePicker: View {
    @Binding var image: UIImage?
    @Environment(\.dismiss) var dismiss
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var imageData: Data? = nil

    var body: some View {
        PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()) {
                Text("Select Photo")
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    // Retrieve selected asset in the form of Data
                    if let selectedItem = selectedItem {
                        let data = try? await selectedItem.loadTransferable(type: Data.self)
                        if let data = data {
                            image = UIImage(data: data)
                        }
                    }
                }
            }
    }
}

// Custom Loading View
struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
            Image(systemName: "gear")
                .resizable()
                .frame(width: 50, height: 50)
                .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
                .onAppear {
                    isAnimating = true
                }
            
            Text("Loading Profile...")
                .font(.headline)
                .foregroundColor(.blue)
        }
    }
}
