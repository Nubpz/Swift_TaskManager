//
//  NewItemView.swift
//  Gritodo
//
//  Created by Nabin Poudel on 7/15/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class ExpandingTextField: UITextField {
    var textChanged: (String) -> Void = { _ in }
    var isMultiLine: Bool = false // New property to track multi-line mode

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        if isMultiLine, let text = self.text, !text.isEmpty {
            let width = frame.width
            let newSize = (text as NSString).boundingRect(
                with: CGSize(width: width, height: .greatestFiniteMagnitude),
                options: .usesLineFragmentOrigin,
                attributes: [.font: font ?? UIFont.systemFont(ofSize: 17)],
                context: nil
            )
            return CGSize(width: width, height: max(newSize.height + 20, size.height))
        }
        return size
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }

    @objc func textDidChange() {
        textChanged(self.text ?? "")
    }
}

struct ExpandingTextFieldRepresentable: UIViewRepresentable {
    @Binding var text: String
    @Binding var isMultiLine: Bool
    var onCommit: () -> Void

    func makeUIView(context: Context) -> ExpandingTextField {
        let textField = ExpandingTextField()
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.textColor = .label
        textField.text = text
        textField.placeholder = "Enter task"
        textField.isMultiLine = isMultiLine
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textDidChange(_:)), for: .editingChanged)
        textField.delegate = context.coordinator
        return textField
    }

    func updateUIView(_ uiView: ExpandingTextField, context: Context) {
        uiView.text = text
        uiView.isMultiLine = isMultiLine
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, onCommit: onCommit)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: ExpandingTextFieldRepresentable
        var onCommit: () -> Void

        init(_ parent: ExpandingTextFieldRepresentable, onCommit: @escaping () -> Void) {
            self.parent = parent
            self.onCommit = onCommit
        }

        @objc func textDidChange(_ textField: ExpandingTextField) {
            parent.text = textField.text ?? ""
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            onCommit()
            textField.text = ""
            return false
        }
    }
}

struct NewItemView: View {
    @StateObject var viewModel = NewItemViewViewModel()
    @Binding var newItemPresented: Bool
    @State private var isPressed: Bool = false
    @State private var keyboardHeight: CGFloat = 0

    @State private var newCaptionItem: String = ""
    @State private var captionList: [String] = []
    @State private var isMultiLine: Bool = false // Tracks multi-line mode

    var body: some View {
        VStack(spacing: 20) {
            
            Text("Add Task")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
  
            ScrollView {
                VStack(spacing: 20) {
                    // Title and Captions
                    VStack(spacing: 20) {
                        Group {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Task Title")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                
                                TextField("Title", text: $viewModel.title)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(15)
                                    .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 5)
                            }
                            .padding(.horizontal)

                            VStack(alignment: .leading, spacing: 16) {
                                Text("Tasks")
                                    .font(.title2)
                                    .fontWeight(.semibold)

                                // List Input
                                ExpandingTextFieldRepresentable(text: $newCaptionItem, isMultiLine: $isMultiLine, onCommit: addCaption)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(15)
                                    .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 5)
                                    .frame(minHeight: 40)

                                // Display list of items
                                VStack(alignment: .leading, spacing: 10) {
                                    ForEach(Array(captionList.enumerated()), id: \.offset) { index, item in
                                        Text("\(index + 1). \(item)")
                                            .padding(.vertical, 4)
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(15)
                                .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 5)
                                
                                // Make a List Button
                                Button(action: {
                                    isMultiLine.toggle() // Toggle multi-line mode
                                }) {
                                    Text(isMultiLine ? "Single Line Mode" : "Make a List")
                                        .font(.headline)
                                        .foregroundColor(.blue)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .trailing) 
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 20)

                    // Due Date and Time
                    VStack(spacing: 20) {
                        Group {
                            DatePicker("Due Date", selection: $viewModel.dueDate, in: Date()..., displayedComponents: [.date])
                            DatePicker("Due Time", selection: $viewModel.dueDate, displayedComponents: [.hourAndMinute])
                        }
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: Color.gray.opacity(0.2), radius: 20, x: 0, y: 5)
                        .accentColor(.purple)
                    }
                    .padding(.horizontal)

                    // Task Color
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Task Color")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.bottom, 8)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                let colors: [String] = (1...7).map { "taskColor \($0)" }
                                ForEach(colors, id: \.self) { color in
                                    Circle()
                                        .fill(Color(color).opacity(0.9))
                                        .frame(width: 60, height: 40)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white, lineWidth: viewModel.tint == color ? 4 : 2)
                                        )
                                        .shadow(color: Color.gray.opacity(0.2), radius: 6, x: 0, y: 3)
                                        .scaleEffect(viewModel.tint == color ? 1.2 : 1.0)
                                        .animation(.spring(), value: viewModel.tint)
                                        .onTapGesture {
                                            withAnimation {
                                                viewModel.tint = color
                                            }
                                        }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.horizontal)


                    // Save Button
                    Button(action: {
                        viewModel.caption = captionList.map { "\(captionList.firstIndex(of: $0)! + 1). \($0)" }.joined(separator: "\n") // Save as a single string with newlines
                        viewModel.save()
                        if viewModel.canSave {
                            newItemPresented = false
                        }
                    }) {
                        Text("Save")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(15)
                            .padding(.horizontal, 20)
                            .shadow(color: Color.gray.opacity(0.3), radius: 10, x: 0, y: 5)
                            .scaleEffect(self.isPressed ? 0.95 : 1.0)
                            .animation(.spring(), value: isPressed)
                    }
                    .alert(isPresented: $viewModel.showAlert) {
                        Alert(
                            title: Text("Error"),
                            message: Text("Please fill in all fields and select a due date that is today or newer.")
                        )
                    }
                }
                .padding()
                .background(Color.white)
                .padding(.bottom, keyboardHeight) // Adjust bottom padding based on keyboard height
                .onAppear {
                    // Subscribe to keyboard notifications
                    NotificationCenter.default.addObserver(
                        forName: UIResponder.keyboardWillChangeFrameNotification,
                        object: nil,
                        queue: .main
                    ) { notification in
                        if let userInfo = notification.userInfo,
                           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                            let keyboardHeight = keyboardFrame.height
                            withAnimation {
                                self.keyboardHeight = keyboardHeight
                            }
                        }
                    }
                }
                .onDisappear {
                    // Remove keyboard notification observer
                    NotificationCenter.default.removeObserver(
                        self,
                        name: UIResponder.keyboardWillChangeFrameNotification,
                        object: nil
                    )
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .edgesIgnoringSafeArea(.bottom)
    }

    private func addCaption() {
        if !newCaptionItem.isEmpty {
            if isMultiLine {
                captionList.append(newCaptionItem)
                newCaptionItem = ""
            } else {
                // Handle single-line case if needed
                captionList = [newCaptionItem] // Replace with single item
                newCaptionItem = ""
            }
        }
    }
}

// A simple view for applying blur effect
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

#Preview {
    NewItemView(newItemPresented: .constant(true))
}
