# Contributing to iOS Template App

Thank you for your interest in contributing to the iOS Template App! This document provides guidelines and information for contributors.

## 🤝 How to Contribute

### Reporting Issues
1. Check existing issues to avoid duplicates
2. Use the issue template when creating new issues
3. Provide detailed information including:
   - iOS version
   - Xcode version
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots if applicable

### Suggesting Features
1. Open an issue with the "feature request" label
2. Describe the feature and its benefits
3. Provide use cases and examples
4. Discuss implementation approach if possible

### Code Contributions
1. Fork the repository
2. Create a feature branch from `develop`
3. Make your changes following our coding standards
4. Write tests for new functionality
5. Update documentation as needed
6. Submit a pull request

## 🔄 Development Workflow

### Branch Strategy
- `main` - Production releases (protected)
- `develop` - Development integration branch
- `feature/*` - Feature development branches
- `hotfix/*` - Emergency fixes
- `release/*` - Release preparation branches

### Getting Started
```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/template.git
cd template

# Add upstream remote
git remote add upstream https://github.com/senthilinfo62/template.git

# Install dependencies
bundle install --path vendor/bundle

# Create feature branch
git checkout develop
git pull upstream develop
git checkout -b feature/your-feature-name
```

### Making Changes
1. **Follow the architecture**: Use MVVM pattern and clean architecture principles
2. **Write tests**: Add unit tests for new functionality
3. **Update documentation**: Keep README and docs up to date
4. **Follow code style**: Use consistent formatting and naming conventions

### Testing Your Changes
```bash
# Run unit tests
bundle exec fastlane test

# Run UI tests
xcodebuild test -scheme template -destination 'platform=iOS Simulator,name=iPhone 15'

# Validate CI/CD setup
./scripts/validate_setup.sh
```

### Submitting Pull Requests
1. **Update your branch**:
   ```bash
   git checkout develop
   git pull upstream develop
   git checkout feature/your-feature-name
   git rebase develop
   ```

2. **Create pull request**:
   - Target the `develop` branch
   - Use descriptive title and description
   - Reference related issues
   - Include screenshots for UI changes

3. **PR Requirements**:
   - All tests must pass
   - Code review approval required
   - Documentation updated if needed
   - No merge conflicts

## 📝 Coding Standards

### Swift Style Guide
- Follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Use meaningful variable and function names
- Prefer explicit types when clarity is improved
- Use `// MARK:` comments to organize code sections

### Code Organization
```swift
// MARK: - Properties
private let repository: PostRepositoryProtocol

// MARK: - Initialization
init(repository: PostRepositoryProtocol = PostRepository()) {
    self.repository = repository
}

// MARK: - Public Methods
func loadPost() {
    // Implementation
}

// MARK: - Private Methods
private func handleResponse(_ result: Result<Post, Error>) {
    // Implementation
}
```

### SwiftUI Best Practices
- Extract complex views into separate components
- Use `@StateObject` for view model creation
- Use `@ObservedObject` for passed view models
- Prefer computed properties for derived state

### Architecture Guidelines
- Follow MVVM pattern consistently
- Use dependency injection for testability
- Keep view models platform-agnostic
- Separate business logic from UI logic

## 🧪 Testing Guidelines

### Unit Testing
- Test business logic in view models
- Test use cases and repositories
- Mock external dependencies
- Aim for high code coverage

### UI Testing
- Test critical user flows
- Test navigation between screens
- Test accessibility features
- Keep tests maintainable and reliable

### Test Organization
```swift
class HomeViewModelTests: XCTestCase {
    var sut: HomeViewModel!
    var mockRepository: MockPostRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockPostRepository()
        sut = HomeViewModel(repository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    // Test methods...
}
```

## 📚 Documentation

### Code Documentation
- Use Swift documentation comments for public APIs
- Include parameter descriptions and return values
- Provide usage examples for complex functions

```swift
/// Fetches a post from the remote API
/// - Parameter completion: Completion handler called with the result
/// - Returns: Void
func fetchPost(completion: @escaping (Result<Post, Error>) -> Void) {
    // Implementation
}
```

### README Updates
- Update feature lists for new functionality
- Add setup instructions for new dependencies
- Update troubleshooting section as needed

## 🔧 CI/CD Contributions

### Workflow Changes
- Test workflow changes in your fork first
- Document any new secrets or configuration needed
- Ensure backward compatibility when possible

### Fastlane Updates
- Test lane changes locally
- Update documentation for new lanes
- Consider impact on existing workflows

## 🐛 Bug Fixes

### Bug Report Process
1. Reproduce the issue consistently
2. Identify the root cause
3. Write a failing test that demonstrates the bug
4. Implement the fix
5. Verify the test now passes
6. Update documentation if needed

### Hotfix Process
For critical production issues:
1. Create hotfix branch from `main`
2. Implement minimal fix
3. Test thoroughly
4. Create PR to `main` and `develop`
5. Deploy immediately after approval

## 📋 Code Review

### As a Reviewer
- Be constructive and respectful
- Focus on code quality and architecture
- Check for test coverage
- Verify documentation updates
- Test the changes locally if needed

### As a Contributor
- Respond to feedback promptly
- Ask questions if feedback is unclear
- Make requested changes in separate commits
- Update PR description if scope changes

## 🏷️ Release Process

### Version Numbering
- Follow [Semantic Versioning](https://semver.org/)
- Major: Breaking changes
- Minor: New features (backward compatible)
- Patch: Bug fixes (backward compatible)

### Release Checklist
- [ ] All tests passing
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
- [ ] Version number bumped
- [ ] Release notes prepared
- [ ] CI/CD pipeline tested

## 🆘 Getting Help

### Communication Channels
- GitHub Issues for bug reports and feature requests
- GitHub Discussions for general questions
- Email: senthilinfo62@gmail.com for direct contact

### Resources
- [Architecture Guide](docs/ARCHITECTURE.md)
- [API Documentation](docs/API.md)
- [CI/CD Setup Guide](CI_CD_SETUP.md)
- [Apple Developer Documentation](https://developer.apple.com/documentation/)

## 📄 License

By contributing to this project, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to the iOS Template App! 🎉
