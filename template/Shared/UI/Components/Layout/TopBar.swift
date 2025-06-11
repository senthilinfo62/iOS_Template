//
//  TopBar.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//

import SwiftUI

struct TopBar: View {
    var title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .bold()
            Spacer()
        }
        .padding()
        .background(Color("TopBarBackground"))
    }
}
