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

    private let themeManager = ThemeManager.shared

    var currentTheme: AppTheme {
        return themeManager.currentTheme
    }

    var selectedColorScheme: ColorScheme? {
        return themeManager.selectedColorScheme
    }

    init() {
        self.availableThemes = themeManager.getAvailableThemes()
        print("🎨 SettingsViewModel: Initialized with theme: \(currentTheme.rawValue)")
    }

    func selectTheme(_ theme: AppTheme) {
        print("🎨 SettingsViewModel: Selecting theme: \(theme.rawValue)")
        themeManager.setTheme(theme)
    }
}
