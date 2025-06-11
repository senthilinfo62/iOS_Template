//
//  HomeView.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//
import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var router: Router
    @StateObject private var viewModel = HomeViewModel()

    // DI-enabled initializer (optional)
    init(viewModel: HomeViewModel? = nil) {
        if let viewModel = viewModel {
            _viewModel = StateObject(wrappedValue: viewModel)
        }
        // If no viewModel provided, use the default @StateObject initialization above
    }

    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.message)
                .font(.title)
                .padding()

            VStack(spacing: 12) {
                Button("Go to Details") {
                    router.push(.details(message: viewModel.message))
                }
                .buttonStyle(.borderedProminent)

                Button("Settings") {
                    router.push(.settings)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .onAppear {
            viewModel.loadPost()
        }
        .navigationTitle(NSLocalizedString("home_title", comment: "Home screen title"))
    }
}
