//
//  SubgroupDetailView.swift
//  Grouper
//
//  Created by Travis Domenic Ratliff on 5/5/26.
//

import SwiftUI
import SwiftData

struct SubgroupDetailView: View {
    @Binding var path: NavigationPath
    @Bindable var org: Organization
    var subgroup: String
    @State var editGroup = false
    var body: some View {
        List {
            ForEach(org.members.filter { $0.subGroups.contains(subgroup) }.sorted { $0.fullName < $1.fullName }) { member in
//                Button {
//                    path.append(Route.memberDetail(member: member, organization: org))
//                } label: {
//                    NavListButtonView(label: member.formattedFullName)
//                }
//                .tint(.primary)
                NavListButtonView(label: member.formattedFullName) {
                    path.append(Route.memberDetail(member: member, organization: org))
                }
            }
        }
        .navigationTitle(subgroup)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("Send Subgroup Message") { }
                    Button("Add/Remove Members") { editGroup.toggle() }
                    Divider()
                    Button("Delete Subgroup", role: .destructive) { deleteSubgroup() }
                } label: {
                    Image(systemName: "line.3.horizontal.circle.fill")
                        .foregroundStyle(.blue)
                }
                .disabled(editGroup)
            }
        }
        .sheet(isPresented: $editGroup) {
            AddOrRemoveMemberView(org: org, subgroup: subgroup)
        }
    }
    func deleteSubgroup() {
        for member in org.members {
            if let index = member.subGroups.firstIndex(of: subgroup) {
                member.subGroups.remove(at: index)
            }
        }
        if let index = org.subGroups.firstIndex(of: subgroup) {
            org.subGroups.remove(at: index)
        }
        path.removeLast()
    }
}
//
//#Preview {
//    SubgroupDetailView()
//}
