//
//  TabBasedAppView.swift
//  template
//
//  Alternative tab-based navigation for better safe area handling
//

import SwiftUI

struct TabBasedAppView: View {
    @StateObject private var settingsViewModel = SettingsViewModel()
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        TabView {
            // Home Tab
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            
            // Settings Tab
            NavigationStack {
                SettingsView()
                    .environmentObject(settingsViewModel)
            }
            .tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }
        }
        .preferredColorScheme(.light)
        .onAppear {
            print("🚀 TabBasedAppView appeared - App is starting...")
        }
    }
}

#Preview {
    TabBasedAppView()
}
