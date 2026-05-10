//
//  ContentView.swift
//  Grouper
//
//  Created by Travis Domenic Ratliff on 5/4/26.
//

import SwiftUI
import SwiftData
import FirebaseAuth
import FirebaseFirestore

struct ContentView: View {
    @Query var organizations: [Organization]
    var uid: String { Auth.auth().currentUser?.uid ?? "" }
    var myOrganizations: [Organization] {
        organizations.filter { $0.coachId == uid }
    }
    @State var path = NavigationPath()
    @State var showNewOrg = false
    @Namespace var namespace
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(organizations) { org in
                    NavListButtonView(label: org.title) {
                        path.append(Route.orgDetail(organization: org))
                    }
                }
            }
            .navigationTitle("Groups")
            .navigationDestination(for: Route.self) { route in
                switch route {
                    case .orgDetail(let organization): OrgDetailView(path: $path, organization: organization, namespace: namespace)
                    case .calendarDetail(let day): CalendarDetailView(path: $path, day: day)
                            .navigationTransition(.zoom(sourceID: day.id, in: namespace))
                    case .memberList(let organization): MemberListView(path: $path, org: organization)
                    case .memberDetail(let member, let organization): MemberDetailView(path: $path, member: member, org: organization)
                    case .subgroupDetail(let organization, let subgroup): SubgroupDetailView(path: $path, org: organization, subgroup: subgroup)
                    case .subgroupList(let organization): SubgroupListView(path: $path, org: organization)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showNewOrg = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(.red)
                    }
                }
            }
            .sheet(isPresented: $showNewOrg) {
                NewOrgView()
            }
        }
    }
}

//#Preview {
//    ContentView()
//}
