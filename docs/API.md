# 🌐 API Integration Guide

This document provides comprehensive information about API integration, network layer architecture, and best practices for the iOS Template App.

## 📡 Network Architecture

### Overview
The app uses a layered approach for network communication:

```
┌─────────────────┐
│   ViewModel     │ ← Business Logic Layer
└─────────────────┘
         │
┌─────────────────┐
│    Use Case     │ ← Domain Layer
└─────────────────┘
         │
┌─────────────────┐
│   Repository    │ ← Data Abstraction Layer
└─────────────────┘
         │
┌─────────────────┐
│   API Service   │ ← Network Implementation Layer
└─────────────────┘
         │
┌─────────────────┐
│    Alamofire    │ ← HTTP Client Library
└─────────────────┘
```

## 🔧 Implementation Details

### API Service Layer

<augment_code_snippet path="template/Data/Network/ApiService.swift" mode="EXCERPT">
````swift
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
````
</augment_code_snippet>

### Repository Layer

<augment_code_snippet path="template/Data/Repositories/PostRepository.swift" mode="EXCERPT">
````swift
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
````
</augment_code_snippet>

## 🌍 Environment Configuration

### Base URLs

<augment_code_snippet path="template/Configuration/Environment.swift" mode="EXCERPT">
````swift
enum Environment {
    case staging
    case production
    
    var baseURL: String {
        switch self {
        case .staging:
            return "https://staging-api.yourapp.com"
        case .production:
            return "https://api.yourapp.com"
        }
    }
}
````
</augment_code_snippet>

### Environment-Specific Settings
- **Staging**: `https://staging-api.yourapp.com`
- **Production**: `https://api.yourapp.com`

## 📋 API Endpoints

### Current Endpoints

| Method | Endpoint | Description | Response |
|--------|----------|-------------|----------|
| GET | `/posts/1` | Fetch single post | `Post` object |

### Example Responses

#### GET /posts/1
```json
{
  "id": 1,
  "title": "Sample Post Title",
  "body": "Sample post content..."
}
```

## 🔒 Security

### HTTPS Configuration
- All API calls use HTTPS
- Certificate pinning (recommended for production)
- Request/response validation

### Authentication
```swift
// Example authentication header
let headers: HTTPHeaders = [
    "Authorization": "Bearer \(accessToken)",
    "Content-Type": "application/json"
]

AF.request(url, headers: headers)
```

### API Key Management
```swift
// Environment-based API key configuration
var apiKey: String {
    switch Environment.current {
    case .staging:
        return Bundle.main.object(forInfoDictionaryKey: "STAGING_API_KEY") as? String ?? ""
    case .production:
        return Bundle.main.object(forInfoDictionaryKey: "PRODUCTION_API_KEY") as? String ?? ""
    }
}
```

## 🔄 Error Handling

### Error Types
```swift
enum APIError: Error, LocalizedError {
    case networkError(Error)
    case decodingError(Error)
    case invalidResponse
    case unauthorized
    case serverError(Int)
    
    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server"
        case .unauthorized:
            return "Unauthorized access"
        case .serverError(let code):
            return "Server error with code: \(code)"
        }
    }
}
```

### Error Handling Strategy
```swift
func handleAPIResponse<T: Decodable>(
    response: DataResponse<T, AFError>,
    completion: @escaping (Result<T, APIError>) -> Void
) {
    switch response.result {
    case .success(let data):
        completion(.success(data))
    case .failure(let error):
        if let statusCode = response.response?.statusCode {
            switch statusCode {
            case 401:
                completion(.failure(.unauthorized))
            case 500...599:
                completion(.failure(.serverError(statusCode)))
            default:
                completion(.failure(.networkError(error)))
            }
        } else {
            completion(.failure(.networkError(error)))
        }
    }
}
```

## 📊 Request/Response Logging

### Debug Logging
```swift
#if DEBUG
AF.request(url)
    .cURLDescription { description in
        print("cURL: \(description)")
    }
    .responseJSON { response in
        print("Response: \(response)")
    }
#endif
```

### Production Logging
- Minimal logging for performance
- Error tracking only
- No sensitive data logging

## 🔄 Retry Mechanism

### Automatic Retry
```swift
let retryPolicy = RetryPolicy(
    retryLimit: 3,
    exponentialBackoffBase: 2,
    exponentialBackoffScale: 0.5
)

AF.request(url)
    .retry(retryPolicy)
    .responseDecodable(of: Post.self) { response in
        // Handle response
    }
```

## 📱 Offline Support

### Caching Strategy
```swift
// Response caching
let cachePolicy = URLRequest.CachePolicy.returnCacheDataElseLoad

AF.request(url)
    .cacheResponse(using: .cache)
    .responseDecodable(of: Post.self) { response in
        // Handle cached/fresh response
    }
```

### Offline Detection
```swift
import Network

class NetworkMonitor: ObservableObject {
    @Published var isConnected = true
    private let monitor = NWPathMonitor()
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: DispatchQueue.global())
    }
}
```

## 🧪 Testing

### Mock API Service
```swift
class MockAPIService: APIServiceProtocol {
    var shouldReturnError = false
    var mockPost = Post(id: 1, title: "Mock Title", body: "Mock Body")
    
    func fetchPost(completion: @escaping (Result<Post, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(APIError.networkError(NSError())))
        } else {
            completion(.success(mockPost))
        }
    }
}
```

### Unit Testing
```swift
func testFetchPostSuccess() {
    let mockService = MockAPIService()
    let repository = PostRepository(apiService: mockService)
    
    let expectation = XCTestExpectation(description: "Fetch post")
    
    repository.getPost { result in
        switch result {
        case .success(let post):
            XCTAssertEqual(post.title, "Mock Title")
        case .failure:
            XCTFail("Expected success")
        }
        expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 1.0)
}
```

## 📈 Performance Optimization

### Request Optimization
- Connection pooling
- Request deduplication
- Background data fetching
- Image caching

### Response Optimization
- JSON parsing optimization
- Memory-efficient decoding
- Streaming for large responses

## 🔮 Future Enhancements

### Planned Features
- GraphQL integration
- WebSocket support
- Advanced caching strategies
- Request/response interceptors
- Automatic token refresh

### API Versioning
```swift
enum APIVersion: String {
    case v1 = "v1"
    case v2 = "v2"
    
    var baseURL: String {
        return "\(Environment.current.baseURL)/\(rawValue)"
    }
}
```

---

This API integration guide provides a solid foundation for building robust network communication in your iOS app.
