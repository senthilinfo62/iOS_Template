//
//  SettingsView.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var viewModel: SettingsViewModel
    
    var body: some View {
        GeometryReader { geometry in
            List {
                Section {
                    ForEach(viewModel.availableThemes, id: \.rawValue) { theme in
                        ThemeRow(
                            theme: theme,
                            isSelected: theme == viewModel.currentTheme
                        ) {
                            viewModel.selectTheme(theme)
                        }
                    }
                } header: {
                    Text("THEME")
                }

                Section {
                    HStack {
                        Text("Current Theme")
                        Spacer()
                        Text(viewModel.currentTheme.displayName)
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("SETTINGS_INFO_SECTION")
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color(.systemBackground))
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
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
