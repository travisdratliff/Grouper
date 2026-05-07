//
//  NewSubgroupView.swift
//  Grouper
//
//  Created by Travis Domenic Ratliff on 5/5/26.
//

import SwiftUI
import SwiftData

struct NewSubgroupView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var org: Organization
    @State var title = ""
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Subgroup Title", text: $title)
                }
                Section("Assign Members") {
                    ForEach(org.members.sorted { $0.fullName < $1.fullName }) { member in
                        Button {
                            member.isPicked.toggle()
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
                Section {
                    SheetButtonView(str: "Save Subgroup", tint: .blue) {
                        createSubgroup()
                    }
                }
            }
            .navigationTitle("New Subgroup")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(org.title)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "minus")
                    }
                }
            }
            .onAppear {
                org.members.forEach { $0.isPicked = false }
            }
        }
    }
    func createSubgroup() {
        guard !org.subGroups.contains(where: { $0 == title }) else { return }
        org.subGroups.append(title)
        for member in org.members {
            if member.isPicked {
                member.subGroups.append(title)
            }
        }
    }
}

//#Preview {
//    NewSubgroupView()
//}
