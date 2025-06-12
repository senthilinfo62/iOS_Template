//
//  HomeViewModel.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//
import Foundation

/**
 * The ViewModel for the `HomeView`.
 *
 * This class is responsible for:
 * - Managing the state of the `HomeView`.
 * - Executing the `FetchPostUseCase` to load data.
 * - Handling the results and updating its `@Published` properties.
 *
 * The `HomeView` observes these properties and updates the UI accordingly.
 */
final class HomeViewModel: ObservableObject {
    @Published var postTitle: String = "Welcome to iOS Template!"
    @Published var isLoading: Bool = false

    private let fetchPostUseCase: FetchPostUseCaseProtocol

    init(fetchPostUseCase: FetchPostUseCaseProtocol? = nil) {
        if let fetchPostUseCase = fetchPostUseCase {
            self.fetchPostUseCase = fetchPostUseCase
        } else {
            // Fallback to direct API service usage
            self.fetchPostUseCase = FetchPostUseCase(apiService: MockAPIService())
        }
    }

    // Computed property for better abstraction
    var message: String {
        return isLoading ? "Loading..." : postTitle
    }

    func loadPost() {
        print("🔄 HomeViewModel: Loading post...")
        isLoading = true

        fetchPostUseCase.execute { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let post):
                    self?.postTitle = post.title
                    print("✅ HomeViewModel: Post loaded successfully")
                case .failure(let error):
                    self?.postTitle = "Error: \(error.localizedDescription)"
                    print("❌ HomeViewModel: Failed to load post - \(error)")
                }
            }
        }
    }

    func loadPost(id: Int) {
        print("🔄 HomeViewModel: Loading post with ID: \(id)")
        isLoading = true

        fetchPostUseCase.execute(id: id) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let post):
                    self?.postTitle = post.title
                    print("✅ HomeViewModel: Post \(id) loaded successfully")
                case .failure(let error):
                    self?.postTitle = "Error: \(error.localizedDescription)"
                    print("❌ HomeViewModel: Failed to load post \(id) - \(error)")
                }
            }
        }
    }
}



