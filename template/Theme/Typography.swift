//
//  Typography.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//

import SwiftUI

struct Typography {
    static let heading = Font.system(size: 24, weight: .bold)
    static let body = Font.system(size: 16)
    static let caption = Font.system(size: 12)
}
#Preview {
    Text("Hello World").font(Typography.heading)
}