//
//  NewMemberView.swift
//  Grouper
//
//  Created by Travis Domenic Ratliff on 5/4/26.
//

import SwiftUI
import SwiftData

struct NewMemberView: View {
    @Bindable var org: Organization
    @Environment(\.dismiss) var dismiss
    @State var newMember = Member()
    var body: some View {
        NavigationStack {
            List {
                Section("Member Info") {
                    TextField("First Name", text: $newMember.firstName)
                    TextField("Last Name", text: $newMember.lastName)
                    TextField("Phone Number", text: $newMember.phoneNumber)
                    TextField("Email", text: $newMember.email)
                    if org.collectIds {
                        TextField("Student ID", text: $newMember.studentId)
                    }
                }
                ForEach(newMember.guardians.indices, id: \.self) { index in
                    Section("Guardian \(index + 1) Info") {
                        TextField("Guardian Title", text: $newMember.guardians[index].title)
                        TextField("Guardian First Name", text: $newMember.guardians[index].firstName)
                        TextField("Guardian Last Name", text: $newMember.guardians[index].lastName)
                        TextField("Guardian Phone Number", text: $newMember.guardians[index].phoneNumber)
                        TextField("Guardian Email", text: $newMember.guardians[index].email)
                    }
                }
                Section {
                    SheetButtonView(str: "Add Guardian", tint: .red) {
                        newMember.guardians.append(Guardian())
                    }
                }
                Section {
                    SheetButtonView(str: "Sign Up!", tint: .blue) {
                        saveMember()
                    }
                    .disabled(!isValid())
                }
            }
            .navigationTitle("Welcome to \(org.title)!")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "minus")
                    }
                }
            }
            .onAppear {
                newMember.guardians.append(Guardian())
            }
        }
    }
    func saveMember() {
        if org.collectIds {
            guard !org.members.contains(where: { $0.studentId == newMember.studentId }) else { return }
            org.members.append(newMember)
        } else {
            org.members.append(newMember)
        }
    }
    func isValid() -> Bool {
        !newMember.firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !newMember.lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !newMember.phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !newMember.email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

//#Preview {
//    NewMemberView()
//}
