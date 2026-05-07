//
//  NavListButtonView.swift
//  Grouper
//
//  Created by Travis Domenic Ratliff on 5/4/26.
//

import SwiftUI

struct NavListButtonView: View {
    var label: String
    var action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Group {
                    Text(label)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .foregroundStyle(.primary)
            }
        }
        .tint(.primary)
    }
}
//
//#Preview {
//    NavListButtonView()
//}
