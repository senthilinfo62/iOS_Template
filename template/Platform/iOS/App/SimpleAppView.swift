//
//  SimpleAppView.swift
//  template
//
//  Simplified app view for debugging
//

import SwiftUI

struct SimpleAppView: View {
    @State private var currentTab = 0
    
    var body: some View {
        TabView(selection: $currentTab) {
            // Home Tab
            NavigationView {
                VStack(spacing: 30) {
                    Text("🏠 Home")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("iOS Template with Clean Architecture")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                    
                    VStack(spacing: 15) {
                        Button("Navigate to Details") {
                            print("Navigate to Details tapped")
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button("Open Settings") {
                            currentTab = 1
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Home")
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(0)
            
            // Settings Tab
            NavigationView {
                VStack(spacing: 30) {
                    Text("⚙️ Settings")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    VStack(spacing: 15) {
                        Button("Theme Settings") {
                            print("Theme Settings tapped")
                        }
                        .buttonStyle(.bordered)
                        
                        Button("App Preferences") {
                            print("App Preferences tapped")
                        }
                        .buttonStyle(.bordered)
                        
                        Button("About") {
                            print("About tapped")
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Settings")
            }
            .tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }
            .tag(1)
        }
        .onAppear {
            print("🚀 SimpleAppView appeared - App is working!")
        }
    }
}

#Preview {
    SimpleAppView()
}
