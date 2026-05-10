//
//  LoginView.swift
//  Grouper
//
//  Created by Travis Domenic Ratliff on 5/7/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    @State var email = ""
    @State var password = ""
    @State var isLoading = false
    @State var errorMessage = ""
    @Binding var isLoggedIn: Bool
    @Binding var userRole: String
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    SecureField("Password", text: $password)
                }
                if !errorMessage.isEmpty {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .font(.footnote)
                    }
                }
                Section {
                    Button {
                        login()
                    } label: {
                        HStack {
                            Spacer()
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Sign In")
                                    .foregroundStyle(.white)
                            }
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.blue)
                    .disabled(!isValid() || isLoading)
                }
                Section {
                    Button {
                        createAccount()
                    } label: {
                        HStack {
                            Spacer()
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Create Account")
                                    .foregroundStyle(.white)
                            }
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.red)
                    .disabled(!isValid() || isLoading)
                }
            }
            .navigationTitle("Grouper 🐟")
        }
    }
    func isValid() -> Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        password.count >= 6
    }
    func login() {
        isLoading = true
        errorMessage = ""
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            isLoading = false
            if let error {
                errorMessage = error.localizedDescription
                return
            }
            fetchRole()
        }
    }
    func createAccount() {
        isLoading = true
        errorMessage = ""
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            isLoading = false
            if let error {
                errorMessage = error.localizedDescription
                return
            }
            fetchRole()
        }
    }
    func fetchRole() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            if let role = snapshot?.data()?["role"] as? String {
                userRole = role
            }
            isLoggedIn = true
        }
    }
}
