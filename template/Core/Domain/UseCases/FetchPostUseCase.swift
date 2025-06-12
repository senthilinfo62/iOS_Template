//
//  FetchPostUseCase.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//

import Foundation

protocol FetchPostUseCaseProtocol {
    func execute(completion: @escaping (Result<Post, Error>) -> Void)
    func execute(id: Int, completion: @escaping (Result<Post, Error>) -> Void)
}

/**
 * The use case for fetching a post.
 *
 * This class contains the specific business logic for this operation.
 * It acts as a bridge between the `HomeViewModel` and the `PostRepository`.
 *
 * By encapsulating the business logic here, we keep the ViewModel
 * clean and focused on presentation.
 */
final class FetchPostUseCase: FetchPostUseCaseProtocol {
    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

    func execute(completion: @escaping (Result<Post, Error>) -> Void) {
        execute(id: 1, completion: completion)
    }

    func execute(id: Int, completion: @escaping (Result<Post, Error>) -> Void) {
        apiService.fetchPost(id: id) { result in
            switch result {
            case .success(let post):
                completion(.success(post))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
