//
//  Environment.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//

import Foundation

enum Environment {
    case staging
    case production
    
    static var current: Environment {
        #if STAGING
        return .staging
        #else
        return .production
        #endif
    }
    
    var baseURL: String {
        switch self {
        case .staging:
            return "https://staging-api.yourapp.com"
        case .production:
            return "https://api.yourapp.com"
        }
    }
    
    var appName: String {
        switch self {
        case .staging:
            return "Template STG"
        case .production:
            return "Template"
        }
    }
    
    var bundleIdentifier: String {
        switch self {
        case .staging:
            return "com.nexware.template.stg"
        case .production:
            return "com.nexware.template"
        }
    }
    
    var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    var analyticsEnabled: Bool {
        switch self {
        case .staging:
            return false
        case .production:
            return true
        }
    }
    
    var logLevel: LogLevel {
        switch self {
        case .staging:
            return .verbose
        case .production:
            return .error
        }
    }
}

enum LogLevel {
    case verbose
    case info
    case warning
    case error
    case none
}
