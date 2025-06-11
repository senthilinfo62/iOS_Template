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
    private let themeService: ThemeServiceProtocol

    init(themeService: ThemeServiceProtocol) {
        self.themeService = themeService
    }
    
    func getCurrentTheme() -> AppTheme {
        return themeService.currentTheme
    }

    func setTheme(_ theme: AppTheme) {
        themeService.setTheme(theme)
    }

    func getAvailableThemes() -> [AppTheme] {
        return themeService.getAvailableThemes()
    }
}
