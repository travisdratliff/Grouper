//
//  MemberView.swift
//  Grouper
//
//  Created by Travis Domenic Ratliff on 5/8/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseMessaging

struct MemberView: View {
    let db = Firestore.firestore()
    @State var isCheckingStatus = true
    @State var joinCode = ""
    @State var isLoading = false
    @State var errorMessage = ""
    @State var hasJoinedGroup = false
    @State var groupTitle = ""
    @State var groupId = ""
    var body: some View {
        if isCheckingStatus {
            ProgressView()
                .task { checkIfAlreadyJoined() }
        } else if hasJoinedGroup {
            NavigationStack {
                List {
                    // will be extracted view
                }
                .navigationTitle("My Groups")
            }
        } else {
            NavigationStack {
                List {
                    // will be extracted view
                    
                }
                .navigationTitle("Sign Up!")
            }
        }
    }
    func joinGroup() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        isLoading = true
        errorMessage = ""
        
        // look up the join code in Firestore
        db.collection("groups").whereField("joinCode", isEqualTo: joinCode.uppercased()).getDocuments { snapshot, error in
            if let error {
                isLoading = false
                errorMessage = error.localizedDescription
                return
            }
            guard let document = snapshot?.documents.first else {
                isLoading = false
                errorMessage = "Join code not found. Please check and try again."
                return
            }
            
            let groupId = document.documentID
            let title = document.data()["title"] as? String ?? "My Group"
            
            // get their FCM token
            Messaging.messaging().token { token, error in
                if let error {
                    isLoading = false
                    errorMessage = error.localizedDescription
                    return
                }
                guard let token else {
                    isLoading = false
                    errorMessage = "Could not register device. Please try again."
                    return
                }
                
                // save member to group's subcollection with their FCM token
                db.collection("groups").document(groupId).collection("members").document(uid).setData([
                    "fcmToken": token
                ]) { error in
                    if let error {
                        isLoading = false
                        errorMessage = error.localizedDescription
                        return
                    }
                    
                    // save groupId to their user document
                    db.collection("users").document(uid).updateData([
                        "groupId": groupId,
                        "groupTitle": title
                    ]) { error in
                        isLoading = false
                        if let error {
                            errorMessage = error.localizedDescription
                            return
                        }
                        groupTitle = title
                        hasJoinedGroup = true
                    }
                }
            }
        }
    }
    func checkIfAlreadyJoined() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(uid).getDocument { snapshot, error in
            isCheckingStatus = false
            if let data = snapshot?.data(),
               let existingGroupId = data["groupId"] as? String,
               let existingTitle = data["groupTitle"] as? String {
                groupId = existingGroupId
                groupTitle = existingTitle
                hasJoinedGroup = true
            }
        }
    }
}
//
//#Preview {
//    MemberView()
//}
