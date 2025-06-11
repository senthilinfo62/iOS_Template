//
//  MockAPIService.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//

import Foundation

final class MockAPIService: APIServiceProtocol {
    var shouldReturnError = false
    var errorType: APIError = .networkError(NSError(domain: "MockAPIService", code: 500))
    var delay: TimeInterval = 0.1

    // Mock data
    var mockPost = Post(id: 1, title: "Mock Post Title", body: "Mock post content for testing purposes", userId: 1)
    var mockPosts: [Post] = [
        Post(id: 1, title: "Mock Post 1", body: "Content 1", userId: 1),
        Post(id: 2, title: "Mock Post 2", body: "Content 2", userId: 1),
        Post(id: 3, title: "Mock Post 3", body: "Content 3", userId: 2)
    ]
    var mockUsers: [User] = [
        User(id: 1,
             name: "John Doe",
             username: "johndoe",
             email: "john@example.com",
             phone: "123-456-7890",
             website: "johndoe.com"),
        User(id: 2,
             name: "Jane Smith",
             username: "janesmith",
             email: "jane@example.com",
             phone: "098-765-4321",
             website: "janesmith.com")
    ]

    // MARK: - APIServiceProtocol Implementation
    func fetchPost(id: Int = 1, completion: @escaping (Result<Post, APIError>) -> Void) {
        simulateNetworkCall {
            if self.shouldReturnError {
                completion(.failure(self.errorType))
            } else {
                let post = self.mockPosts.first { $0.id == id } ?? self.mockPost
                completion(.success(post))
            }
        }
    }

    func fetchPosts(completion: @escaping (Result<[Post], APIError>) -> Void) {
        simulateNetworkCall {
            if self.shouldReturnError {
                completion(.failure(self.errorType))
            } else {
                completion(.success(self.mockPosts))
            }
        }
    }

    func fetchUsers(completion: @escaping (Result<[User], APIError>) -> Void) {
        simulateNetworkCall {
            if self.shouldReturnError {
                completion(.failure(self.errorType))
            } else {
                completion(.success(self.mockUsers))
            }
        }
    }

    func createPost(_ post: Post, completion: @escaping (Result<Post, APIError>) -> Void) {
        simulateNetworkCall {
            if self.shouldReturnError {
                completion(.failure(self.errorType))
            } else {
                // Simulate server assigning an ID
                let newId = (self.mockPosts.map { $0.id }.max() ?? 0) + 1
                let createdPost = Post(id: newId, title: post.title, body: post.body, userId: post.userId)
                self.mockPosts.append(createdPost)
                completion(.success(createdPost))
            }
        }
    }

    // MARK: - Test Helpers
    private func simulateNetworkCall(completion: @escaping () -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    func setMockPost(title: String, body: String, userId: Int = 1) {
        mockPost = Post(id: 1, title: title, body: body, userId: userId)
    }

    func simulateError(_ shouldError: Bool = true,
                       errorType: APIError = .networkError(NSError(domain: "MockAPIService", code: 500))) {
        shouldReturnError = shouldError
        self.errorType = errorType
    }

    func setDelay(_ delay: TimeInterval) {
        self.delay = delay
    }

    func addMockPost(_ post: Post) {
        mockPosts.append(post)
    }

    func addMockUser(_ user: User) {
        mockUsers.append(user)
    }

    func clearMockData() {
        mockPosts.removeAll()
        mockUsers.removeAll()
    }

    func resetToDefaults() {
        shouldReturnError = false
        delay = 0.1
        errorType = .networkError(NSError(domain: "MockAPIService", code: 500))
        mockPost = Post(id: 1,
                        title: "Mock Post Title",
                        body: "Mock post content for testing purposes",
                        userId: 1)
        mockPosts = [
            Post(id: 1, title: "Mock Post 1", body: "Content 1", userId: 1),
            Post(id: 2, title: "Mock Post 2", body: "Content 2", userId: 1),
            Post(id: 3, title: "Mock Post 3", body: "Content 3", userId: 2)
        ]
        mockUsers = [
            User(id: 1,
                 name: "John Doe",
                 username: "johndoe",
                 email: "john@example.com",
                 phone: "123-456-7890",
                 website: "johndoe.com"),
            User(id: 2,
                 name: "Jane Smith",
                 username: "janesmith",
                 email: "jane@example.com",
                 phone: "098-765-4321",
                 website: "janesmith.com")
        ]
    }
}
