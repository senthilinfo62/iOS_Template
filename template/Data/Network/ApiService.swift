//
//  ApiService.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//

import Foundation
import Alamofire

struct Post: Decodable {
    let id: Int
    let title: String
    let body: String
}

protocol APIServiceProtocol {
    func fetchPost(completion: @escaping (Result<Post, Error>) -> Void)
}

final class APIService: APIServiceProtocol {
    func fetchPost(completion: @escaping (Result<Post, Error>) -> Void) {
        let url = "https://jsonplaceholder.typicode.com/posts/1"

        AF.request(url)
            .validate()
            .responseDecodable(of: Post.self) { response in
                switch response.result {
                case .success(let post):
                    completion(.success(post))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
