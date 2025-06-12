# 🚀 iOS App: Developer's Architectural Guide

This document provides a comprehensive overview of the iOS application's architecture, designed to help developers understand the project structure, core principles, and data flow.

---

## 1. High-Level Architecture: Clean Architecture

The application is built upon the principles of **Clean Architecture**, which ensures a clear separation of concerns and promotes a modular, scalable, and testable codebase.

The architecture is divided into four primary layers:

-   **Presentation Layer:** Responsible for the UI and user interactions.
-   **Domain Layer:** Contains the core business logic and rules.
-   **Data Layer:** Manages data from various sources (network, database).
-   **Infrastructure Layer:** Provides supporting capabilities like dependency injection and navigation.

### Visual Architecture Diagram

This diagram illustrates the layers and the flow of dependencies:

```mermaid
graph TD
    subgraph Presentation Layer
        A[View (SwiftUI)] --> B{ViewModel (MVVM)};
        B --> C{Router};
    end

    subgraph Domain Layer
        D[Use Case]
    end

    subgraph Data Layer
        E[Repository] --> F[API Service];
    end

    subgraph Infrastructure
        G[Dependency Injection];
    end

    B --> D;
    D --> E;
    
    G -- Injects --> B;
    G -- Injects --> D;
    G -- Injects --> E;

    style A fill:#cde4ff,stroke:#333,stroke-width:2px
    style B fill:#cde4ff,stroke:#333,stroke-width:2px
    style C fill:#cde4ff,stroke:#333,stroke-width:2px
    style D fill:#d5e8d4,stroke:#333,stroke-width:2px
    style E fill:#f8cecc,stroke:#333,stroke-width:2px
    style F fill:#f8cecc,stroke:#333,stroke-width:2px
    style G fill:#e6d8f9,stroke:#333,stroke-width:2px
```

---

## 2. Core Principles & Design Patterns

-   **SOLID Principles:** The codebase adheres to the SOLID principles to ensure it is maintainable and robust.
-   **MVVM (Model-View-ViewModel):** The Presentation Layer uses MVVM to separate UI logic from business logic.
-   **Repository Pattern:** The Data Layer uses repositories to abstract data sources.
-   **Dependency Injection:** A central DI container manages the creation and injection of dependencies.
-   **Router Pattern:** A type-safe `Router` manages navigation throughout the app.

---

## 3. Detailed Class Analysis

### Infrastructure Layer

#### `AppContainer.swift`

The `AppContainer` is the heart of the dependency injection system. It manages the lifecycle of all major components.

```swift
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
    // ...
}
```

#### `Router.swift` & `Route.swift`

The `Router` and `Route` enum work together to provide a type-safe and centralized navigation system.

```swift
/**
 * The `Router` class manages the navigation stack for the application.
 *
 * It uses SwiftUI's `NavigationPath` to programmatically control
 * the navigation flow, allowing for type-safe routing.
 *
 * Key Responsibilities:
 * - `push(_ route: Route)`: Navigates to a new view.
 * - `pop()`: Returns to the previous view.
 * - `popToRoot()`: Returns to the root view of the navigation stack.
 */
final class Router: ObservableObject {
    // ...
}

/**
 * The `Route` enum defines all possible navigation destinations.
 *
 * Using an enum for routes ensures type safety and prevents
 * errors from using incorrect navigation paths.
 */
enum Route: Hashable {
    // ...
}
```

### Presentation Layer

#### `HomeView.swift`

A SwiftUI view that displays the main screen of the application.

```swift
/**
 * The main view of the application.
 *
 * This view is responsible for:
 * - Displaying the UI to the user.
 * - Delegating user actions to the `HomeViewModel`.
 * - Using the `Router` to navigate to other views.
 *
 * It receives its dependencies (`HomeViewModel`, `Router`) via
 * dependency injection and the environment.
 */
struct HomeView: View {
    // ...
}
```

#### `HomeViewModel.swift`

The ViewModel for the `HomeView`, containing the presentation logic and state.

```swift
/**
 * The ViewModel for the `HomeView`.
 *
 * This class is responsible for:
 * - Managing the state of the `HomeView`.
 * - Executing the `FetchPostUseCase` to load data.
 * - Handling the results and updating its `@Published` properties.
 *
 * The `HomeView` observes these properties and updates the UI accordingly.
 */
final class HomeViewModel: ObservableObject {
    // ...
}
```

### Domain Layer

#### `FetchPostUseCase.swift`

A use case that encapsulates the business logic for fetching a post.

```swift
/**
 * The use case for fetching a post.
 *
 * This class contains the specific business logic for this operation.
 * It acts as a bridge between the `HomeViewModel` and the `PostRepository`.
 *
 * By encapsulating the business logic here, we keep the ViewModel
 * clean and focused on presentation.
 */
final class FetchPostUseCase: FetchPostUseCaseProtocol {
    // ...
}
```

### Data Layer

#### `PostRepository.swift`

The repository responsible for fetching posts.

```swift
/**
 * The repository for managing `Post` data.
 *
 * This class abstracts the data source, providing a clean API for
 * the Domain layer to interact with. It hides the implementation
 * details of where the data comes from (e.g., network, cache).
 *
 * It depends on the `APIServiceProtocol` to perform the actual
 * data fetching.
 */
final class PostRepository: PostRepositoryProtocol {
    // ...
}
```

#### `ApiService.swift`

The service responsible for making network requests.

```swift
/**
 * The `APIService` handles all network communication.
 *
 * This class is responsible for:
 * - Making HTTP requests using Alamofire.
 * - Handling responses and decoding them into Swift objects.
 * - Managing network-related errors.
 * - Implementing advanced features like request retries.
 */
final class APIService: APIServiceProtocol {
    // ...
}
```

---

## 4. End-to-End Data Flow

Here is a step-by-step example of how data flows through the app when the user opens the home screen:

1.  **`HomeView.onAppear`:** The `onAppear` modifier triggers the `viewModel.loadPost()` method.
2.  **`HomeViewModel`:** The ViewModel sets its `isLoading` state to `true` and calls `fetchPostUseCase.execute()`.
3.  **`FetchPostUseCase`:** The use case calls `postRepository.getPost()`.
4.  **`PostRepository`:** The repository calls `apiService.fetchPost()`.
5.  **`APIService`:** The API service makes an HTTP request to the server.
6.  **Response:** The data flows back through the layers: `APIService` -> `PostRepository` -> `FetchPostUseCase` -> `HomeViewModel`.
7.  **UI Update:** The `HomeViewModel` updates its `@Published` properties, and the `HomeView` automatically refreshes to display the new data.

This structured approach ensures that the application is robust, maintainable, and easy to develop for.