//
//  AccessibilityIdentifiers.swift
//  template
//
//  Created by iOS Advanced Setup Script
//

import Foundation

/// Centralized accessibility identifiers for UI testing and accessibility
struct AccessibilityIdentifiers {
    
    // MARK: - Navigation
    struct Navigation {
        static let homeTab = "navigation.home.tab"
        static let settingsTab = "navigation.settings.tab"
        static let backButton = "navigation.back.button"
    }
    
    // MARK: - Home Screen
    struct Home {
        static let titleLabel = "home.title.label"
        static let detailsButton = "home.details.button"
        static let settingsButton = "home.settings.button"
        static let refreshButton = "home.refresh.button"
    }
    
    // MARK: - Settings Screen
    struct Settings {
        static let themeSection = "settings.theme.section"
        static let themeSystemOption = "settings.theme.system"
        static let themeLightOption = "settings.theme.light"
        static let themeDarkOption = "settings.theme.dark"
        static let currentThemeLabel = "settings.current.theme.label"
    }
    
    // MARK: - Details Screen
    struct Details {
        static let messageLabel = "details.message.label"
        static let closeButton = "details.close.button"
    }
    
    // MARK: - Common Elements
    struct Common {
        static let loadingIndicator = "common.loading.indicator"
        static let errorAlert = "common.error.alert"
        static let successAlert = "common.success.alert"
        static let cancelButton = "common.cancel.button"
        static let confirmButton = "common.confirm.button"
    }
}
