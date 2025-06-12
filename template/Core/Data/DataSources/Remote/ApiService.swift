//
//  ApiService.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//

import Foundation
import Alamofire
import Network
import os.log

// MARK: - Data Models
struct Post: Codable {
    let id: Int
    let title: String
    let body: String
    let userId: Int?
}

struct User: Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let phone: String?
    let website: String?
}

// MARK: - API Error Types
enum APIError: Error, LocalizedError {
    case networkError(Error)
    case decodingError(Error)
    case invalidResponse
    case unauthorized
    case forbidden
    case notFound
    case serverError(Int)
    case noInternetConnection
    case timeout
    case unknown

    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Data parsing error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server"
        case .unauthorized:
            return "Unauthorized access"
        case .forbidden:
            return "Access forbidden"
        case .notFound:
            return "Resource not found"
        case .serverError(let code):
            return "Server error (Code: \(code))"
        case .noInternetConnection:
            return "No internet connection"
        case .timeout:
            return "Request timeout"
        case .unknown:
            return "Unknown error occurred"
        }
    }
}

// MARK: - API Service Protocol
protocol APIServiceProtocol {
    func fetchPost(id: Int, completion: @escaping (Result<Post, APIError>) -> Void)
    func fetchPosts(completion: @escaping (Result<[Post], APIError>) -> Void)
    func fetchUsers(completion: @escaping (Result<[User], APIError>) -> Void)
    func createPost(_ post: Post, completion: @escaping (Result<Post, APIError>) -> Void)
}

// MARK: - Enhanced API Service
/**
 * The `APIService` handles all network communication.
 *
 * This class is responsible for:
 * - Making HTTP requests using Alamofire.
 * - Handling responses and decoding them into Swift objects.
 * - Managing network-related errors.
 * - Implementing advanced features like request retries.
 */
final class APIService: APIServiceProtocol {

