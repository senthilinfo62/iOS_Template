//
//  FeatureFlag.swift
//  template
//
//  Created by Complete iOS Setup Script
//

import Foundation

/// Feature flags for controlling app features
enum FeatureFlag: String, CaseIterable {
    case newHomeDesign = "new_home_design"
    case enhancedSecurity = "enhanced_security"
    case betaFeatures = "beta_features"
    case analyticsEnabled = "analytics_enabled"
    case pushNotifications = "push_notifications"
    case biometricAuth = "biometric_auth"
    case darkModeForced = "dark_mode_forced"
    case experimentalAPI = "experimental_api"

    var defaultValue: Bool {
        switch self {
        case .newHomeDesign:
            return false
        case .enhancedSecurity:
            return true
        case .betaFeatures:
            return AppConstants.FeatureFlags.enableBetaFeatures
        case .analyticsEnabled:
            return AppConstants.FeatureFlags.enableAnalytics
        case .pushNotifications:
            return true
        case .biometricAuth:
            return true
        case .darkModeForced:
            return false
        case .experimentalAPI:
            return false
        }
    }

    var description: String {
        switch self {
        case .newHomeDesign:
            return "Enable new home screen design"
        case .enhancedSecurity:
            return "Enable enhanced security features"
        case .betaFeatures:
            return "Enable beta features for testing"
        case .analyticsEnabled:
            return "Enable analytics tracking"
        case .pushNotifications:
            return "Enable push notifications"
        case .biometricAuth:
            return "Enable biometric authentication"
        case .darkModeForced:
            return "Force dark mode appearance"
        case .experimentalAPI:
            return "Use experimental API endpoints"
        }
    }
}

/// Feature flag manager
final class FeatureFlagManager {
    static let shared = FeatureFlagManager()

    private let userDefaults = UserDefaults.standard
    private let remoteConfig: [String: Bool] = [:] // Remote config would go here

    private init() {}

    /// Check if a feature flag is enabled
    func isEnabled(_ flag: FeatureFlag) -> Bool {
        // Check remote config first
        if let remoteValue = remoteConfig[flag.rawValue] {
            return remoteValue
        }

        // Check local override
        let key = "feature_flag_\(flag.rawValue)"
        if userDefaults.object(forKey: key) != nil {
            return userDefaults.bool(forKey: key)
        }

        // Return default value
        return flag.defaultValue
    }

    /// Set local override for a feature flag
    func setEnabled(_ flag: FeatureFlag, enabled: Bool) {
        let key = "feature_flag_\(flag.rawValue)"
        userDefaults.set(enabled, forKey: key)
    }

    /// Remove local override
    func removeOverride(_ flag: FeatureFlag) {
        let key = "feature_flag_\(flag.rawValue)"
        userDefaults.removeObject(forKey: key)
    }

    /// Get all feature flags with their current values
    func getAllFlags() -> [(flag: FeatureFlag, enabled: Bool)] {
        return FeatureFlag.allCases.map { flag in
            (flag: flag, enabled: isEnabled(flag))
        }
    }
}
