//
//  FullScreenAppView.swift
//  template
//
//  Complete full-screen solution for safe area issues
//

import SwiftUI

struct FullScreenAppView: View {
    @StateObject private var router = Router()
    @StateObject private var settingsViewModel = SettingsViewModel()
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        ZStack {
            // Full-screen background
            Color(.systemBackground)
                .ignoresSafeArea(.all)
            
            // Content with proper safe area handling
            VStack(spacing: 0) {
                // Status bar area
                Rectangle()
                    .fill(Color(.systemBackground))
                    .frame(height: 0)
                
                // Main content area
                NavigationStack(path: $router.path) {
                    FullScreenHomeView()
                        .navigationDestination(for: Route.self) { route in
                            switch route {
                            case .home:
                                FullScreenHomeView()
                            case .details(let message):
                                FullScreenDetailsView(message: message)
                            case .settings:
                                FullScreenSettingsView()
                                    .environmentObject(settingsViewModel)
                            }
                        }
                }
                .background(Color(.systemBackground))
                
                // Bottom safe area
                Rectangle()
                    .fill(Color(.systemBackground))
                    .frame(height: 0)
            }
        }
        .environmentObject(router)
        .preferredColorScheme(.light)
        .onAppear {
            print("🚀 FullScreenAppView appeared - App is starting...")
        }
    }
}

struct FullScreenHomeView: View {
    @EnvironmentObject private var router: Router
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea(.all)
            
            VStack(spacing: 30) {
                Spacer()
                
                Text("iOS Template")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(viewModel.message)
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                VStack(spacing: 15) {
                    Button("Go to Details") {
                        print("🔄 Details button tapped")
                        router.push(.details(message: viewModel.message))
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(width: 200)

                    Button("Settings") {
                        print("🔄 Settings button tapped")
                        router.push(.settings)
                    }
                    .buttonStyle(.bordered)
                    .frame(width: 200)
                }
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            print("🏠 FullScreenHomeView appeared")
            viewModel.loadPost()
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct FullScreenSettingsView: View {
    @EnvironmentObject private var viewModel: SettingsViewModel
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea(.all)
            
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
                    Text("THEME")
                }
                
                Section {
                    HStack {
                        Text("Current Theme")
                        Spacer()
                        Text(themeManager.currentTheme.displayName)
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("SETTINGS_INFO_SECTION")
                }
            }
            .background(Color(.systemBackground))
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct FullScreenDetailsView: View {
    let message: String
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea(.all)
            
            VStack(spacing: 20) {
                Spacer()
                
                Text("Details")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(message)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    FullScreenAppView()
}
