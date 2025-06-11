//
//  PerformanceMonitor.swift
//  template
//
//  Created by iOS Advanced Setup Script
//

import Foundation
import os.log

/// Performance monitoring utility for tracking app performance
final class PerformanceMonitor {
    static let shared = PerformanceMonitor()
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.ios.template", category: "Performance")
    private var startTimes: [String: CFAbsoluteTime] = [:]
    
    private init() {}
    
    /// Start measuring performance for a specific operation
    func startMeasuring(_ operation: String) {
        startTimes[operation] = CFAbsoluteTimeGetCurrent()
        logger.info("🚀 Started measuring: \(operation)")
    }
    
    /// End measuring and log the duration
    func endMeasuring(_ operation: String) {
        guard let startTime = startTimes[operation] else {
            logger.warning("⚠️ No start time found for operation: \(operation)")
            return
        }
        
        let duration = CFAbsoluteTimeGetCurrent() - startTime
        startTimes.removeValue(forKey: operation)
        
        logger.info("✅ Completed \(operation) in \(String(format: "%.3f", duration))s")
        
        // Log warning for slow operations
        if duration > 1.0 {
            logger.warning("🐌 Slow operation detected: \(operation) took \(String(format: "%.3f", duration))s")
        }
    }
    
    /// Measure a closure execution time
    func measure<T>(_ operation: String, closure: () throws -> T) rethrows -> T {
        startMeasuring(operation)
        defer { endMeasuring(operation) }
        return try closure()
    }
    
    /// Measure async closure execution time
    func measureAsync<T>(_ operation: String, closure: () async throws -> T) async rethrows -> T {
        startMeasuring(operation)
        defer { endMeasuring(operation) }
        return try await closure()
    }
    
    /// Log memory usage
    func logMemoryUsage() {
        var memoryInfo = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &memoryInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            let memoryUsageMB = Double(memoryInfo.resident_size) / 1024.0 / 1024.0
            logger.info("📱 Memory usage: \(String(format: "%.2f", memoryUsageMB)) MB")
        }
    }
}

/// Performance measurement property wrapper
@propertyWrapper
struct Measured<T> {
    private let operation: String
    private var value: T
    
    init(wrappedValue: T, _ operation: String) {
        self.value = wrappedValue
        self.operation = operation
    }
    
    var wrappedValue: T {
        get {
            PerformanceMonitor.shared.measure(operation) {
                return value
            }
        }
        set {
            value = newValue
        }
    }
}
