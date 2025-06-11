//
//  PrimaryButton.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//

import SwiftUI

struct PrimaryButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.accentColor)
                .cornerRadius(12)
        }
    }
}
