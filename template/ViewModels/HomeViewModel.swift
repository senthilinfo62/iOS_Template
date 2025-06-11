//
//  HomeViewModel.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//
import Foundation

final class HomeViewModel: ObservableObject {
    @Published var postTitle: String = ""
    private let fetchPostUseCase: FetchPostUseCaseProtocol

    init(fetchPostUseCase: FetchPostUseCaseProtocol = FetchPostUseCase()) {
        self.fetchPostUseCase = fetchPostUseCase
    }

    // Computed property for better abstraction
    var message: String {
        return postTitle.isEmpty ? "Loading..." : postTitle
    }

    func loadPost() {
        fetchPostUseCase.execute { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let post):
                    self?.postTitle = post.title
                case .failure(let error):
                    self?.postTitle = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
}