    // MARK: - Properties
    private let session: Session
    private let baseURL: String
    private let networkMonitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "NetworkMonitor")
    private var isConnected = true
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "APIService", category: "networking")

    // MARK: - Initialization
    init(baseURL: String = AppConstants.API.baseURL) {
        self.baseURL = baseURL

        // Configure session with custom settings
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = AppConstants.API.Request.timeoutInterval
        configuration.timeoutIntervalForResource = AppConstants.API.Request.timeoutInterval * 2
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData

        // Create session with interceptor for retry logic
        let interceptor = APIInterceptor()
        self.session = Session(configuration: configuration, interceptor: interceptor)

        // Start network monitoring
        startNetworkMonitoring()

        if AppConstants.FeatureFlags.enableDebugLogging {
            logger.info("🌐 APIService initialized with baseURL: \(baseURL)")
        }
    }

    deinit {
        networkMonitor.cancel()
    }

    // MARK: - Network Monitoring
    private func startNetworkMonitoring() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            if AppConstants.FeatureFlags.enableDebugLogging {
                self?.logger.info("🌐 Network status: \(path.status == .satisfied ? "Connected" : "Disconnected")")
            }
        }
        networkMonitor.start(queue: monitorQueue)
    }

    // MARK: - API Methods
    func fetchPost(id: Int = 1, completion: @escaping (Result<Post, APIError>) -> Void) {
        guard isConnected else {
            completion(.failure(.noInternetConnection))
            return
        }

        let endpoint = "\(baseURL)\(AppConstants.API.Endpoints.posts)/\(id)"

        if AppConstants.FeatureFlags.enableDebugLogging {
            logger.info("🌐 Fetching post from: \(endpoint)")
        }

        session.request(endpoint, headers: defaultHeaders())
            .validate()
            .responseDecodable(of: Post.self) { response in
                self.handleResponse(response, completion: completion)
            }
    }

    func fetchPosts(completion: @escaping (Result<[Post], APIError>) -> Void) {
        guard isConnected else {
            completion(.failure(.noInternetConnection))
            return
        }

        let endpoint = "\(baseURL)\(AppConstants.API.Endpoints.posts)"

        if AppConstants.FeatureFlags.enableDebugLogging {
            logger.info("🌐 Fetching posts from: \(endpoint)")
        }

        session.request(endpoint, headers: defaultHeaders())
            .validate()
            .responseDecodable(of: [Post].self) { response in
                self.handleResponse(response, completion: completion)
            }
    }

    func fetchUsers(completion: @escaping (Result<[User], APIError>) -> Void) {
        guard isConnected else {
            completion(.failure(.noInternetConnection))
            return
        }

        let endpoint = "\(baseURL)\(AppConstants.API.Endpoints.users)"

        if AppConstants.FeatureFlags.enableDebugLogging {
            logger.info("🌐 Fetching users from: \(endpoint)")
        }

        session.request(endpoint, headers: defaultHeaders())
            .validate()
            .responseDecodable(of: [User].self) { response in
                self.handleResponse(response, completion: completion)
            }
    }

    func createPost(_ post: Post, completion: @escaping (Result<Post, APIError>) -> Void) {
        guard isConnected else {
            completion(.failure(.noInternetConnection))
            return
        }

        let endpoint = "\(baseURL)\(AppConstants.API.Endpoints.posts)"

        if AppConstants.FeatureFlags.enableDebugLogging {
            logger.info("🌐 Creating post at: \(endpoint)")
        }

        session.request(endpoint,
                       method: .post,
                       parameters: post,
                       encoder: JSONParameterEncoder.default,
                       headers: defaultHeaders())
            .validate()
            .responseDecodable(of: Post.self) { response in
                self.handleResponse(response, completion: completion)
            }
    }

    // MARK: - Helper Methods
    private func defaultHeaders() -> HTTPHeaders {
        var headers: HTTPHeaders = [
            AppConstants.API.Headers.contentType: "application/json",
            AppConstants.API.Headers.userAgent: AppConstants.userAgent,
            AppConstants.API.Headers.acceptLanguage: AppConstants.currentLanguage
        ]

        // Add API key if available
        let apiKey = AppConstants.API.Keys.apiKey
        if !apiKey.isEmpty {
            headers[AppConstants.API.Headers.apiKeyHeader] = apiKey
        }

        // Add authorization token if available
        if let token = getAuthToken() {
            headers[AppConstants.API.Headers.authorization] = "Bearer \(token)"
        }

        return headers
    }

    private func getAuthToken() -> String? {
        return UserDefaults.standard.string(forKey: AppConstants.UserDefaults.userTokenKey)
    }

    private func handleResponse<T: Decodable>(_ response: DataResponse<T, AFError>, completion: @escaping (Result<T, APIError>) -> Void) {
        if AppConstants.FeatureFlags.enableDebugLogging {
            logger.info("🌐 Response status: \(response.response?.statusCode ?? 0)")
            if let data = response.data, let string = String(data: data, encoding: .utf8) {
                logger.debug("🌐 Response data: \(string)")
            }
        }

        switch response.result {
        case .success(let data):
            completion(.success(data))

        case .failure(let error):
            let apiError = mapAlamofireError(error, statusCode: response.response?.statusCode)

            if AppConstants.FeatureFlags.enableDebugLogging {
                logger.error("🌐 API Error: \(apiError.localizedDescription)")
            }

            completion(.failure(apiError))
        }
    }

    private func mapAlamofireError(_ error: AFError, statusCode: Int?) -> APIError {
        switch error {
        case .sessionTaskFailed(let sessionError):
            if let urlError = sessionError as? URLError {
                switch urlError.code {
                case .notConnectedToInternet, .networkConnectionLost:
                    return .noInternetConnection
                case .timedOut:
                    return .timeout
                default:
                    return .networkError(urlError)
                }
            }
            return .networkError(sessionError)

        case .responseSerializationFailed(let reason):
            if case .decodingFailed(let decodingError) = reason {
                return .decodingError(decodingError)
            }
            return .decodingError(error)

        case .responseValidationFailed(let reason):
            if case .unacceptableStatusCode(let code) = reason {
                switch code {
                case 401:
                    return .unauthorized
                case 403:
                    return .forbidden
                case 404:
                    return .notFound
                case 500...599:
                    return .serverError(code)
                default:
                    return .invalidResponse
                }
            }
            return .invalidResponse

        default:
            return .unknown
        }
    }
}

// MARK: - API Interceptor for Retry Logic
final class APIInterceptor: RequestInterceptor {

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        let retryCount = AppConstants.API.Request.retryCount
        let retryDelay = AppConstants.API.Request.retryDelay

        guard request.retryCount < retryCount else {
            completion(.doNotRetry)
            return
        }

        // Only retry for specific error types
        if let afError = error as? AFError {
            switch afError {
            case .sessionTaskFailed(let sessionError):
                if let urlError = sessionError as? URLError {
                    switch urlError.code {
                    case .timedOut, .networkConnectionLost, .cannotConnectToHost:
                        if AppConstants.FeatureFlags.enableDebugLogging {
                            Logger(subsystem: Bundle.main.bundleIdentifier ?? "APIService", category: "retry")
                                .info("🌐 Retrying request (attempt \(request.retryCount + 1)/\(retryCount))")
                        }
                        completion(.retryWithDelay(retryDelay))
                        return
                    default:
                        break
                    }
                }
            default:
                break
            }
        }

        completion(.doNotRetry)
    }
}
