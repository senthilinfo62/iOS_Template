# 📱 iOS Template App

A modern iOS application template built with SwiftUI, featuring clean architecture, automated CI/CD pipeline, and comprehensive development tools.

## 🚀 Features

- **Clean Architecture**: MVVM pattern with dependency injection
- **SwiftUI**: Modern declarative UI framework
- **Navigation**: Type-safe navigation with Router pattern
- **Networking**: Alamofire integration with repository pattern
- **Localization**: Multi-language support (English, Japanese)
- **CI/CD Pipeline**: Automated builds and TestFlight deployment
- **Environment Management**: Staging and Production configurations
- **Testing**: Unit tests and UI tests setup

## 📋 Requirements

- iOS 18.5+
- Xcode 16.4+
- Swift 5.0+
- macOS 15.3+ (for development)

## 🏗️ Architecture

### Project Structure
```
template/
├── App/                    # App entry point and main configuration
├── Presentation/           # Views and UI components
│   └── Views/             # SwiftUI views
├── ViewModels/            # View models (MVVM pattern)
├── Domain/                # Business logic and use cases
│   └── UseCases/          # Business use cases
├── Data/                  # Data layer
│   ├── Network/           # API services
│   └── Repositories/      # Data repositories
├── Navigation/            # Navigation logic and routing
├── Configuration/         # Environment and build configurations
├── Localization/          # String localization files
├── Theme/                 # UI theme and styling
├── Components/            # Reusable UI components
└── Tests/                 # Unit and UI tests
```

### Design Patterns
- **MVVM**: Model-View-ViewModel architecture
- **Repository Pattern**: Data access abstraction
- **Dependency Injection**: Loose coupling between components
- **Router Pattern**: Centralized navigation management

## 🛠️ Getting Started

### 1. Clone the Repository
```bash
git clone https://github.com/senthilinfo62/template.git
cd template
```

### 2. Install Dependencies
```bash
# Install Ruby dependencies for CI/CD
bundle install --path vendor/bundle

# Open project in Xcode
open template.xcodeproj
```

### 3. Build and Run
- Select your target device/simulator
- Press `Cmd + R` to build and run

## 🔧 Development

### Environment Configuration
The app supports multiple environments:

- **Staging**: `com.ios.template.stg` - For QA testing
- **Production**: `com.ios.template` - For production releases

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

## 📦 Dependencies

### Swift Package Manager
- [Alamofire](https://github.com/Alamofire/Alamofire) - HTTP networking

### Ruby Gems (CI/CD)
- [Fastlane](https://fastlane.tools/) - Automation and deployment
- [CocoaPods](https://cocoapods.org/) - Dependency management

## 🔐 Security

- Certificates managed with Fastlane Match
- Sensitive data stored in GitHub Secrets
- No hardcoded API keys or credentials
- Environment-specific configurations

## 📱 App Store

### Bundle Identifiers
- **Production**: `com.ios.template`
- **Staging**: `com.ios.template.stg`

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

- [CI/CD Setup Guide](CI_CD_SETUP.md) - Detailed CI/CD configuration
- [Quick CI/CD Guide](README_CICD.md) - Quick start for CI/CD

## 🐛 Troubleshooting

### Common Issues

1. **Build Errors**
   - Clean build folder: `Cmd + Shift + K`
   - Reset package cache: `File > Packages > Reset Package Caches`

2. **CI/CD Issues**
   - Check GitHub Actions logs
   - Validate setup: `./scripts/validate_setup.sh`
   - See [CI_CD_SETUP.md](CI_CD_SETUP.md) troubleshooting section

3. **Certificate Issues**
   ```bash
   bundle exec fastlane match nuke appstore
   bundle exec fastlane match appstore
   ```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- **Senthilkumar Maruthasalam** - Lead Developer
- Email: senthilinfo62@gmail.com
- GitHub: [@senthilinfo62](https://github.com/senthilinfo62)

## 🙏 Acknowledgments

- [SwiftUI](https://developer.apple.com/xcode/swiftui/) - Apple's declarative UI framework
- [Alamofire](https://github.com/Alamofire/Alamofire) - Elegant HTTP networking
- [Fastlane](https://fastlane.tools/) - App automation done right

---

**Happy Coding!** 🎉
