//
//  ThemeUseCase.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//

import Foundation
import SwiftUI

enum AppTheme: String, CaseIterable {
    case system = "system"
    case light = "light"
    case dark = "dark"
    
    var displayName: String {
        switch self {
        case .system:
            return NSLocalizedString("theme_system", comment: "System theme")
        case .light:
            return NSLocalizedString("theme_light", comment: "Light theme")
        case .dark:
            return NSLocalizedString("theme_dark", comment: "Dark theme")
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

protocol ThemeUseCaseProtocol {
    func getCurrentTheme() -> AppTheme
    func setTheme(_ theme: AppTheme)
    func getAvailableThemes() -> [AppTheme]
}

final class ThemeUseCase: ThemeUseCaseProtocol {
    private let userDefaults: UserDefaults
    private let themeKey = "app_theme"
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func getCurrentTheme() -> AppTheme {
        let themeString = userDefaults.string(forKey: themeKey) ?? AppTheme.system.rawValue
        let theme = AppTheme(rawValue: themeString) ?? .system
        print("🎨 ThemeUseCase: Getting current theme: \(theme.rawValue)")
        return theme
    }

    func setTheme(_ theme: AppTheme) {
        print("🎨 ThemeUseCase: Setting theme to: \(theme.rawValue)")
        userDefaults.set(theme.rawValue, forKey: themeKey)
        userDefaults.synchronize() // Force immediate save
    }
    
    func getAvailableThemes() -> [AppTheme] {
        return AppTheme.allCases
    }
}
