//
//  AppConstants.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//

import Foundation

// MARK: - App Constants
struct AppConstants {

    // MARK: - Environment Detection
    private enum AppEnvironment {
        case staging
        case production

        static var current: AppEnvironment {
            #if STAGING
            return .staging
            #else
            return .production
            #endif
        }
    }

    // MARK: - Log Level
    enum LogLevel {
        case verbose
        case info
        case warning
        case error
        case none
    }
    
    // MARK: - App Information
    struct App {
        static let name = "iOS Template"
        static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        static let bundleIdentifier = Bundle.main.bundleIdentifier ?? "com.ios.template"
        static let displayName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "Template"
    }
    
    // MARK: - API Configuration
    struct API {
        // Base URLs
        static let stagingBaseURL = "https://staging-api.yourapp.com"
        static let productionBaseURL = "https://api.yourapp.com"
        static let mockBaseURL = "https://jsonplaceholder.typicode.com"
        
        // Current base URL based on environment
        static var baseURL: String {
            switch AppEnvironment.current {
            case .staging:
                return stagingBaseURL
            case .production:
                return productionBaseURL
            }
        }
        
        // API Endpoints
        struct Endpoints {
            static let posts = "/posts"
            static let users = "/users"
            static let comments = "/comments"
            static let albums = "/albums"
            static let photos = "/photos"
            static let todos = "/todos"
        }
        
        // API Keys (should be loaded from secure storage in production)
        struct Keys {
            static var apiKey: String {
                switch AppEnvironment.current {
                case .staging:
                    return Bundle.main.object(forInfoDictionaryKey: "STAGING_API_KEY") as? String ?? ""
                case .production:
                    return Bundle.main.object(forInfoDictionaryKey: "PRODUCTION_API_KEY") as? String ?? ""
                }
            }
        }
        
        // Request Configuration
        struct Request {
            static let timeoutInterval: TimeInterval = 30.0
            static let retryCount = 3
            static let retryDelay: TimeInterval = 1.0
        }
        
        // Headers
        struct Headers {
            static let contentType = "Content-Type"
            static let authorization = "Authorization"
            static let userAgent = "User-Agent"
            static let acceptLanguage = "Accept-Language"
            static let apiKeyHeader = "X-API-Key"
        }
    }
    
    // MARK: - User Defaults Keys
    struct UserDefaults {
        static let themeKey = "app_theme"
        static let languageKey = "app_language"
        static let firstLaunchKey = "app_first_launch"
        static let lastVersionKey = "app_last_version"
        static let userTokenKey = "user_token"
        static let refreshTokenKey = "refresh_token"
    }
    
    // MARK: - Notification Names
    struct Notifications {
        static let themeChanged = Notification.Name("ThemeChanged")
        static let languageChanged = Notification.Name("LanguageChanged")
        static let userLoggedIn = Notification.Name("UserLoggedIn")
        static let userLoggedOut = Notification.Name("UserLoggedOut")
        static let networkStatusChanged = Notification.Name("NetworkStatusChanged")
    }
    
    // MARK: - Animation Constants
    struct Animation {
        static let defaultDuration: TimeInterval = 0.3
        static let fastDuration: TimeInterval = 0.15
        static let slowDuration: TimeInterval = 0.5
        static let springDamping: CGFloat = 0.8
        static let springVelocity: CGFloat = 0.6
    }
    
    // MARK: - UI Constants
    struct UI {
        static let cornerRadius: CGFloat = 8.0
        static let borderWidth: CGFloat = 1.0
        static let shadowRadius: CGFloat = 4.0
        static let shadowOpacity: Float = 0.1
        
        struct Spacing {
            static let tiny: CGFloat = 4.0
            static let small: CGFloat = 8.0
            static let medium: CGFloat = 16.0
            static let large: CGFloat = 24.0
            static let extraLarge: CGFloat = 32.0
        }
        
        struct FontSize {
            static let caption: CGFloat = 12.0
            static let body: CGFloat = 16.0
            static let headline: CGFloat = 18.0
            static let title: CGFloat = 24.0
            static let largeTitle: CGFloat = 32.0
        }
    }
    
    // MARK: - Feature Flags
    struct FeatureFlags {
        static let enableAnalytics: Bool = {
            switch AppEnvironment.current {
            case .staging:
                return false
            case .production:
                return true
            }
        }()

        static let enableCrashReporting: Bool = {
            switch AppEnvironment.current {
            case .staging:
                return false
            case .production:
                return true
            }
        }()
        
        static let enableDebugLogging: Bool = {
            #if DEBUG
            return true
            #else
            return false
            #endif
        }()
        
        static let enableMockData = false
        static let enableBetaFeatures = AppEnvironment.current == .staging
    }
    
    // MARK: - Cache Configuration
    struct Cache {
        static let maxMemorySize = 50 * 1024 * 1024 // 50MB
        static let maxDiskSize = 100 * 1024 * 1024 // 100MB
        static let defaultCacheAge: TimeInterval = 3600 // 1 hour
    }
    
    // MARK: - Security
    struct Security {
        static let keychainService = bundleIdentifier
        static let biometricPrompt = "Authenticate to access the app"
        static let sessionTimeout: TimeInterval = 1800 // 30 minutes
    }
    
    // MARK: - Logging
    struct Logging {
        static let maxLogFileSize = 10 * 1024 * 1024 // 10MB
        static let maxLogFiles = 5
        static let logLevel: LogLevel = {
            switch AppEnvironment.current {
            case .staging:
                return .verbose
            case .production:
                return .error
            }
        }()
    }
    
    // MARK: - Helper Properties
    static var isFirstLaunch: Bool {
        return !Foundation.UserDefaults.standard.bool(forKey: UserDefaults.firstLaunchKey)
    }
    
    static var currentLanguage: String {
        return Foundation.UserDefaults.standard.string(forKey: UserDefaults.languageKey)
            ?? Locale.current.language.languageCode?.identifier
            ?? "en"
    }
    
    static var userAgent: String {
        let systemVersion = ProcessInfo.processInfo.operatingSystemVersionString
        return "\(App.name)/\(App.version) (\(App.bundleIdentifier); build:\(App.buildNumber); \(systemVersion))"
    }
    
    // MARK: - Bundle Identifier Helper
    private static var bundleIdentifier: String {
        return Bundle.main.bundleIdentifier ?? "com.ios.template"
    }
}
