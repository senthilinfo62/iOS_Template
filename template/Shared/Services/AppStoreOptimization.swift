//
//  AppStoreOptimization.swift
//  template
//
//  Created by iOS Advanced Setup Script
//

import Foundation
import StoreKit
import os.log

/// App Store optimization and review management
final class AppStoreOptimization {
    static let shared = AppStoreOptimization()
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.nexware.template", category: "AppStore")
    private let userDefaults = UserDefaults.standard
    
    // Keys for UserDefaults
    private enum Keys {
        static let launchCount = "app_launch_count"
        static let lastReviewRequestDate = "last_review_request_date"
        static let hasRequestedReview = "has_requested_review"
        static let significantEventCount = "significant_event_count"
    }
    
    private init() {}
    
    // MARK: - App Launch Tracking
    
    /// Track app launch for review timing
    func trackAppLaunch() {
        let currentCount = userDefaults.integer(forKey: Keys.launchCount)
        userDefaults.set(currentCount + 1, forKey: Keys.launchCount)
        
        logger.info("📱 App launch tracked: \(currentCount + 1)")
        
        // Check if we should request review
        checkForReviewRequest()
    }
    
    /// Track significant user events
    func trackSignificantEvent() {
        let currentCount = userDefaults.integer(forKey: Keys.significantEventCount)
        userDefaults.set(currentCount + 1, forKey: Keys.significantEventCount)
        
        logger.info("⭐ Significant event tracked: \(currentCount + 1)")
        
        // Check if we should request review
        checkForReviewRequest()
    }
    
    // MARK: - Review Request Logic
    
    /// Check if we should request a review
    private func checkForReviewRequest() {
        guard shouldRequestReview() else { return }
        
        requestReview()
    }
    
    /// Determine if we should request a review
    private func shouldRequestReview() -> Bool {
        // Don't request if already requested in this version
        if userDefaults.bool(forKey: Keys.hasRequestedReview) {
            return false
        }
        
        let launchCount = userDefaults.integer(forKey: Keys.launchCount)
        let eventCount = userDefaults.integer(forKey: Keys.significantEventCount)
        
        // Request after 10 launches and 5 significant events
        let shouldRequest = launchCount >= 10 && eventCount >= 5
        
        // Check time since last request (if any)
        if let lastRequestDate = userDefaults.object(forKey: Keys.lastReviewRequestDate) as? Date {
            let daysSinceLastRequest = Calendar.current.dateComponents([.day], from: lastRequestDate, to: Date()).day ?? 0
            
            // Don't request more than once every 120 days
            if daysSinceLastRequest < 120 {
                return false
            }
        }
        
        return shouldRequest
    }
    
