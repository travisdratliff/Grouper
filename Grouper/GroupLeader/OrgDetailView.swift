//
//  OrgDetailView.swift
//  Grouper
//
//  Created by Travis Domenic Ratliff on 5/4/26.
//

import SwiftUI
import SwiftData

struct OrgDetailView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var path: NavigationPath
    @Bindable var organization: Organization
    @State var activeSheet: ActiveSheet?
    var namespace: Namespace.ID
    var body: some View {
        List {
            Section {
                NavListButtonView(label: "Members") {
                    path.append(Route.memberList(organization: organization))
                }
                NavListButtonView(label: "Subgroups") {
                    path.append(Route.subgroupList(organization: organization))
                }
                NavListButtonView(label: "Messages") {
                    print("messages not working yet")
                }
                NavListButtonView(label: "Events") {
                    print("events not working yet")
                }
            }
            Section {
                CalendarView(path: $path, namespace: namespace)
                    .buttonStyle(.borderless)
            }
        }
        .navigationTitle(organization.title)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Menu {
                    Button("Join Mode") { activeSheet = .newMember }
                    Button("QR Code") { }
                    Button("Join Link") { }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(.red)
                }
                Menu {
                    Button("Import Members") { }
                    Button("Export Members") { }
                    Divider()
                    Button("New Message") { activeSheet = .newMessage }
                    Button("New Event") { activeSheet = .newEvent }
                    Button("New Subgroup") { activeSheet = .newSubgroup }
                    Divider()
                    Button("Delete Group", role: .destructive) { deleteOrganization() }
                } label: {
                    Image(systemName: "line.3.horizontal.circle.fill")
                        .foregroundStyle(.blue)
                }
            }
        }
        .sheet(item: $activeSheet) { value in
            switch value {
                case .newMember: NewMemberView(org: organization)
                case .newMessage: NewMessageView(org: organization)
                case .newEvent: NewMemberView(org: organization)
                case .newSubgroup: NewSubgroupView(org: organization)
            }
        }
    }
    func deleteOrganization() {
        // make alert to do this
        modelContext.delete(organization)
        try? modelContext.save()
        path.removeLast()
    }
}

enum ActiveSheet: Identifiable {
    case newMember
    case newMessage
    case newEvent
    case newSubgroup
    var id: Self { self }
}
//
//#Preview {
//    OrgDetailView()
//}
