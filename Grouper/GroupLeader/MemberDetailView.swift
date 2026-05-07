//
//  MemberDetailView.swift
//  Grouper
//
//  Created by Travis Domenic Ratliff on 5/5/26.
//

import SwiftUI
import SwiftData

struct MemberDetailView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var path: NavigationPath
    @Bindable var member: Member
    @Bindable var org: Organization
    @State var textFieldsDisabled = true
    @FocusState var isFocused: Bool
    @State var showConfirmation = false
    @State var pickedGroup = ""
    var body: some View {
        List {
            Section("Member Info") {
                TextField("First Name", text: $member.firstName)
                    .focused($isFocused)
                    .disabled(textFieldsDisabled)
                TextField("Last Name", text: $member.lastName)
                    .disabled(textFieldsDisabled)
                TextField("Phone Number", text: $member.phoneNumber)
                    .disabled(textFieldsDisabled)
                TextField("Email", text: $member.email)
                    .disabled(textFieldsDisabled)
                if org.collectIds {
                    TextField("Student ID", text: $member.studentId)
                        .disabled(textFieldsDisabled)
                }
            }
            ForEach(member.guardians.indices, id: \.self) { index in
                Section("Guardian \(index + 1) Info") {
                    TextField("Guardian Title", text: $member.guardians[index].title)
                        .disabled(textFieldsDisabled)
                    TextField("Guardian First Name", text: $member.guardians[index].firstName)
                        .disabled(textFieldsDisabled)
                    TextField("Guardian Last Name", text: $member.guardians[index].lastName)
                        .disabled(textFieldsDisabled)
                    TextField("Guardian Phone Number", text: $member.guardians[index].phoneNumber)
                        .disabled(textFieldsDisabled)
                    TextField("Guardian Email", text: $member.guardians[index].email)
                        .disabled(textFieldsDisabled)
                }
            }
            if !member.subGroups.isEmpty {
                Section("Subgroups") {
                    ForEach(member.subGroups, id: \.self) { subgroup in
                        Text(subgroup)
                    }
                }
            }
        }
        .navigationTitle(member.formattedFullName)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(org.title)
            }
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    textFieldsDisabled.toggle()
                    if !textFieldsDisabled {
                        Task {
                            isFocused = true
                        }
                    } else if textFieldsDisabled {
                        isFocused = false
                    }
                } label: {
                    Image(systemName: textFieldsDisabled ? "pencil.circle.fill" : "checkmark.circle.fill")
                        .foregroundStyle(.red)
                }
                Menu {
                    Menu {
                        ForEach(org.subGroups, id: \.self) { subgroup in
                            Button(subgroup) {
                                member.subGroups.append(subgroup)
                                pickedGroup = subgroup
                                showConfirmation = true
                            }
                            .disabled(member.subGroups.contains(subgroup))
                        }
                    } label: {
                        Text("Assign to Subgroup")
                    }
                    Divider()
                    Button("Delete Member", role: .destructive) {
                        modelContext.delete(member)
                        try? modelContext.save()
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.circle.fill")
                        .foregroundStyle(textFieldsDisabled ? .blue : Color(UIColor.systemGray2))
                }
                .disabled(!textFieldsDisabled)
            }
        }
        .confirmationDialog("Subgroup Added", isPresented: $showConfirmation) {
            Button("OK", role: .close) { pickedGroup = "" }
        } message: {
            Text("\(member.formattedFullName) has been added to \(pickedGroup)!")
        }
    }
}

//#Preview {
//    MemberDetailView()
//}
