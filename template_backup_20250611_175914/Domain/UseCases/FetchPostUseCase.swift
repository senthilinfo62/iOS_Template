//
//  FetchPostUseCase.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//

import Foundation

protocol FetchPostUseCaseProtocol {
    func execute(completion: @escaping (Result<Post, APIError>) -> Void)
    func execute(id: Int, completion: @escaping (Result<Post, APIError>) -> Void)
}

struct FetchPostUseCase: FetchPostUseCaseProtocol {
    private let repository: PostRepositoryProtocol

    init(repository: PostRepositoryProtocol = PostRepository()) {
        self.repository = repository
    }

    func execute(completion: @escaping (Result<Post, APIError>) -> Void) {
        repository.getPost(completion: completion)
    }

    func execute(id: Int, completion: @escaping (Result<Post, APIError>) -> Void) {
        repository.getPost(id: id, completion: completion)
    }
}
