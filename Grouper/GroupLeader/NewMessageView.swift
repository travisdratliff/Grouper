//
//  NewMessageView.swift
//  Grouper
//
//  Created by Travis Domenic Ratliff on 5/5/26.
//

import SwiftUI
import SwiftData

struct NewMessageView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var org: Organization
    @State var message = Message()
    @State var emailPicked = false
    @State var phoneNumberPicked = false
    @State var membersPicked = false
    @State var guardiansPicked = false
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Message Title", text: $message.title)
                    TextField("Message Content", text: $message.content, axis: .vertical)
                }
                Section("Send Via:") {
                    Button {
                        emailPicked.toggle()
                    } label: {
                        HStack {
                            Image(systemName: emailPicked ? "circle.fill" : "circle")
                                .foregroundStyle(.red)
                            Text("Emails")
                        }
                    }
                    .tint(.primary)
                    Button {
                        phoneNumberPicked.toggle()
                    } label: {
                        HStack {
                            Image(systemName: phoneNumberPicked ? "circle.fill" : "circle")
                                .foregroundStyle(.red)
                            Text("Phone Numbers")
                        }
                    }
                    .tint(.primary)
                }
                Section("To:") {
                    Button {
                        membersPicked.toggle()
                    } label: {
                        HStack {
                            Image(systemName: membersPicked ? "circle.fill" : "circle")
                                .foregroundStyle(.red)
                            Text("Members")
                        }
                    }
                    .tint(.primary)
                    Button {
                        guardiansPicked.toggle()
                    } label: {
                        HStack {
                            Image(systemName: guardiansPicked ? "circle.fill" : "circle")
                                .foregroundStyle(.red)
                            Text("Guardians")
                        }
                    }
                    .tint(.primary)
                }
                Section {
                    SheetButtonView(str: "Save For Later", tint: Color.red) {
                        print("no function yet")
                    }
                }
                Section {
                    SheetButtonView(str: "Send Now", tint: Color.blue) {
                        print("NO FUNCTION YET")
                    }
                }
            }
            .navigationTitle("New Message")
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
        }
    }
}

//#Preview {
//    NewMessageView()
//}
