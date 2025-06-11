//
//  DeepLinkManager.swift
//  template
//
//  Created by Complete iOS Setup Script
//

import Foundation
import SwiftUI
import os.log

/// Deep link destinations
enum DeepLinkDestination {
    case home
    case settings
    case profile
    case details(String)
    case custom(String, [String: String])

    init?(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }

        let path = components.path
        let queryItems = components.queryItems ?? []

        switch path {
        case "/", "/home":
            self = .home
        case "/settings":
            self = .settings
        case "/profile":
            self = .profile
        case "/details":
            if let id = queryItems.first(where: { $0.name == "id" })?.value {
                self = .details(id)
            } else {
                return nil
            }
        default:
            let params: [String: String] = Dictionary(uniqueKeysWithValues: queryItems.compactMap { item in
                guard let value = item.value else { return nil }
                return (item.name, value)
            })
            self = .custom(path, params)
        }
    }
}

/// Deep link manager
final class DeepLinkManager: ObservableObject {
    static let shared = DeepLinkManager()

    @Published var pendingDeepLink: DeepLinkDestination?

    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.ios.template", category: "DeepLink")

    private init() {}

    /// Handle incoming URL
    func handleURL(_ url: URL) {
        logger.info("🔗 Handling deep link: \(url.absoluteString)")

        guard let destination = DeepLinkDestination(url: url) else {
            logger.warning("🔗 Invalid deep link URL: \(url.absoluteString)")
            return
        }

        DispatchQueue.main.async {
            self.pendingDeepLink = destination
        }

        // Track analytics
        AnalyticsManager.shared.trackUserAction("deep_link_opened", parameters: [
            "url": url.absoluteString,
            "destination": String(describing: destination)
        ])
    }

    /// Handle universal link
    func handleUniversalLink(_ userActivity: NSUserActivity) {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let url = userActivity.webpageURL else {
            return
        }

        logger.info("🔗 Handling universal link: \(url.absoluteString)")
        handleURL(url)
    }

    /// Clear pending deep link
    func clearPendingDeepLink() {
        pendingDeepLink = nil
    }

    /// Generate deep link URL
    func generateDeepLink(for destination: DeepLinkDestination) -> URL? {
        let baseURL = "iostemplate://"

        switch destination {
        case .home:
            return URL(string: "\(baseURL)home")
        case .settings:
            return URL(string: "\(baseURL)settings")
        case .profile:
            return URL(string: "\(baseURL)profile")
        case .details(let id):
            return URL(string: "\(baseURL)details?id=\(id)")
        case .custom(let path, let params):
            var components = URLComponents(string: "\(baseURL)\(path)")
            components?.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
            return components?.url
        }
    }
}
