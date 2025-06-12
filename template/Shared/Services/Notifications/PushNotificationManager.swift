//
//  PushNotificationManager.swift
//  template
//
//  Created by Complete iOS Setup Script
//

import Foundation
import UserNotifications
import UIKit
import os.log

// MARK: - Push Notification Service Protocol
protocol PushNotificationServiceProtocol {
    func requestPermission()
    func registerForRemoteNotifications()
    func handleNotification(_ notification: [AnyHashable: Any])
}

/// Push notification manager
final class PushNotificationManager: NSObject, PushNotificationServiceProtocol {
    static let shared = PushNotificationManager()

    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.nexware.template", category: "PushNotifications")
    private let userDefaults = UserDefaults.standard

    private override init() {
        super.init()
    }

    /// Request notification permissions
    func requestPermissions() async -> Bool {
        let center = UNUserNotificationCenter.current()

        do {
            let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound])
            logger.info("📱 Notification permission granted: \(granted)")

            if granted {
                await performRemoteNotificationRegistration()
            }

            return granted
        } catch {
            logger.error("❌ Failed to request notification permissions: \(error)")
            return false
        }
    }

    /// Register for remote notifications
    @MainActor
    private func performRemoteNotificationRegistration() {
        UIApplication.shared.registerForRemoteNotifications()
    }

    /// Handle device token registration
    func didRegisterForRemoteNotifications(withDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        logger.info("📱 Device token: \(tokenString)")

        // Store token for API registration
        userDefaults.set(tokenString, forKey: "device_token")

        // Send token to your server
        Task {
            await sendTokenToServer(tokenString)
        }
    }

    /// Handle registration failure
    func didFailToRegisterForRemoteNotifications(withError error: Error) {
        logger.error("❌ Failed to register for remote notifications: \(error)")
    }

    /// Send token to server
    private func sendTokenToServer(_ token: String) async {
        // Implement your server API call here
        logger.info("📤 Sending device token to server: \(token)")
    }

    /// Schedule local notification
    func scheduleLocalNotification(title: String, body: String, timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                self.logger.error("❌ Failed to schedule notification: \(error)")
            } else {
                self.logger.info("✅ Local notification scheduled")
            }
        }
    }

    /// Handle received notification
    func handleReceivedNotification(_ userInfo: [AnyHashable: Any]) {
        logger.info("📱 Received notification: \(userInfo)")

        // Parse notification payload
        if let aps = userInfo["aps"] as? [String: Any] {
            if let alert = aps["alert"] as? [String: Any] {
                let title = alert["title"] as? String ?? ""
                let body = alert["body"] as? String ?? ""
                logger.info("📱 Notification - Title: \(title), Body: \(body)")
            }
        }

        // Handle custom data
        if let customData = userInfo["custom_data"] as? [String: Any] {
            handleCustomNotificationData(customData)
        }
    }

    // MARK: - PushNotificationServiceProtocol Implementation

    func requestPermission() {
        Task {
            _ = await requestPermissions()
        }
    }

    func registerForRemoteNotifications() {
        Task {
            await performRemoteNotificationRegistration()
        }
    }

    func handleNotification(_ notification: [AnyHashable: Any]) {
        handleReceivedNotification(notification)
    }

    /// Handle custom notification data
    private func handleCustomNotificationData(_ data: [String: Any]) {
        logger.info("📱 Custom notification data: \(data)")

        // Implement your custom notification handling here
        if let action = data["action"] as? String {
            switch action {
            case "open_screen":
                if let screen = data["screen"] as? String {
                    // Navigate to specific screen
                    logger.info("📱 Navigate to screen: \(screen)")
                }
            case "update_data":
                // Refresh app data
                logger.info("📱 Refreshing app data")
            default:
                logger.info("📱 Unknown notification action: \(action)")
            }
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension PushNotificationManager: UNUserNotificationCenterDelegate {

    /// Handle notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        logger.info("📱 Notification received in foreground")
        handleReceivedNotification(notification.request.content.userInfo)

        // Show notification even when app is in foreground
        completionHandler([.alert, .badge, .sound])
    }

    /// Handle notification tap
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {

        logger.info("📱 Notification tapped")
        handleReceivedNotification(response.notification.request.content.userInfo)

        completionHandler()
    }
}
