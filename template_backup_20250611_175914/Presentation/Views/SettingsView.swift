//
//  SettingsView.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var viewModel: SettingsViewModel
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(viewModel.availableThemes, id: \.rawValue) { theme in
                        ThemeRow(
                            theme: theme,
                            isSelected: theme == themeManager.currentTheme
                        ) {
                            viewModel.selectTheme(theme)
                        }
                    }
                } header: {
                    Text(NSLocalizedString("settings_theme_section", comment: "Theme section"))
                }
                
                Section {
                    HStack {
                        Text(NSLocalizedString("settings_current_theme", comment: "Current theme"))
                        Spacer()
                        Text(themeManager.currentTheme.displayName)
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text(NSLocalizedString("settings_info_section", comment: "Info section"))
                }
            }
            .navigationTitle(NSLocalizedString("settings_title", comment: "Settings title"))
        }
    }
}

struct ThemeRow: View {
    let theme: AppTheme
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(theme.displayName)
                        .foregroundColor(.primary)
                    
                    Text(themeDescription)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.accentColor)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var themeDescription: String {
        switch theme {
        case .system:
            return NSLocalizedString("theme_system_description", comment: "System theme description")
        case .light:
            return NSLocalizedString("theme_light_description", comment: "Light theme description")
        case .dark:
            return NSLocalizedString("theme_dark_description", comment: "Dark theme description")
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SettingsViewModel())
}
