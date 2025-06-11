//
//  NetworkLogger.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//

import Foundation
import Alamofire
import os.log

// MARK: - Network Logger
final class NetworkLogger: EventMonitor {
    let queue = DispatchQueue(label: "NetworkLogger")
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "NetworkLogger", category: "networking")
    
    func requestDidFinish(_ request: Request) {
        guard AppConstants.FeatureFlags.enableDebugLogging else { return }

        logger.info("🌐 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        logger.info("🌐 REQUEST FINISHED")
        logger.info("🌐 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        logger.info("🌐 URL: \(request.request?.url?.absoluteString ?? "Unknown")")
        logger.info("🌐 Method: \(request.request?.httpMethod ?? "Unknown")")
        logger.debug("🌐 Headers: \(String(describing: request.request?.allHTTPHeaderFields ?? [:]))")

        if let body = request.request?.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            logger.debug("🌐 Body: \(bodyString)")
        }

        logger.info("🌐 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        guard AppConstants.FeatureFlags.enableDebugLogging else { return }

        logger.info("🌐 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        logger.info("🌐 RESPONSE RECEIVED")
        logger.info("🌐 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        logger.info("🌐 URL: \(request.request?.url?.absoluteString ?? "Unknown")")
        logger.info("🌐 Status Code: \(response.response?.statusCode ?? 0)")
        logger.debug("🌐 Headers: \(String(describing: response.response?.allHeaderFields ?? [:]))")

        if let data = response.data,
           let responseString = String(data: data, encoding: .utf8) {
            logger.debug("🌐 Response: \(responseString)")
        }

        if let error = response.error {
            logger.error("🌐 Error: \(error.localizedDescription)")
        }

        logger.info("🌐 Duration: \(response.metrics?.taskInterval.duration ?? 0)s")
        logger.info("🌐 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    }
}

// MARK: - Request/Response Logging Extension
extension APIService {
    
    static func createSessionWithLogging() -> Session {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = AppConstants.API.Request.timeoutInterval
        configuration.timeoutIntervalForResource = AppConstants.API.Request.timeoutInterval * 2
        
        let logger = NetworkLogger()
        let interceptor = APIInterceptor()
        
        return Session(
            configuration: configuration,
            interceptor: interceptor,
            eventMonitors: [logger]
        )
    }
}

// MARK: - Performance Metrics
struct NetworkMetrics {
    let url: String
    let method: String
    let statusCode: Int
    let duration: TimeInterval
    let dataSize: Int
    let timestamp: Date
    
    init(from response: DataResponse<Data, AFError>) {
        self.url = response.request?.url?.absoluteString ?? "Unknown"
        self.method = response.request?.httpMethod ?? "Unknown"
        self.statusCode = response.response?.statusCode ?? 0
        self.duration = response.metrics?.taskInterval.duration ?? 0
        self.dataSize = response.data?.count ?? 0
        self.timestamp = Date()
    }
    
    var description: String {
        """
        📊 Network Metrics:
        URL: \(url)
        Method: \(method)
        Status: \(statusCode)
        Duration: \(String(format: "%.3f", duration))s
        Data Size: \(dataSize) bytes
        Timestamp: \(timestamp)
        """
    }
}

// MARK: - Network Performance Monitor
final class NetworkPerformanceMonitor {
    static let shared = NetworkPerformanceMonitor()
    private var metrics: [NetworkMetrics] = []
    private let queue = DispatchQueue(label: "NetworkPerformanceMonitor", qos: .utility)
    
    private init() {}
    
    func recordMetrics(_ metrics: NetworkMetrics) {
        queue.async {
            self.metrics.append(metrics)
            
            // Keep only last 100 metrics to prevent memory issues
            if self.metrics.count > 100 {
                self.metrics.removeFirst(self.metrics.count - 100)
            }
            
            if AppConstants.FeatureFlags.enableDebugLogging {
                Logger(subsystem: Bundle.main.bundleIdentifier ?? "NetworkPerformanceMonitor", category: "metrics")
                    .info("\(metrics.description)")
            }
        }
    }
    
    func getAverageResponseTime() -> TimeInterval {
        queue.sync {
            guard !metrics.isEmpty else { return 0 }
            let totalTime = metrics.reduce(0) { $0 + $1.duration }
            return totalTime / Double(metrics.count)
        }
    }
    
    func getMetrics() -> [NetworkMetrics] {
        queue.sync { metrics }
    }
    
    func clearMetrics() {
        queue.async {
            self.metrics.removeAll()
        }
    }
}
