//
//  DetailsView.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//

import SwiftUI

struct DetailsView: View {
    let message: String

    var body: some View {
        VStack(spacing: 20) {
            Text(NSLocalizedString("details_title", comment: "Details screen title"))
                .font(.title2)
                .bold()

            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
        .navigationTitle(NSLocalizedString("details_title", comment: "Details screen title"))
        .navigationBarTitleDisplayMode(.inline)
    }
}


