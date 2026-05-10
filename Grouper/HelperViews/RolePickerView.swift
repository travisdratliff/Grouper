//
//  RolePickerView.swift
//  Grouper
//
//  Created by Travis Domenic Ratliff on 5/8/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RolePickerView: View {
    @Binding var isLoggedIn: Bool
    @Binding var userRole: String
    @State var isLoading = false
    @State var errorMessage = ""
    let db = Firestore.firestore()
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("Are you setting up a group as a coach or director, or are you a member joining a group?")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
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
                        saveRole("coach")
                    } label: {
                        HStack {
                            Spacer()
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("I'm a Coach / Director")
                                    .foregroundStyle(.white)
                            }
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.blue)
                    .disabled(isLoading)
                }
                Section {
                    Button {
                        saveRole("member")
                    } label: {
                        HStack {
                            Spacer()
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("I'm a Member")
                                    .foregroundStyle(.white)
                            }
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.red)
                    .disabled(isLoading)
                }
            }
            .navigationTitle("Welcome to Grouper 🐟")
        }
    }
    func saveRole(_ role: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        isLoading = true
        errorMessage = ""
        db.collection("users").document(uid).setData(["role": role]) { error in
            isLoading = false
            if let error {
                errorMessage = error.localizedDescription
                return
            }
            userRole = role
        }
    }
}
