//
//  ThemeManager.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//

import Foundation
import SwiftUI
import Combine

// MARK: - Theme Service Protocol
protocol ThemeServiceProtocol {
    var currentTheme: AppTheme { get }
    func setTheme(_ theme: AppTheme)
    func getAvailableThemes() -> [AppTheme]
}

/// Global theme manager that provides app-wide theme state
final class ThemeManager: ObservableObject, ThemeServiceProtocol {
    static let shared = ThemeManager()
    
    @Published var currentTheme: AppTheme {
        didSet {
            print("🎨 ThemeManager: Theme changed to \(currentTheme.rawValue)")
            userDefaults.set(currentTheme.rawValue, forKey: themeKey)
            userDefaults.synchronize()

            // Force UI update by triggering objectWillChange
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let userDefaults = UserDefaults.standard
    private let themeKey = "app_theme"

    private init() {
        let themeString = userDefaults.string(forKey: themeKey) ?? AppTheme.system.rawValue
        self.currentTheme = AppTheme(rawValue: themeString) ?? .system
        
        print("🎨 ThemeManager: Initialized with theme: \(currentTheme.rawValue)")
        
        // Listen for theme changes from other sources (like system settings)
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .sink { [weak self] _ in
                self?.refreshTheme()
            }
            .store(in: &cancellables)
    }
    
    var selectedColorScheme: ColorScheme? {
        let scheme = currentTheme.colorScheme
        print("🎨 ThemeManager: selectedColorScheme = \(scheme == .light ? "light" : scheme == .dark ? "dark" : "system")")
        return scheme
    }
    
    func setTheme(_ theme: AppTheme) {
        print("🎨 ThemeManager: Setting theme to \(theme.rawValue)")
        currentTheme = theme
    }
    
    func getAvailableThemes() -> [AppTheme] {
        return AppTheme.allCases
    }

    private func refreshTheme() {
        let themeString = userDefaults.string(forKey: themeKey) ?? AppTheme.system.rawValue
        let savedTheme = AppTheme(rawValue: themeString) ?? .system
        if savedTheme != currentTheme {
            print("🎨 ThemeManager: Refreshing theme from \(currentTheme.rawValue) to \(savedTheme.rawValue)")
            currentTheme = savedTheme
        }
    }
}
