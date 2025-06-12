//
//  HomeView.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//
import SwiftUI

/**
 * The main view of the application.
 *
 * This view is responsible for:
 * - Displaying the UI to the user.
 * - Delegating user actions to the `HomeViewModel`.
 * - Using the `Router` to navigate to other views.
 *
 * It receives its dependencies (`HomeViewModel`, `Router`) via
 * dependency injection and the environment.
 */
struct HomeView: View {
    @EnvironmentObject private var router: Router
    @StateObject private var viewModel: HomeViewModel

    // DI-enabled initializer
    init(viewModel: HomeViewModel? = nil) {
        if let viewModel = viewModel {
            _viewModel = StateObject(wrappedValue: viewModel)
        } else {
            // Use DI container to create ViewModel
            _viewModel = StateObject(wrappedValue: AppContainer.shared.makeHomeViewModel())
        }
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                Spacer()

                Text("iOS Template")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                Text(viewModel.message)
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()

                VStack(spacing: 12) {
                    Button("Go to Details") {
                        print("🔄 Details button tapped")
                        router.push(.details(message: viewModel.message))
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Settings") {
                        print("🔄 Settings button tapped")
                        router.push(.settings)
                    }
                    .buttonStyle(.bordered)
                }

                Spacer()
            }
            .padding()
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color(.systemBackground))
        }
        .onAppear {
            print("🏠 HomeView appeared")
            viewModel.loadPost()
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.large)
    }
}
