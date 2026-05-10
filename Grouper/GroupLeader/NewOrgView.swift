//
//  NewOrgView.swift
//  Grouper
//
//  Created by Travis Domenic Ratliff on 5/4/26.
//

import SwiftUI
import SwiftData
import FirebaseAuth
import FirebaseFirestore

struct NewOrgView: View {
    let db = Firestore.firestore()
    @Environment(\.modelContext) var modelContext
    @Query var organizations: [Organization]
    @Environment(\.dismiss) var dismiss
    @State var showConfirmation = false
    @State var showAlert = false
    @State var org = Organization()
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Group Name", text: $org.title)
                    Toggle("Collect Student IDs (for school groups)", isOn: $org.collectIds)
                        .tint(.red)
                }
                Section {
                    SheetButtonView(str: "Save Group", tint: .blue) {
                        saveOrg()
                    }
                }
            }
            .navigationTitle("New Group")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "minus")
                }
            }
            .confirmationDialog("Group Saved!", isPresented: $showConfirmation) {
                Button("Ok", role: .close) { org.title = "" }
            } message: {
                Text("\(org.title) has been saved! Your join code is \(org.joinCode)")
            }
            .alert("TItle is taken", isPresented: $showAlert) {
                Button("OK", role: .close) { org.title = "" }
            } message: {
                Text("A group with the title \(org.title) already exists. Please choose a different title, or remove the other group.")
            }
        }
    }
    func saveOrg() {
        guard !organizations.contains(where: { $0.title == org.title }) else {
            showAlert = true
            return
        }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let code = String((0..<6).map { _ in "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".randomElement()! })
        let ref = db.collection("groups").document()
        ref.setData([
            "title": org.title,
            "joinCode": code,
            "coachId": uid,
            "collectIds": org.collectIds
        ]) { error in
            if let error {
                print(error.localizedDescription)
                return
            }
            org.firestoreId = ref.documentID
            org.joinCode = code
            org.coachId = uid
            modelContext.insert(org)
            try? modelContext.save()
            showConfirmation = true
        }
    }
}
//
//#Preview {
//    NewOrgView()
//}
