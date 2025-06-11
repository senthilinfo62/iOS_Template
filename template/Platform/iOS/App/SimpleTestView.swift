//
//  SimpleTestView.swift
//  template
//
//  Created for debugging black screen issue
//

import SwiftUI

struct SimpleTestView: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("🎉 iOS Template")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            Text("Clean Architecture")
                .font(.title)
                .foregroundColor(.secondary)
            
            Text("App is working correctly!")
                .font(.body)
                .foregroundColor(.green)
            
            Button("Test Button") {
                print("✅ Button tapped - UI is responsive")
            }
            .buttonStyle(.borderedProminent)
            .padding()
            
            Rectangle()
                .fill(Color.blue.opacity(0.3))
                .frame(width: 200, height: 100)
                .overlay(
                    Text("Test Rectangle")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                )
                .cornerRadius(10)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .onAppear {
            print("🎯 SimpleTestView appeared - UI is loading correctly")
        }
    }
}

#Preview {
    SimpleTestView()
}
