# 🚀 iOS Template - Clean Architecture

A **production-ready iOS application template** built with **SwiftUI**, featuring **Clean Architecture**, **Dependency Injection**, **Swift Package Manager**, and comprehensive enterprise features.

[![iOS](https://img.shields.io/badge/iOS-18.5+-blue.svg)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.0+-orange.svg)](https://swift.org/)
[![Xcode](https://img.shields.io/badge/Xcode-16.4+-blue.svg)](https://developer.apple.com/xcode/)
[![SPM](https://img.shields.io/badge/SPM-Compatible-green.svg)](https://swift.org/package-manager/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## ✨ Key Features

### 🏗️ **Architecture & Design**
- ✅ **Clean Architecture** - Proper separation of concerns with Domain, Data, and Presentation layers
- ✅ **MVVM Pattern** - Model-View-ViewModel with reactive programming
- ✅ **Dependency Injection** - Full DI container with service protocols
- ✅ **Repository Pattern** - Data access abstraction layer
- ✅ **Use Cases** - Business logic encapsulation

### 📱 **User Interface & Experience**
- ✅ **SwiftUI** - Modern declarative UI framework
- ✅ **Theme System** - Light/Dark/System theme support with live switching
- ✅ **Navigation** - Type-safe navigation with Router pattern
- ✅ **Launch Screen** - Proper full-screen support (no black bars)
- ✅ **Accessibility** - VoiceOver and accessibility support

### 🔧 **Development & Tools**
- ✅ **Swift Package Manager** - 100% SPM dependency management
- ✅ **Networking** - Alamofire integration with clean API layer
- ✅ **Environment Management** - Staging and Production configurations
- ✅ **Localization** - Multi-language support (English, Japanese)
- ✅ **Testing** - Unit tests and UI tests setup

### 🚀 **Enterprise Features**
- ✅ **Analytics** - Comprehensive event tracking and monitoring
- ✅ **Security** - Encryption, biometric auth, certificate pinning
- ✅ **Push Notifications** - Complete notification handling
- ✅ **Performance Monitoring** - App performance tracking
- ✅ **Background Tasks** - Background processing support
- ✅ **App Store Optimization** - Review prompts and store integration
- ✅ **CI/CD Pipeline** - Automated builds and TestFlight deployment

## 📋 Requirements

- iOS 18.5+
- Xcode 16.4+
- Swift 5.0+
- macOS 15.3+ (for development)

## 🏗️ Clean Architecture Structure

### **Layered Architecture**
```
template/
├── 📱 Platform/iOS/                    # Platform-specific code
│   ├── App/                           # App entry point and configuration
│   │   ├── TemplateApp.swift         # Main app entry point
│   │   ├── AppView.swift             # Root view with navigation
│   │   └── TabBasedAppView.swift     # Tab-based navigation option
│   └── Resources/                     # iOS-specific resources
│       ├── Assets.xcassets           # App icons and images
│       ├── LaunchScreen.storyboard   # Launch screen
│       └── Info.plist                # App configuration
│
├── 🎯 Features/                       # Feature modules (Clean Architecture)
│   ├── Home/                         # Home feature module
│   │   ├── Domain/                   # Business logic
│   │   ├── Data/                     # Data sources and repositories
│   │   └── Presentation/             # Views and ViewModels
│   └── Settings/                     # Settings feature module
│       ├── Domain/
│       ├── Data/
│       └── Presentation/
│
├── 🧠 Core/                          # Core business logic
│   ├── Domain/                       # Domain layer
│   │   ├── Entities/                 # Business entities
│   │   ├── UseCases/                 # Business use cases
│   │   └── Protocols/                # Domain protocols
│   └── Data/                         # Data layer
│       ├── DataSources/              # Remote and local data sources
│       └── Repositories/             # Repository implementations
│
├── 🔧 Infrastructure/                 # Infrastructure layer
│   ├── DI/                           # Dependency injection
│   │   └── AppContainer.swift        # DI container
│   ├── Navigation/                   # Navigation system
│   │   └── Router.swift              # Type-safe routing
│   └── Configuration/                # Environment configuration
│
├── 🎨 Shared/                        # Shared components
│   ├── UI/                           # UI components and theme
│   │   ├── Components/               # Reusable UI components
│   │   └── Theme/                    # Theme system
│   ├── Services/                     # Shared services
│   │   ├── Analytics/                # Analytics service
│   │   ├── Security/                 # Security service
│   │   ├── Notifications/            # Push notifications
│   │   └── Performance/              # Performance monitoring
│   ├── Extensions/                   # Swift extensions
│   └── Utilities/                    # Utility classes
│
├── 🌍 Resources/                     # Localization and assets
│   └── Localization/                 # Multi-language support
│
├── 🧪 Tests/                         # Test suites
│   ├── UnitTests/                    # Unit tests
│   └── UITests/                      # UI tests
│
├── 📜 scripts/                       # Utility scripts
│   ├── fix_alamofire_dependency.sh  # Fix SPM issues
│   └── setup_ci_cd.sh               # CI/CD setup
│
└── 📚 docs/                          # Documentation
    ├── CLEAN_ARCHITECTURE_STRUCTURE.md
    ├── IOS_DEVELOPMENT_PREREQUISITES.md
    └── CI_CD_PIPELINE.md
```

### **Design Patterns & Principles**

#### **🏛️ Clean Architecture Layers**
- **🎯 Presentation Layer**: SwiftUI Views + ViewModels (MVVM)
- **🧠 Domain Layer**: Use Cases + Entities + Protocols
- **💾 Data Layer**: Repositories + Data Sources + API Services
- **🔧 Infrastructure Layer**: DI Container + Navigation + Configuration

#### **🎨 Design Patterns**
- **MVVM**: Model-View-ViewModel with reactive programming
- **Repository Pattern**: Data access abstraction
- **Dependency Injection**: Full DI container with service protocols
- **Router Pattern**: Type-safe navigation management
- **Use Case Pattern**: Business logic encapsulation
- **Factory Pattern**: Object creation through DI container

#### **🔗 Dependency Flow**
```
Presentation → Domain ← Data
     ↓           ↓       ↓
Infrastructure (DI Container)
```

#### **✅ SOLID Principles**
- **S**ingle Responsibility: Each class has one reason to change
- **O**pen/Closed: Open for extension, closed for modification
- **L**iskov Substitution: Subtypes must be substitutable
- **I**nterface Segregation: Many specific interfaces vs one general
- **D**ependency Inversion: Depend on abstractions, not concretions

## 🚀 Getting Started

### **📋 Prerequisites**
- **macOS 15.3+** (for development)
- **Xcode 16.4+** with iOS 18.5+ SDK
- **Swift 5.0+**
- **Git** (for version control)
- **Ruby 3.0+** (for CI/CD tools)

### **1. 📥 Clone the Repository**
```bash
git clone https://github.com/senthilinfo62/iOS_Template.git
cd iOS_Template
```

### **2. 🔧 Quick Setup (Recommended)**
```bash
# Open project in Xcode (everything is pre-configured!)
open template.xcodeproj

# That's it! The project is ready to run with:
# ✅ Clean Architecture implemented
# ✅ Dependency Injection configured
# ✅ Swift Package Manager dependencies resolved
# ✅ Launch screen properly configured
# ✅ All enterprise features included
```

### **3. 🏃‍♂️ Build and Run**
1. **Select Target**: Choose your device/simulator in Xcode
2. **Build**: Press `Cmd + R` to build and run
3. **Enjoy**: The app launches with full-screen support and all features working!

### **4. 🛠️ Optional: CI/CD Setup**
```bash
# Install Ruby dependencies for CI/CD (optional)
bundle install --path vendor/bundle

# Set up CI/CD pipeline (optional)
./scripts/setup_ci_cd.sh
```

### **5. 🔍 Verify Installation**
```bash
# Fix any SPM dependency issues (if needed)
./scripts/fix_alamofire_dependency.sh

# Check project structure
ls -la template/
```

### **⚡ Quick Start Checklist**
- [ ] Clone repository
- [ ] Open `template.xcodeproj` in Xcode
- [ ] Select target device/simulator
- [ ] Press `Cmd + R` to run
- [ ] 🎉 **You're ready to develop!**

## 🔧 Development Guide

### **🏗️ Dependency Injection (DI) System**

This project implements a **complete Dependency Injection system** for clean, testable, and maintainable code.

#### **DI Container Usage**
```swift
// AppContainer.swift - Central DI container
let container = AppContainer.shared

// Create ViewModels with DI
let homeViewModel = container.makeHomeViewModel()
let settingsViewModel = container.makeSettingsViewModel()

// Register custom services
container.register(APIServiceProtocol.self) {
    CustomAPIService()
}

// Resolve dependencies
let apiService: APIServiceProtocol = container.resolve(APIServiceProtocol.self)
```

#### **Service Protocols**
All major services implement protocols for easy testing and swapping:

```swift
// Analytics Service
protocol AnalyticsServiceProtocol {
    func track(event: String, parameters: [String: Any]?)
    func setUserProperty(key: String, value: String)
    func logError(_ error: Error, additionalInfo: [String: Any]?)
}

// Security Service
protocol SecurityServiceProtocol {
    func encrypt(data: Data) -> Data?
    func decrypt(data: Data) -> Data?
    func generateSecureToken() -> String
}

// Theme Service
protocol ThemeServiceProtocol {
    var currentTheme: AppTheme { get }
    func setTheme(_ theme: AppTheme)
    func getAvailableThemes() -> [AppTheme]
}
```

#### **ViewModel Creation with DI**
```swift
// HomeViewModel with dependency injection
final class HomeViewModel: ObservableObject {
    private let fetchPostUseCase: FetchPostUseCaseProtocol

    init(fetchPostUseCase: FetchPostUseCaseProtocol? = nil) {
        if let fetchPostUseCase = fetchPostUseCase {
            self.fetchPostUseCase = fetchPostUseCase
        } else {
            // Fallback to default implementation
            self.fetchPostUseCase = FetchPostUseCase(apiService: MockAPIService())
        }
    }
}
```

### **🚀 Enterprise Features**

#### **📊 Analytics System**
```swift
// Track events
AnalyticsManager.shared.track(event: "user_login", parameters: [
    "method": "email",
    "timestamp": Date().timeIntervalSince1970
])

// Set user properties
AnalyticsManager.shared.setUserProperty(key: "user_type", value: "premium")
```

#### **🔒 Security Features**
```swift
// Encrypt sensitive data
let encryptedData = SecurityManager.shared.encrypt(data: sensitiveData)

// Biometric authentication
SecurityManager.shared.authenticateWithBiometrics { result in
    switch result {
    case .success:
        // Access granted
    case .failure(let error):
        // Handle error
    }
}
```

#### **🔔 Push Notifications**
```swift
// Request permissions
PushNotificationManager.shared.requestPermission()

// Handle received notifications
PushNotificationManager.shared.handleNotification(userInfo)
```

#### **🎨 Theme System**
```swift
// Change theme programmatically
ThemeManager.shared.setTheme(.dark)

// Get current theme
let currentTheme = ThemeManager.shared.currentTheme

// Available themes: .light, .dark, .system
```

### **Environment Configuration**
The app supports multiple environments:

- **Staging**: `com.nexware.template.stg` - For QA testing
- **Production**: `com.nexware.template` - For production releases

Environment-specific settings are managed in:
- `template/Configuration/Staging.xcconfig`
- `template/Configuration/Production.xcconfig`
- `template/Configuration/Environment.swift`

### Adding New Features
1. Create use case in `Domain/UseCases/`
2. Implement repository in `Data/Repositories/`
3. Create view model in `ViewModels/`
4. Build UI in `Presentation/Views/`
5. Add navigation route if needed

### Localization
Add new strings to:
- `template/Localization/en.lproj/Localizable.strings` (English)
- `template/Localization/ja.lproj/Localizable.strings` (Japanese)

Usage in code:
```swift
Text(NSLocalizedString("key", comment: "Description"))
```

## 🚀 CI/CD Pipeline

### Automated Builds
- **Staging**: Triggered on push to `develop` branch
- **Production**: Triggered on push to `main` branch

### Setup CI/CD
```bash
# Run setup script
./scripts/setup_ci_cd.sh

# Validate configuration
./scripts/validate_setup.sh
```

### Manual Builds
```bash
# Run tests
bundle exec fastlane test

# Build staging
bundle exec fastlane staging

# Build production
bundle exec fastlane production
```

For detailed CI/CD setup instructions, see [CI_CD_SETUP.md](CI_CD_SETUP.md)

## 🧪 Testing

### Running Tests
```bash
# Run all tests
bundle exec fastlane test

# Run in Xcode
Cmd + U
```

### Test Structure
- **Unit Tests**: Business logic and view model tests
- **UI Tests**: End-to-end user interface tests
- **Integration Tests**: API and data layer tests

## 📦 Dependencies & Package Management

### **🎯 Swift Package Manager (SPM) - 100% SPM Project**

This project is **completely SPM-based** with **zero CocoaPods dependencies**. All packages are managed through Xcode's integrated Swift Package Manager.

#### **✅ Currently Integrated Packages**
| Package | Version | Purpose | Status |
|---------|---------|---------|--------|
| [**Alamofire**](https://github.com/Alamofire/Alamofire) | `5.10.2` | HTTP Networking | ✅ **Active** |

#### **🔧 SPM Management**

**Automatic Resolution** (Recommended):
```bash
# SPM dependencies resolve automatically when opening the project
open template.xcodeproj
```

**Manual Resolution** (If needed):
```bash
# Fix any SPM dependency issues
./scripts/fix_alamofire_dependency.sh

# Or resolve manually in Xcode:
# File → Packages → Resolve Package Versions
```

**Adding New Packages**:
```bash
# In Xcode:
# 1. File → Add Package Dependencies...
# 2. Enter package URL
# 3. Select version/branch
# 4. Add to target
```

#### **🚀 Recommended Additional Packages**

For enhanced functionality, consider adding these popular SPM packages:

| Category | Package | URL | Purpose |
|----------|---------|-----|---------|
| 🔐 **Security** | KeychainAccess | `https://github.com/kishikawakatsumi/KeychainAccess.git` | Secure storage |
| 📝 **Logging** | SwiftyBeaver | `https://github.com/SwiftyBeaver/SwiftyBeaver.git` | Advanced logging |
| 🎨 **Animation** | Lottie | `https://github.com/airbnb/lottie-ios.git` | Beautiful animations |
| 🧪 **Testing** | Quick & Nimble | `https://github.com/Quick/Quick.git` | BDD testing |
| 📊 **Analytics** | Firebase | `https://github.com/firebase/firebase-ios-sdk.git` | Analytics & Crashlytics |
| 🌐 **Networking** | Moya | `https://github.com/Moya/Moya.git` | Network abstraction |

#### **✅ SPM Benefits in This Project**
- 🚀 **Fast dependency resolution**
- 🔄 **Automatic updates and version management**
- 🧹 **No external package managers needed**
- 📦 **Integrated with Xcode**
- 🔒 **Secure and reliable**
- 🎯 **Zero configuration required**

### **🛠️ Development Dependencies**

#### **Ruby Gems (CI/CD)**
```ruby
# Gemfile
gem 'fastlane'          # Automation and deployment
gem 'cocoapods'         # Not used (SPM-only project)
```

#### **Development Tools**
- **Xcode 16.4+** - IDE and build tools
- **Swift 5.0+** - Programming language
- **Git** - Version control
- **Fastlane** - CI/CD automation

## 🔐 Security

- Certificates managed with Fastlane Match
- Sensitive data stored in GitHub Secrets
- No hardcoded API keys or credentials
- Environment-specific configurations

## 📱 App Store

### Bundle Identifiers
- **Production**: `com.nexware.template`
- **Staging**: `com.nexware.template.stg`

### TestFlight Distribution
- **Staging**: QA Team, Internal Testers
- **Production**: External Testers

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style
- Follow Swift API Design Guidelines
- Use SwiftLint for code formatting
- Write unit tests for new features
- Update documentation as needed

## 🔄 Workflow

### Development Workflow
1. **Feature Development**
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b feature/your-feature-name
   # Make your changes
   git commit -m "Add your feature"
   git push origin feature/your-feature-name
   ```

2. **Testing**
   ```bash
   # Run tests locally
   bundle exec fastlane test
   # Create PR to develop branch
   ```

3. **Staging Deployment**
   ```bash
   # Merge to develop branch
   git checkout develop
   git merge feature/your-feature-name
   git push origin develop
   # Automatic staging build triggers
   ```

4. **Production Deployment**
   ```bash
   # Merge to main branch
   git checkout main
   git merge develop
   git push origin main
   # Automatic production build triggers
   ```

### Branch Strategy
- `main` - Production releases
- `develop` - Development and staging
- `feature/*` - Feature development
- `hotfix/*` - Emergency fixes

## 📊 Monitoring & Analytics

### Build Monitoring
- GitHub Actions for build status
- TestFlight for app distribution
- Slack notifications (optional)

### App Analytics
- Environment-based analytics configuration
- Staging: Analytics disabled
- Production: Analytics enabled

## 📚 Documentation

### **🏗️ Architecture Documentation**
| Document | Description | Status |
|----------|-------------|--------|
| [**Clean Architecture Structure**](docs/CLEAN_ARCHITECTURE_STRUCTURE.md) | Complete project organization and architecture guide | ✅ **Complete** |
| [**Dependency Injection Guide**](docs/DEPENDENCY_INJECTION.md) | DI implementation and usage patterns | ✅ **Complete** |
| [**iOS Development Prerequisites**](docs/IOS_DEVELOPMENT_PREREQUISITES.md) | Complete development environment setup | ✅ **Complete** |

### **🚀 CI/CD & Deployment**
| Document | Description | Status |
|----------|-------------|--------|
| [**CI/CD Setup Guide**](CI_CD_SETUP.md) | Detailed CI/CD configuration with GitHub Actions | ✅ **Complete** |
| [**Quick CI/CD Guide**](README_CICD.md) | Quick start for automated deployment | ✅ **Complete** |
| [**GitHub Actions Setup**](docs/GITHUB_ACTIONS_SETUP.md) | PR lint checks and quality gates | ✅ **Complete** |

### **📦 Package Management**
| Document | Description | Status |
|----------|-------------|--------|
| [**SPM Configuration Guide**](docs/SPM_CONFIGURATION.md) | Swift Package Manager setup and best practices | ✅ **Complete** |
| [**Essential Packages Guide**](docs/ESSENTIAL_PACKAGES_GUIDE.md) | Recommended SPM packages for iOS development | ✅ **Complete** |
| [**SPM Verification Report**](docs/SPM_VERIFICATION_REPORT.md) | 100% SPM project verification | ✅ **Complete** |

### **🎨 UI & Features**
| Document | Description | Status |
|----------|-------------|--------|
| [**Theme System Guide**](docs/THEME_TROUBLESHOOTING.md) | Theme implementation and troubleshooting | ✅ **Complete** |
| [**API Improvements Guide**](docs/API_IMPROVEMENTS.md) | Enhanced API service implementation | ✅ **Complete** |

### **🔧 Setup & Configuration**
| Document | Description | Status |
|----------|-------------|--------|
| [**Additional iOS Setup**](docs/ADDITIONAL_IOS_SETUP.md) | Advanced components and enterprise features | ✅ **Complete** |
| [**Complete iOS Setup**](docs/COMPLETE_IOS_SETUP.md) | All major iOS components and services | ✅ **Complete** |

### **📖 Quick Reference**

#### **🏃‍♂️ Getting Started**
1. Clone repository
2. Open `template.xcodeproj`
3. Press `Cmd + R` to run
4. Start developing with Clean Architecture!

#### **🔧 Common Tasks**
```bash
# Fix SPM dependencies
./scripts/fix_alamofire_dependency.sh

# Setup CI/CD
./scripts/setup_ci_cd.sh

# View project structure
tree template/ -I 'DerivedData|.git'
```

#### **🎯 Key Files**
- `AppContainer.swift` - Dependency injection container
- `Router.swift` - Navigation management
- `ThemeManager.swift` - Theme system
- `AnalyticsManager.swift` - Analytics tracking
- `SecurityManager.swift` - Security features

## 🐛 Troubleshooting

### **🔧 Common Issues & Solutions**

#### **1. 📦 SPM/Alamofire Dependency Issues**
```bash
# Problem: "Missing package product 'Alamofire'" error
# Solution: Run the fix script
./scripts/fix_alamofire_dependency.sh

# Alternative: Manual fix in Xcode
# File → Packages → Reset Package Caches
# Clean Build Folder (Cmd + Shift + K)
# Rebuild (Cmd + B)
```

#### **2. 🖥️ Build Errors**
```bash
# Clean build folder
Cmd + Shift + K

# Reset package cache
# File → Packages → Reset Package Caches

# Clean derived data
rm -rf ~/Library/Developer/Xcode/DerivedData/template-*

# Rebuild project
Cmd + B
```

#### **3. 📱 Launch Screen / Black Bars Issue**
```bash
# Problem: Black areas at top/bottom of screen
# Solution: Already fixed in this template!
# The Info.plist includes proper UILaunchStoryboardName configuration
# LaunchScreen.storyboard is properly configured for all device sizes
```

#### **4. 🔄 CI/CD Issues**
```bash
# Check GitHub Actions logs
# Validate setup
./scripts/validate_setup.sh

# See detailed troubleshooting
open docs/CI_CD_SETUP.md
```

#### **5. 🔐 Certificate Issues**
```bash
# Reset certificates
bundle exec fastlane match nuke appstore
bundle exec fastlane match appstore
```

#### **6. 🎨 Theme System Issues**
```bash
# Problem: Theme not switching properly
# Solution: Check ThemeManager.shared usage
# Ensure @StateObject and @EnvironmentObject are used correctly
```

### **🆘 Getting Help**

#### **📞 Support Channels**
- **GitHub Issues**: [Create an issue](https://github.com/senthilinfo62/iOS_Template/issues)
- **Email**: senthilinfo62@gmail.com
- **Documentation**: Check the `docs/` folder for detailed guides

#### **🔍 Debug Information**
When reporting issues, please include:
- Xcode version
- iOS deployment target
- Error messages (full stack trace)
- Steps to reproduce
- Device/simulator information

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- **Senthilkumar Maruthasalam** - Lead Developer
- Email: senthilinfo62@gmail.com
- GitHub: [@senthilinfo62](https://github.com/senthilinfo62)

## 🙏 Acknowledgments

### **🛠️ Technologies & Frameworks**
- [**SwiftUI**](https://developer.apple.com/xcode/swiftui/) - Apple's modern declarative UI framework
- [**Swift Package Manager**](https://swift.org/package-manager/) - Apple's dependency management solution
- [**Alamofire**](https://github.com/Alamofire/Alamofire) - Elegant HTTP networking in Swift
- [**Fastlane**](https://fastlane.tools/) - The easiest way to automate building and releasing iOS apps

### **🏗️ Architecture Inspiration**
- [**Clean Architecture**](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) - Robert C. Martin's architectural principles
- [**MVVM Pattern**](https://docs.microsoft.com/en-us/xamarin/xamarin-forms/enterprise-application-patterns/mvvm) - Model-View-ViewModel design pattern
- [**Dependency Injection**](https://martinfowler.com/articles/injection.html) - Martin Fowler's DI principles

### **📚 Learning Resources**
- [**Apple Developer Documentation**](https://developer.apple.com/documentation/) - Official iOS development guides
- [**Swift.org**](https://swift.org/) - Swift programming language resources
- [**iOS Development Community**](https://developer.apple.com/forums/) - Apple Developer Forums

### **🎯 Project Goals Achieved**
- ✅ **Production-Ready Template** - Enterprise-grade iOS application foundation
- ✅ **Clean Architecture** - Proper separation of concerns and maintainable code
- ✅ **Modern Development Practices** - SPM, DI, MVVM, and reactive programming
- ✅ **Comprehensive Features** - Analytics, Security, Push Notifications, and more
- ✅ **Developer Experience** - Easy setup, clear documentation, and helpful scripts

---

## 🎉 **Ready to Build Amazing iOS Apps!**

This template provides everything you need to start building **production-ready iOS applications** with **Clean Architecture**, **Dependency Injection**, and **modern development practices**.

### **🚀 What's Next?**
1. **Clone the repository** and start building your app
2. **Customize the features** to match your requirements
3. **Add your business logic** using the established patterns
4. **Deploy with confidence** using the CI/CD pipeline

### **💡 Remember**
- Follow the **Clean Architecture principles**
- Use **Dependency Injection** for testable code
- Leverage **Swift Package Manager** for dependencies
- Write **tests** for your business logic
- Keep the **documentation** updated

**Happy Coding!** 🎉✨

---

*Built with ❤️ by [Senthilkumar Maruthasalam](https://github.com/senthilinfo62)*
