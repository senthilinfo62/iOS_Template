//
//  HomeView.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject private var router: Router

    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.message)
                .font(.title)
                .padding()

            Button("Go to Details") {
                router.push(.details(message: viewModel.message))
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .onAppear {
            viewModel.loadPost()
        }
        .navigationTitle(NSLocalizedString("home_title", comment: "Home screen title"))
    }
}
