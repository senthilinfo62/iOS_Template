# 🔧 Dependency Injection Guide

This document explains the dependency injection (DI) system implemented in the iOS Template App, providing a comprehensive guide on how to use and extend it.

## 📋 Overview

The app uses a custom dependency injection container (`AppContainer`) that manages all dependencies throughout the application lifecycle. This ensures loose coupling, better testability, and easier maintenance.

## 🏗️ Architecture

### DI Container Structure
```
AppContainer (Singleton)
├── Service Registration
├── Factory Registration  
├── Instance Resolution
└── ViewModel Factories
```

### Dependency Graph
```
ViewModels
    ↓ (depends on)
Use Cases
    ↓ (depends on)
Repositories
    ↓ (depends on)
API Services
```

## 🔧 Implementation Details

### Core DI Container

<augment_code_snippet path="template/DI/AppContainer.swift" mode="EXCERPT">
````swift
protocol DIContainer {
    func register<T>(_ type: T.Type, factory: @escaping () -> T)
    func register<T>(_ type: T.Type, instance: T)
    func resolve<T>(_ type: T.Type) -> T
}

final class AppContainer: DIContainer, ObservableObject {
    static let shared = AppContainer()
    
    private var services: [String: Any] = [:]
    private var factories: [String: () -> Any] = [:]
}
````
</augment_code_snippet>

### Registration Methods

#### Factory Registration
```swift
// Register with factory (lazy instantiation)
container.register(APIServiceProtocol.self) {
    APIService()
}
```

#### Instance Registration
```swift
// Register with instance (immediate)
container.register(APIServiceProtocol.self, instance: APIService())
```

### Resolution Methods

#### Required Resolution
```swift
// Throws fatal error if not found
let apiService = container.resolve(APIServiceProtocol.self)
```

#### Optional Resolution
```swift
// Returns nil if not found
let apiService: APIServiceProtocol? = container.resolve(APIServiceProtocol.self)
```

## 📦 Registered Dependencies

### Network Layer
- `APIServiceProtocol` → `APIService`
- `MockAPIService` (for testing)

### Repository Layer
- `PostRepositoryProtocol` → `PostRepository`
- `MessageRepositoryProtocol` → `MessageRepository`

### Use Cases
- `FetchPostUseCaseProtocol` → `FetchPostUseCase`
- `MessageFetching` → `FetchMessageUseCase`
- `ThemeUseCaseProtocol` → `ThemeUseCase`

### ViewModels
- `HomeViewModel` (via factory)
- `SettingsViewModel` (via factory)

## 🎯 Usage Examples

### In ViewModels

<augment_code_snippet path="template/ViewModels/HomeViewModel.swift" mode="EXCERPT">
````swift
final class HomeViewModel: ObservableObject {
    private let fetchPostUseCase: FetchPostUseCaseProtocol

    init(fetchPostUseCase: FetchPostUseCaseProtocol) {
        self.fetchPostUseCase = fetchPostUseCase
    }
}
````
</augment_code_snippet>

### In Views

<augment_code_snippet path="template/Presentation/Views/HomeView.swift" mode="EXCERPT">
````swift
struct HomeView: View {
    @EnvironmentObject private var container: AppContainer
    @StateObject private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel? = nil) {
        if let viewModel = viewModel {
            _viewModel = StateObject(wrappedValue: viewModel)
        } else {
            _viewModel = StateObject(wrappedValue: AppContainer.shared.makeHomeViewModel())
        }
    }
}
````
</augment_code_snippet>

### In App Lifecycle

<augment_code_snippet path="template/App/AppView.swift" mode="EXCERPT">
````swift
struct AppView: View {
    @StateObject private var container = AppContainer.shared

    var body: some View {
        NavigationStack {
            HomeView()
        }
        .environmentObject(container)
    }
}
````
</augment_code_snippet>

## 🧪 Testing with DI

### Mock Registration
```swift
class DIContainerTests: XCTestCase {
    var container: AppContainer!
    
    override func setUp() {
        container = AppContainer()
        
        // Register mocks
        let mockAPIService = MockAPIService()
        container.register(APIServiceProtocol.self, instance: mockAPIService)
    }
    
    func testWithMockDependencies() {
        let viewModel = container.makeHomeViewModel()
        // Test with mocked dependencies
    }
}
```

### Preview Support
```swift
extension AppContainer {
    static var preview: AppContainer {
        let container = AppContainer()
        container.register(APIServiceProtocol.self, instance: MockAPIService())
        return container
    }
}

#Preview {
    HomeView()
        .environmentObject(AppContainer.preview)
}
```

## 🔄 Adding New Dependencies

### 1. Create Protocol
```swift
protocol NewServiceProtocol {
    func performAction() -> String
}
```

### 2. Implement Service
```swift
final class NewService: NewServiceProtocol {
    func performAction() -> String {
        return "Action performed"
    }
}
```

### 3. Register in Container
```swift
// In AppContainer.registerDependencies()
register(NewServiceProtocol.self) {
    NewService()
}
```

### 4. Use in ViewModel
```swift
final class NewViewModel: ObservableObject {
    private let newService: NewServiceProtocol
    
    init(newService: NewServiceProtocol) {
        self.newService = newService
    }
}
```

### 5. Add Factory Method
```swift
// In AppContainer
func makeNewViewModel() -> NewViewModel {
    return NewViewModel(
        newService: resolve(NewServiceProtocol.self)
    )
}
```

## 🎨 Theme System Example

The app includes a complete theme management system demonstrating DI:

### Theme Use Case
- Manages theme persistence
- Provides available themes
- Handles theme switching

### Settings ViewModel
- Injected with `ThemeUseCaseProtocol`
- Manages theme state
- Provides UI binding

### Integration
- App-wide theme application
- Persistent theme selection
- Localized theme names

## ✅ Benefits

### Testability
- Easy mock injection
- Isolated unit testing
- Predictable dependencies

### Maintainability
- Clear dependency graph
- Single responsibility
- Easy to modify

### Flexibility
- Runtime dependency swapping
- Environment-specific configurations
- Feature flag support

## 🔍 Best Practices

### Do's
- ✅ Use protocols for all dependencies
- ✅ Register dependencies at app startup
- ✅ Use factory methods for ViewModels
- ✅ Keep container as singleton
- ✅ Use environment objects in SwiftUI

### Don'ts
- ❌ Don't resolve dependencies in View body
- ❌ Don't create circular dependencies
- ❌ Don't register concrete types directly
- ❌ Don't access container from business logic
- ❌ Don't forget to register new dependencies

## 🚀 Advanced Features

### Scoped Dependencies
```swift
// Singleton (default behavior)
register(APIServiceProtocol.self) { APIService() }

// New instance each time
register(TransientServiceProtocol.self, factory: { TransientService() })
```

### Conditional Registration
```swift
if Environment.current == .staging {
    register(APIServiceProtocol.self) { MockAPIService() }
} else {
    register(APIServiceProtocol.self) { APIService() }
}
```

### Lazy Loading
```swift
// Dependencies are created only when first resolved
register(HeavyServiceProtocol.self) {
    HeavyService() // Created only when needed
}
```

---

This DI system provides a solid foundation for building scalable, testable, and maintainable iOS applications.
