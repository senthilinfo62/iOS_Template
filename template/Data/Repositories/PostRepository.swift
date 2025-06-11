//
//  PostRepository.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//

import Foundation

protocol PostRepositoryProtocol {
    func getPost(completion: @escaping (Result<Post, Error>) -> Void)
}

final class PostRepository: PostRepositoryProtocol {
    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }

    func getPost(completion: @escaping (Result<Post, Error>) -> Void) {
        apiService.fetchPost(completion: completion)
    }
}
