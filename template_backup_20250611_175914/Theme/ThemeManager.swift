//
//  ThemeManager.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//

import Foundation
import SwiftUI
import Combine

/// Global theme manager that provides app-wide theme state
final class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var currentTheme: AppTheme {
        didSet {
            print("🎨 ThemeManager: Theme changed to \(currentTheme.rawValue)")
            themeUseCase.setTheme(currentTheme)

            // Force UI update by triggering objectWillChange
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    
    private let themeUseCase: ThemeUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        self.themeUseCase = ThemeUseCase()
        self.currentTheme = themeUseCase.getCurrentTheme()
        
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
        return themeUseCase.getAvailableThemes()
    }
    
    private func refreshTheme() {
        let savedTheme = themeUseCase.getCurrentTheme()
        if savedTheme != currentTheme {
            print("🎨 ThemeManager: Refreshing theme from \(currentTheme.rawValue) to \(savedTheme.rawValue)")
            currentTheme = savedTheme
        }
    }
}
