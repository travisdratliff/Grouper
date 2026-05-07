//
//  CalendarDetailView.swift
//  InfoSender
//
//  Created by Travis Domenic Ratliff on 5/1/26.
//

import SwiftUI
import SwiftData

struct CalendarDetailView: View {
    @Binding var path: NavigationPath
    @Environment(\.dismiss) var dismiss
    static let components = Calendar.current.dateComponents([.day, .month, .year], from: Date())
    let day: Day
    var isDay: Bool {
        day.day == Self.components.day! &&
        day.month == Self.components.month! &&
        day.year == Self.components.year!
    }
    var body: some View {
        List {
            
        }
        .navigationTitle(day.dateMatch.description)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            if isDay {
                ToolbarItem(placement: .principal) {
                    Text("Today")
                        .bold()
                        .foregroundStyle(.red)
                }
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

//#Preview {
//    CalendarDetailView()
//}
