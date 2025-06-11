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
