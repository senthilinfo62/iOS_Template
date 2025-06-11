//
//  AppDelegate.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//

import SwiftUI

struct AppView: View {
    @StateObject private var router = Router()
    @StateObject private var settingsViewModel = SettingsViewModel()
    @StateObject private var themeManager = ThemeManager.shared

    var body: some View {
        GeometryReader { geometry in
            NavigationStack(path: $router.path) {
                HomeView()
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .home:
                            HomeView()
                        case .details(let message):
                            DetailsView(message: message)
                        case .settings:
                            SettingsView()
                                .environmentObject(settingsViewModel)
                        }
                    }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .environmentObject(router)
        .preferredColorScheme(.light)
        .background(Color(.systemBackground))
        .ignoresSafeArea(.all)
        .onAppear {
            print("🚀 AppView appeared - App is starting...")
        }
    }
}



