//
//  CalendarCellView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

import SwiftUI
import SwiftData

struct CalendarCellView: View {
    @Environment(\.colorScheme) var scheme
    static let components = Calendar.current.dateComponents([.day, .month, .year], from: Date())
    var isDay: Bool {
        day.day == Self.components.day! &&
        day.month == Self.components.month! &&
        day.year == Self.components.year!
    }
    let day: Day
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .tint(isDay ? Color.red : Color.clear)
                .frame(height: 40)
            Text("\(day.day)")
                .font(.footnote)
                .foregroundStyle(isDay ? Color.white : Color.primary)
                .frame(height: 40)
        }
    }
}

//#Preview {
//    CalendarCellView()
//}
