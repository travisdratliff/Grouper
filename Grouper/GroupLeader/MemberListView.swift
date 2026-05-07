//
//  MemberListView.swift
//  Grouper
//
//  Created by Travis Domenic Ratliff on 5/5/26.
//

import SwiftUI
import SwiftData

struct MemberListView: View {
    @Binding var path: NavigationPath
    @Bindable var org: Organization
    var body: some View {
        List {
            ForEach(org.members.sorted { $0.fullName < $1.fullName }) { member in
                NavListButtonView(label: member.formattedFullName) {
                    path.append(Route.memberDetail(member: member, organization: org))
                }
            }
        }
        .navigationTitle("Members")
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(org.title)
            }
        }
    }
}

//#Preview {
//    MemberListView()
//}
