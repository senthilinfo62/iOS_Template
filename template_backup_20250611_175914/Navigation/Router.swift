//
//  Router.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//

import SwiftUI

final class Router: ObservableObject {
    @Published var path = NavigationPath()

    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}
