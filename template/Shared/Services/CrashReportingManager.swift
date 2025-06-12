//
//  CrashReportingManager.swift
//  template
//
//  Created by Complete iOS Setup Script
//

import Foundation
import os.log

/// Crash reporting manager
final class CrashReportingManager {
    static let shared = CrashReportingManager()

    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.nexware.template", category: "CrashReporting")
    private let isEnabled: Bool

    private init() {
        self.isEnabled = AppConstants.FeatureFlags.enableCrashReporting
        logger.info("💥 Crash reporting initialized - Enabled: \(self.isEnabled)")
    }

    /// Initialize crash reporting
    func initialize() {
        guard isEnabled else {
            logger.info("💥 Crash reporting disabled")
            return
        }

        // Initialize Firebase Crashlytics
        initializeFirebaseCrashlytics()

        // Initialize Sentry (alternative)
        initializeSentry()

        // Set up custom exception handler
        setupCustomExceptionHandler()

        logger.info("💥 Crash reporting initialized")
    }

    /// Log non-fatal error
    func logError(_ error: Error, userInfo: [String: Any] = [:]) {
        guard isEnabled else { return }

        logger.error("💥 Non-fatal error: \(error.localizedDescription)")

        // Log to Firebase Crashlytics
        // Crashlytics.crashlytics().record(error: error, userInfo: userInfo)

        // Log to Sentry
        // SentrySDK.capture(error: error) { scope in
        //     scope.setContext(value: userInfo, key: "user_info")
        // }
    }

    /// Log custom message
    func logMessage(_ message: String, level: CrashLogLevel = .info) {
        guard isEnabled else { return }

        logger.log(level: OSLogType.from(level), "💥 Custom log: \(message)")

        // Log to Firebase Crashlytics
        // Crashlytics.crashlytics().log(message)

        // Log to Sentry
        // SentrySDK.addBreadcrumb(crumb: Breadcrumb(message: message, category: "custom"))
    }

    /// Set user identifier
    func setUserIdentifier(_ identifier: String) {
        guard isEnabled else { return }

        logger.info("💥 Setting user identifier: \(identifier)")

        // Set user ID in Firebase Crashlytics
        // Crashlytics.crashlytics().setUserID(identifier)

        // Set user in Sentry
        // SentrySDK.setUser(User(userId: identifier))
    }

    /// Set custom key-value pair
    func setCustomValue(_ value: Any, forKey key: String) {
        guard isEnabled else { return }

        logger.info("💥 Setting custom value: \(key) = \(String(describing: value))")

        // Set custom key in Firebase Crashlytics
        // Crashlytics.crashlytics().setCustomValue(value, forKey: key)

        // Set tag in Sentry
        // SentrySDK.setTag(value: String(describing: value), key: key)
    }

    /// Force a crash (for testing only)
    func forceCrash() {
        #if DEBUG
        logger.warning("💥 Forcing crash for testing")
        fatalError("Test crash triggered")
        #else
        logger.warning("💥 Force crash called in production - ignoring")
        #endif
    }

    // MARK: - Private Methods

    private func initializeFirebaseCrashlytics() {
        // Firebase Crashlytics initialization
        // FirebaseApp.configure()
        // Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        logger.debug("💥 Firebase Crashlytics would be initialized here")
    }

    private func initializeSentry() {
        // Sentry initialization
        // SentrySDK.start { options in
        //     options.dsn = "YOUR_SENTRY_DSN"
        //     options.debug = AppConstants.FeatureFlags.enableDebugLogging
        // }
        logger.debug("💥 Sentry would be initialized here")
    }

    private func setupCustomExceptionHandler() {
        NSSetUncaughtExceptionHandler { exception in
            CrashReportingManager.shared.logger.error("💥 Uncaught exception: \(exception)")

            // Log to crash reporting services
            // Crashlytics.crashlytics().record(exceptionModel: ExceptionModel(name: exception.name.rawValue, reason: exception.reason))
        }
    }
}

// MARK: - Log Level Extension
// MARK: - Log Level enum
enum CrashLogLevel {
    case verbose
    case info
    case warning
    case error
    case none
}

extension OSLogType {
    static func from(_ level: CrashLogLevel) -> OSLogType {
        switch level {
        case .verbose:
            return .debug
        case .info:
            return .info
        case .warning:
            return .default
        case .error:
            return .error
        case .none:
            return .fault
        }
    }
}
