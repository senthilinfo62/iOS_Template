//
//  AnalyticsManager.swift
//  template
//
//  Created by Complete iOS Setup Script
//

import Foundation
import os.log

/// Analytics event protocol
protocol AnalyticsEvent {
    var name: String { get }
    var parameters: [String: Any] { get }
}

/// Predefined analytics events
enum AppEvent: AnalyticsEvent {
    case appLaunched
    case screenViewed(String)
    case buttonTapped(String)
    case apiCallMade(String)
    case errorOccurred(String)
    case userAction(String, [String: Any])

    var name: String {
        switch self {
        case .appLaunched:
            return "app_launched"
        case .screenViewed:
            return "screen_viewed"
        case .buttonTapped:
            return "button_tapped"
        case .apiCallMade:
            return "api_call_made"
        case .errorOccurred:
            return "error_occurred"
        case .userAction:
            return "user_action"
        }
    }

    var parameters: [String: Any] {
        switch self {
        case .appLaunched:
            return [
                "app_version": AppConstants.App.version,
                "build_number": AppConstants.App.buildNumber,
                "timestamp": Date().timeIntervalSince1970
            ]
        case .screenViewed(let screen):
            return ["screen_name": screen]
        case .buttonTapped(let button):
            return ["button_name": button]
        case .apiCallMade(let endpoint):
            return ["endpoint": endpoint]
        case .errorOccurred(let error):
            return ["error_message": error]
        case .userAction(let action, let params):
            var parameters = params
            parameters["action"] = action
            return parameters
        }
    }
}

/// Analytics manager
final class AnalyticsManager {
    static let shared = AnalyticsManager()

    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.ios.template", category: "Analytics")
    private let isEnabled: Bool

    private init() {
        self.isEnabled = FeatureFlagManager.shared.isEnabled(.analyticsEnabled)
        logger.info("📊 Analytics initialized - Enabled: \(self.isEnabled)")
    }

    /// Track an analytics event
    func track(_ event: AnalyticsEvent) {
        guard isEnabled else {
            logger.debug("📊 Analytics disabled, skipping event: \(event.name)")
            return
        }

        logger.info("📊 Tracking event: \(event.name) with parameters: \(event.parameters)")

        // Send to analytics providers
        sendToFirebase(event)
        sendToMixpanel(event)
        sendToCustomAnalytics(event)
    }

    /// Track screen view
    func trackScreenView(_ screenName: String) {
        track(AppEvent.screenViewed(screenName))
    }

    /// Track button tap
    func trackButtonTap(_ buttonName: String) {
        track(AppEvent.buttonTapped(buttonName))
    }

    /// Track API call
    func trackAPICall(_ endpoint: String) {
        track(AppEvent.apiCallMade(endpoint))
    }

    /// Track error
    func trackError(_ error: String) {
        track(AppEvent.errorOccurred(error))
    }

    /// Track custom user action
    func trackUserAction(_ action: String, parameters: [String: Any] = [:]) {
        track(AppEvent.userAction(action, parameters))
    }

    /// Set user properties
    func setUserProperty(_ value: String, forName name: String) {
        guard isEnabled else { return }

        logger.info("📊 Setting user property: \(name) = \(value)")

        // Set user properties in analytics providers
        // Firebase: Analytics.setUserProperty(value, forName: name)
        // Mixpanel: mixpanel.people.set(property: name, to: value)
    }

    /// Set user ID
    func setUserID(_ userID: String) {
        guard isEnabled else { return }

        logger.info("📊 Setting user ID: \(userID)")

        // Set user ID in analytics providers
        // Firebase: Analytics.setUserID(userID)
        // Mixpanel: mixpanel.identify(distinctId: userID)
    }

    // MARK: - Private Methods

    private func sendToFirebase(_ event: AnalyticsEvent) {
        // Firebase Analytics implementation
        // Analytics.logEvent(event.name, parameters: event.parameters)
        logger.debug("📊 Would send to Firebase: \(event.name)")
    }

    private func sendToMixpanel(_ event: AnalyticsEvent) {
        // Mixpanel implementation
        // mixpanel.track(event: event.name, properties: event.parameters)
        logger.debug("📊 Would send to Mixpanel: \(event.name)")
    }

    private func sendToCustomAnalytics(_ event: AnalyticsEvent) {
        // Custom analytics implementation
        logger.debug("📊 Would send to custom analytics: \(event.name)")
    }
}

// MARK: - SwiftUI Integration
import SwiftUI

/// View modifier for tracking screen views
struct AnalyticsScreenModifier: ViewModifier {
    let screenName: String

    func body(content: Content) -> some View {
        content
            .onAppear {
                AnalyticsManager.shared.trackScreenView(screenName)
            }
    }
}

extension View {
    /// Track screen view when this view appears
    func trackScreenView(_ screenName: String) -> some View {
        self.modifier(AnalyticsScreenModifier(screenName: screenName))
    }
}
