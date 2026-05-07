//
//  SubgroupListView.swift
//  Grouper
//
//  Created by Travis Domenic Ratliff on 5/5/26.
//

import SwiftUI
import SwiftData

struct SubgroupListView: View {
    @Binding var path: NavigationPath
    @Bindable var org: Organization
    var body: some View {
        List {
            ForEach(org.subGroups.sorted { $0 < $1 }, id: \.self) { subgroup in
                NavListButtonView(label: subgroup) {
                    path.append(Route.subgroupDetail(organization: org, subgroup: subgroup))
                }
            }
        }
        .navigationTitle("Subgroups")
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(org.title)
            }
        }
    }
}

//#Preview {
//    SubgroupListView()
//}