    /// Request app review
    private func requestReview() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            logger.error("❌ Could not get window scene for review request")
            return
        }
        
        logger.info("⭐ Requesting app review")
        
        SKStoreReviewController.requestReview(in: windowScene)
        
        // Mark as requested
        userDefaults.set(true, forKey: Keys.hasRequestedReview)
        userDefaults.set(Date(), forKey: Keys.lastReviewRequestDate)
    }
    
    /// Manually request review (for settings or specific user action)
    func manuallyRequestReview() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            logger.error("❌ Could not get window scene for manual review request")
            return
        }
        
        logger.info("⭐ Manual app review request")
        SKStoreReviewController.requestReview(in: windowScene)
    }
    
    // MARK: - App Store Redirect
    
    /// Open app in App Store
    func openAppInAppStore() {
        let appStoreURL = "https://apps.apple.com/app/id\(AppConstants.App.appStoreID)"
        
        guard let url = URL(string: appStoreURL) else {
            logger.error("❌ Invalid App Store URL")
            return
        }
        
        logger.info("🏪 Opening app in App Store")
        UIApplication.shared.open(url)
    }
    
    /// Open app store for review
    func openAppStoreForReview() {
        let reviewURL = "https://apps.apple.com/app/id\(AppConstants.App.appStoreID)?action=write-review"
        
        guard let url = URL(string: reviewURL) else {
            logger.error("❌ Invalid App Store review URL")
            return
        }
        
        logger.info("⭐ Opening App Store for review")
        UIApplication.shared.open(url)
    }
    
    // MARK: - Version Checking
    
    /// Check if app update is available
    func checkForAppUpdate() async -> Bool {
        guard let bundleID = Bundle.main.bundleIdentifier else {
            logger.error("❌ Could not get bundle identifier")
            return false
        }
        
        let urlString = "https://itunes.apple.com/lookup?bundleId=\(bundleID)"
        
        guard let url = URL(string: urlString) else {
            logger.error("❌ Invalid iTunes lookup URL")
            return false
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            
            guard let results = json?["results"] as? [[String: Any]],
                  let firstResult = results.first,
                  let appStoreVersion = firstResult["version"] as? String else {
                logger.error("❌ Could not parse App Store version")
                return false
            }
            
            let currentVersion = AppConstants.App.version
            let updateAvailable = appStoreVersion.compare(currentVersion, options: .numeric) == .orderedDescending
            
            logger.info("📱 Version check: Current \(currentVersion), App Store \(appStoreVersion), Update available: \(updateAvailable)")
            
            return updateAvailable
        } catch {
            logger.error("❌ Error checking for app update: \(error)")
            return false
        }
    }
    
    // MARK: - Analytics for App Store
    
    /// Track app store conversion events
    func trackAppStoreEvent(_ event: AppStoreEvent) {
        logger.info("📊 App Store event: \(event.rawValue)")
        
        // Here you would integrate with your analytics service
        // Example: Analytics.track(event.rawValue)
    }
    
    // MARK: - Reset for Testing
    
    /// Reset review request state (for testing)
    func resetReviewRequestState() {
        userDefaults.removeObject(forKey: Keys.hasRequestedReview)
        userDefaults.removeObject(forKey: Keys.lastReviewRequestDate)
        userDefaults.removeObject(forKey: Keys.launchCount)
        userDefaults.removeObject(forKey: Keys.significantEventCount)
        
        logger.info("🔄 Review request state reset")
    }
}

// MARK: - App Store Events

enum AppStoreEvent: String, CaseIterable {
    case appLaunched = "app_launched"
    case reviewRequested = "review_requested"
    case reviewCompleted = "review_completed"
    case appStoreOpened = "app_store_opened"
    case updateAvailable = "update_available"
    case updateInstalled = "update_installed"
    case significantEvent = "significant_event"
}

// MARK: - App Constants Extension

extension AppConstants.App {
    /// App Store ID (replace with your actual App Store ID)
    static let appStoreID = "123456789"
}

// MARK: - SwiftUI Integration

import SwiftUI

/// View modifier for tracking significant events
struct SignificantEventModifier: ViewModifier {
    let event: String
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                AppStoreOptimization.shared.trackSignificantEvent()
                AppStoreOptimization.shared.trackAppStoreEvent(.significantEvent)
            }
    }
}

extension View {
    /// Track significant user events for review timing
    func trackSignificantEvent(_ event: String = "view_appeared") -> some View {
        self.modifier(SignificantEventModifier(event: event))
    }
}

/// App Store review request button
struct ReviewRequestButton: View {
    var body: some View {
        Button("Rate This App") {
            AppStoreOptimization.shared.manuallyRequestReview()
            AppStoreOptimization.shared.trackAppStoreEvent(.reviewRequested)
        }
        .buttonStyle(.borderedProminent)
    }
}

/// App update available banner
struct UpdateAvailableBanner: View {
    @State private var updateAvailable = false
    
    var body: some View {
        if updateAvailable {
            HStack {
                VStack(alignment: .leading) {
                    Text("Update Available")
                        .font(.headline)
                    Text("A new version is available on the App Store")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button("Update") {
                    AppStoreOptimization.shared.openAppInAppStore()
                    AppStoreOptimization.shared.trackAppStoreEvent(.appStoreOpened)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
        }
    }
    
    func checkForUpdate() {
        Task {
            updateAvailable = await AppStoreOptimization.shared.checkForAppUpdate()
            if updateAvailable {
                AppStoreOptimization.shared.trackAppStoreEvent(.updateAvailable)
            }
        }
    }
}
