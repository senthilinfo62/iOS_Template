//
//  Router.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//

import SwiftUI

/**
 * The `Router` class manages the navigation stack for the application.
 *
 * It uses SwiftUI's `NavigationPath` to programmatically control
 * the navigation flow, allowing for type-safe routing.
 *
 * Key Responsibilities:
 * - `push(_ route: Route)`: Navigates to a new view.
 * - `pop()`: Returns to the previous view.
 * - `popToRoot()`: Returns to the root view of the navigation stack.
 */
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
