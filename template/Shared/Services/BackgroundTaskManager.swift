//
//  BackgroundTaskManager.swift
//  template
//
//  Created by Complete iOS Setup Script
//

import Foundation
import BackgroundTasks
import os.log

/// Background task manager
final class BackgroundTaskManager {
    static let shared = BackgroundTaskManager()

    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.nexware.template", category: "BackgroundTasks")

    // Task identifiers (must match Info.plist)
    private let backgroundRefreshTaskID = "com.nexware.template.background-refresh"
    private let backgroundProcessingTaskID = "com.nexware.template.background-processing"

    private init() {}

    /// Register background tasks
    func registerBackgroundTasks() {
        // Register background app refresh
        BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundRefreshTaskID, using: nil) { task in
            guard let refreshTask = task as? BGAppRefreshTask else {
                self.logger.error("⏰ Invalid task type for background refresh")
                return
            }
            self.handleBackgroundRefresh(refreshTask)
        }

        // Register background processing
        BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundProcessingTaskID, using: nil) { task in
            guard let processingTask = task as? BGProcessingTask else {
                self.logger.error("⏰ Invalid task type for background processing")
                return
            }
            self.handleBackgroundProcessing(processingTask)
        }

        logger.info("⏰ Background tasks registered")
    }

    /// Schedule background refresh
    func scheduleBackgroundRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: backgroundRefreshTaskID)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // 15 minutes

        do {
            try BGTaskScheduler.shared.submit(request)
            logger.info("⏰ Background refresh scheduled")
        } catch {
            logger.error("⏰ Failed to schedule background refresh: \(error)")
        }
    }

    /// Schedule background processing
    func scheduleBackgroundProcessing() {
        let request = BGProcessingTaskRequest(identifier: backgroundProcessingTaskID)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 60) // 1 hour
        request.requiresNetworkConnectivity = true
        request.requiresExternalPower = false

        do {
            try BGTaskScheduler.shared.submit(request)
            logger.info("⏰ Background processing scheduled")
        } catch {
            logger.error("⏰ Failed to schedule background processing: \(error)")
        }
    }

    /// Handle background refresh task
    private func handleBackgroundRefresh(_ task: BGAppRefreshTask) {
        logger.info("⏰ Handling background refresh")

        // Schedule next refresh
        scheduleBackgroundRefresh()

        // Perform quick data refresh
        Task {
            do {
                // Perform lightweight data refresh
                await performQuickDataRefresh()
                task.setTaskCompleted(success: true)
                logger.info("⏰ Background refresh completed successfully")
            } catch {
                task.setTaskCompleted(success: false)
                logger.error("⏰ Background refresh failed: \(error)")
            }
        }

        // Set expiration handler
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
            self.logger.warning("⏰ Background refresh expired")
        }
    }

    /// Handle background processing task
    private func handleBackgroundProcessing(_ task: BGProcessingTask) {
        logger.info("⏰ Handling background processing")

        // Schedule next processing
        scheduleBackgroundProcessing()

        // Perform heavy processing
        Task {
            do {
                await performHeavyProcessing()
                task.setTaskCompleted(success: true)
                logger.info("⏰ Background processing completed successfully")
            } catch {
                task.setTaskCompleted(success: false)
                logger.error("⏰ Background processing failed: \(error)")
            }
        }

        // Set expiration handler
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
            self.logger.warning("⏰ Background processing expired")
        }
    }

    /// Perform quick data refresh
    private func performQuickDataRefresh() async {
        logger.info("⏰ Performing quick data refresh")

        // Implement your quick data refresh logic here
        // Example: Sync critical user data, check for urgent notifications

        try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds simulation
    }

    /// Perform heavy background processing
    private func performHeavyProcessing() async {
        logger.info("⏰ Performing heavy background processing")

        // Implement your heavy processing logic here
        // Example: Data cleanup, cache optimization, analytics upload

        try? await Task.sleep(nanoseconds: 5_000_000_000) // 5 seconds simulation
    }
}
