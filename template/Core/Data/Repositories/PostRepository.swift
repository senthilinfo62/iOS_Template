//
//  PostRepository.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//

import Foundation

protocol PostRepositoryProtocol {
    func getPost(completion: @escaping (Result<Post, APIError>) -> Void)
    func getPost(id: Int, completion: @escaping (Result<Post, APIError>) -> Void)
    func getPosts(completion: @escaping (Result<[Post], APIError>) -> Void)
    func createPost(_ post: Post, completion: @escaping (Result<Post, APIError>) -> Void)
}

/**
 * The repository for managing `Post` data.
 *
 * This class abstracts the data source, providing a clean API for
 * the Domain layer to interact with. It hides the implementation
 * details of where the data comes from (e.g., network, cache).
 *
 * It depends on the `APIServiceProtocol` to perform the actual
 * data fetching.
 */
final class PostRepository: PostRepositoryProtocol {
    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }

    func getPost(completion: @escaping (Result<Post, APIError>) -> Void) {
        apiService.fetchPost(id: 1, completion: completion)
    }

    func getPost(id: Int, completion: @escaping (Result<Post, APIError>) -> Void) {
        apiService.fetchPost(id: id, completion: completion)
    }

    func getPosts(completion: @escaping (Result<[Post], APIError>) -> Void) {
        apiService.fetchPosts(completion: completion)
    }

    func createPost(_ post: Post, completion: @escaping (Result<Post, APIError>) -> Void) {
        apiService.createPost(post, completion: completion)
    }
}
