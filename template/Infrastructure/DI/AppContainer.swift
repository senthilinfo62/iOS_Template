//
//  AppContainer.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//

import Foundation
import SwiftUI

// MARK: - Dependency Container Protocol
protocol DIContainer {
    func register<T>(_ type: T.Type, factory: @escaping () -> T)
    func register<T>(_ type: T.Type, instance: T)
    func resolve<T>(_ type: T.Type) -> T
    func resolve<T>(_ type: T.Type) -> T?
}

// MARK: - App Container Implementation
/**
 * The central dependency injection container for the application.
 *
 * This class is responsible for:
 * - Registering all services, repositories, and use cases.
 * - Resolving dependencies and injecting them where needed.
 * - Providing factory methods for creating ViewModels.
 *
 * It follows the Singleton pattern to ensure a single instance
 * is used throughout the app.
 */
final class AppContainer: DIContainer, ObservableObject {
    static let shared = AppContainer()

    private var services: [String: Any] = [:]
    private var factories: [String: () -> Any] = [:]

    private init() {
        registerDependencies()
    }

    // MARK: - Registration Methods
    func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        let key = String(describing: type)
        factories[key] = factory
    }

    func register<T>(_ type: T.Type, instance: T) {
        let key = String(describing: type)
        services[key] = instance
    }

    // MARK: - Resolution Methods
    func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)

        // Check if instance already exists
        if let service = services[key] as? T {
            return service
        }

        // Create new instance using factory
        if let factory = factories[key] {
            let instance = factory()
            guard let typedInstance = instance as? T else {
                fatalError("Dependency \(type) factory returned wrong type")
            }
            services[key] = typedInstance
            return typedInstance
        }

        fatalError("Dependency \(type) not registered")
    }

    func resolve<T>(_ type: T.Type) -> T? {
        let key = String(describing: type)

        // Check if instance already exists
        if let service = services[key] as? T {
            return service
        }

        // Create new instance using factory
        if let factory = factories[key] {
            let instance = factory()
            guard let typedInstance = instance as? T else {
                return nil
            }
            services[key] = typedInstance
            return typedInstance
        }

        return nil
    }

    // MARK: - Dependency Registration
    private func registerDependencies() {
        print("🔧 DI Container: Registering dependencies...")

        // Register Services
        registerServices()

        // Register Use Cases
        registerUseCases()

        // Register Repositories
        registerRepositories()

        print("✅ DI Container: All dependencies registered successfully")
    }

    private func registerServices() {
        // Analytics Service
        register(AnalyticsServiceProtocol.self) {
            AnalyticsManager.shared
        }

        // Security Service
        register(SecurityServiceProtocol.self) {
            SecurityManager.shared
        }

        // Theme Service
        register(ThemeServiceProtocol.self) {
            ThemeManager.shared
        }

        // API Service
        register(APIServiceProtocol.self) {
            MockAPIService()
        }

        // Push Notification Service
        register(PushNotificationServiceProtocol.self) {
            PushNotificationManager.shared
        }
    }

    private func registerUseCases() {
        // Fetch Post Use Case
        register(FetchPostUseCaseProtocol.self) {
            FetchPostUseCase(apiService: self.resolve(APIServiceProtocol.self))
        }

        // Theme Use Case
        register(ThemeUseCaseProtocol.self) {
            ThemeUseCase(themeService: self.resolve(ThemeServiceProtocol.self))
        }
    }

    private func registerRepositories() {
        // Post Repository
        register(PostRepositoryProtocol.self) {
            PostRepository(apiService: self.resolve(APIServiceProtocol.self))
        }
    }

    // MARK: - Factory Methods
    func makeHomeViewModel() -> HomeViewModel {
        let fetchPostUseCase: FetchPostUseCaseProtocol = resolve(FetchPostUseCaseProtocol.self)
        return HomeViewModel(fetchPostUseCase: fetchPostUseCase)
    }

    func makeSettingsViewModel() -> SettingsViewModel {
        let themeUseCase: ThemeUseCaseProtocol = resolve(ThemeUseCaseProtocol.self)
        return SettingsViewModel(themeUseCase: themeUseCase)
    }
}

// MARK: - Environment Object Extension
extension AppContainer {
    static var preview: AppContainer {
        let container = AppContainer()
        return container
    }
}

