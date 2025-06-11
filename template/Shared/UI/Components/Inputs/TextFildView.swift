//
//  TextFildView.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//

import SwiftUI

struct TextFieldView: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
    }
}
