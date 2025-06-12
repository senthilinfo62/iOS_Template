//
//  Route.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//

import Foundation

/**
 * The `Route` enum defines all possible navigation destinations.
 *
 * Using an enum for routes ensures type safety and prevents
 * errors from using incorrect navigation paths.
 */
enum Route: Hashable {
    case home
    case details(message: String)
    case settings
}
