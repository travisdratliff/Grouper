//
//  SheetButtonView.swift
//  Grouper
//
//  Created by Travis Domenic Ratliff on 5/7/26.
//

import SwiftUI

struct SheetButtonView: View {
    var str: String
    var tint: Color
    var action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Spacer()
                Text(str)
                    .foregroundStyle(.white)
                Spacer()
            }
        }
        .listRowBackground(tint)
    }
}

//#Preview {
//    SheetButtonView()
//}
