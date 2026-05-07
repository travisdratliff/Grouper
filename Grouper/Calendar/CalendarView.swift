//
//  CalendarView.swift
//  InfoSender
//
//  Created by Travis Domenic Ratliff on 5/1/26.
//

import SwiftUI

struct CalendarView: View {
    @Binding var path: NavigationPath
    @Environment(\.colorScheme) var scheme
    var namespace: Namespace.ID
    @State var calendarMaker = CalendarMaker()
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Button {
                    calendarMaker.changeMonth(by: -1)
                } label: {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text("\(calendarMaker.monthName) \(String(calendarMaker.year))")
                Spacer()
                Button {
                    calendarMaker.changeMonth(by: 1)
                } label: {
                    Image(systemName: "chevron.right")
                }
            }
            .padding()
            .font(.headline)
            .foregroundStyle(.primary)
            HStack {
                ForEach(calendarMaker.shortDays, id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .font(.caption)
                        .bold()
                        .foregroundStyle(.primary)
                }
            }
            .padding(.vertical)
            LazyVGrid(columns: calendarMaker.columns, spacing: 5) {
                ForEach(Array(calendarMaker.gridArray.enumerated()), id: \.offset) { _, dayNum in
                    if dayNum == 0 {
                        Color.clear
                    } else {
                        let day = Day(
                            day: dayNum,
                            month: calendarMaker.month,
                            year: calendarMaker.year
                        )
                        Button {
                            path.append(Route.calendarDetail(day: day))
                        } label: {
                            CalendarCellView(day: day)
                                .matchedTransitionSource(id: day.id, in: namespace)
                        }
                    }
                }
            }
            .buttonStyle(.borderless)
        }
    }
}

//#Preview {
//    CalendarView()
//}
