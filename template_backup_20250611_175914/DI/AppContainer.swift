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
            let instance = factory() as! T
            services[key] = instance
            return instance
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
            let instance = factory() as! T
            services[key] = instance
            return instance
        }

        return nil
    }

    // MARK: - Dependency Registration
    private func registerDependencies() {
        // Dependencies will be registered here once all types are available
        // This demonstrates the DI container structure
        print("DI Container initialized - ready to register dependencies")
    }

    // MARK: - Factory Methods
    func makeHomeViewModel() -> HomeViewModel {
        // Create HomeViewModel with default dependencies for now
        // This will be updated to use proper DI resolution once all dependencies are registered
        return HomeViewModel()
    }

    func makeSettingsViewModel() -> SettingsViewModel {
        // Create SettingsViewModel (now uses ThemeManager singleton internally)
        return SettingsViewModel()
    }
}

// MARK: - Environment Object Extension
extension AppContainer {
    static var preview: AppContainer {
        let container = AppContainer()
        return container
    }
}

