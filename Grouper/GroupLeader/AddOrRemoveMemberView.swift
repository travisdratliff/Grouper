//
//  AddOrRemoveMemberView.swift
//  Grouper
//
//  Created by Travis Domenic Ratliff on 5/5/26.
//

import SwiftUI
import SwiftData

struct AddOrRemoveMemberView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var org: Organization
    var subgroup: String
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(org.members.sorted { $0.fullName < $1.fullName }) { member in
                        Button {
                            addOrRemoveSubgroup(member: member)
                        } label: {
                            HStack {
                                Image(systemName: member.isPicked ? "circle.fill" : "circle")
                                    .foregroundStyle(.red)
                                Text(member.formattedFullName)
                            }
                        }
                        .tint(.primary)
                    }
                }
            }
            .navigationTitle("Add / Remove Members")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(subgroup)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "minus")
                    }
                }
            }
            .task {
                checkIfContainsGroup()
            }
            .onDisappear {
                org.members.forEach { $0.isPicked = false }
            }
        }
    }
    func addOrRemoveSubgroup(member: Member) {
        member.isPicked.toggle()
        if member.isPicked && !member.subGroups.contains(subgroup) {
            member.subGroups.append(subgroup)
        } else if !member.isPicked && member.subGroups.contains(subgroup) {
            if let index = member.subGroups.firstIndex(of: subgroup) {
                member.subGroups.remove(at: index)
            }
        }
    }
    func checkIfContainsGroup() {
        for member in org.members {
            if member.subGroups.contains(subgroup) {
                member.isPicked = true
            }
        }
    }
}

//#Preview {
//    AddOrRemoveMemberView()
//}
