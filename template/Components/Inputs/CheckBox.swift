//
//  CheckBox.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//

import SwiftUI

struct CheckBox: View {
    @Binding var isChecked: Bool
    var label: String
    var activeColor: Color = .green
    var inactiveColor: Color = .gray
    var iconSize: CGFloat = 20

    var body: some View {
        HStack {
            Button(action: { isChecked.toggle() }) {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .resizable()
                    .frame(width: iconSize, height: iconSize)
                    .foregroundColor(isChecked ? activeColor : inactiveColor)
            }

            Text(label)
                .font(.body)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 4)
        .padding(.horizontal)
    }
}
