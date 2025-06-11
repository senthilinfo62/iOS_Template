//
//  SettingsViewModel.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//

import Foundation
import SwiftUI

final class SettingsViewModel: ObservableObject {
    @Published var availableThemes: [AppTheme] = []

    private let themeUseCase: ThemeUseCaseProtocol
    private let themeManager = ThemeManager.shared

    var currentTheme: AppTheme {
        return themeUseCase.getCurrentTheme()
    }

    var selectedColorScheme: ColorScheme? {
        return themeManager.selectedColorScheme
    }

    init(themeUseCase: ThemeUseCaseProtocol? = nil) {
        if let themeUseCase = themeUseCase {
            self.themeUseCase = themeUseCase
        } else {
            // Fallback to direct ThemeManager usage
            self.themeUseCase = ThemeUseCase(themeService: ThemeManager.shared)
        }
        self.availableThemes = self.themeUseCase.getAvailableThemes()
        print("🎨 SettingsViewModel: Initialized with theme: \(currentTheme.rawValue)")
    }

    func selectTheme(_ theme: AppTheme) {
        print("🎨 SettingsViewModel: Selecting theme: \(theme.rawValue)")
        themeUseCase.setTheme(theme)
        themeManager.setTheme(theme) // Also update the manager for UI updates
    }
}
