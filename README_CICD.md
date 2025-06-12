# 🚀 CI/CD Pipeline for iOS Template App

This repository includes a complete CI/CD pipeline that automatically builds and deploys your iOS app to TestFlight with separate configurations for staging and production environments.

## 📋 Quick Start

1. **Run the setup script:**
   ```bash
   ./scripts/setup_ci_cd.sh
   ```

2. **Configure GitHub Secrets** (see [Configuration](#configuration) below)

3. **Push to trigger builds:**
   - Push to `develop` → Staging build (`com.nexware.template.stg`)
   - Push to `main` → Production build (`com.nexware.template`)

## 🏗️ Architecture

### Build Configurations
- **Staging**: `com.nexware.template.stg` - QA testing environment
- **Production**: `com.nexware.template` - Production release environment

### Workflow Triggers
- **Staging**: `develop`, `staging` branches
- **Production**: `main`, `master` branches, GitHub releases

## ⚙️ Configuration

### Required GitHub Secrets

| Secret | Description | How to Get |
|--------|-------------|------------|
| `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD` | App-specific password | [Apple ID Settings](https://appleid.apple.com) → Sign-In and Security → App-Specific Passwords |
| `MATCH_PASSWORD` | Password for certificate encryption | Choose a secure password |
| `MATCH_GIT_BASIC_AUTHORIZATION` | Git credentials for certificate repo | `echo -n "username:token" \| base64` |

### Optional GitHub Secrets

| Secret | Description |
|--------|-------------|
| `SLACK_URL` | Slack webhook for notifications |
| `FASTLANE_SESSION` | Persistent 2FA session |

## 📱 App Store Connect Setup

Create two apps in App Store Connect:

1. **Production App**
   - Bundle ID: `com.nexware.template`
   - Name: "Template"

2. **Staging App**
   - Bundle ID: `com.nexware.template.stg`
   - Name: "Template STG"

## 🔐 Certificate Management

The pipeline uses [Fastlane Match](https://docs.fastlane.tools/actions/match/) for certificate management:

1. **Create a private repository** for certificates:
   ```
   https://github.com/senthilinfo62/certificates
   ```

2. **Initialize Match** (first time only):
   ```bash
   bundle exec fastlane match init
   bundle exec fastlane match appstore
   ```

## 🛠️ Local Development

### Available Commands

```bash
# Install dependencies
bundle install

# Run tests
bundle exec fastlane test

# Build staging
bundle exec fastlane staging

# Build production
bundle exec fastlane production

# Download certificates
bundle exec fastlane certificates
```

### Environment Variables

The app automatically detects the environment based on build configuration:

```swift
// Usage in code
let apiURL = Environment.current.baseURL
let isStaging = Environment.current == .staging
```

## 📊 Monitoring

- **GitHub Actions**: Build logs and status
- **TestFlight**: Build processing and distribution
- **Slack**: Real-time notifications (if configured)

## 🔧 Troubleshooting

### Common Issues

1. **Certificate Problems**
   ```bash
   # Reset and regenerate certificates
   bundle exec fastlane match nuke appstore
   bundle exec fastlane match appstore
   ```

2. **Build Number Conflicts**
   - Build numbers auto-increment
   - Ensure both App Store Connect apps exist

3. **2FA Issues**
   - Use app-specific passwords
   - Set `FASTLANE_SESSION` for persistent sessions

### Getting Help

1. Check GitHub Actions logs for detailed errors
2. Verify all secrets are configured correctly
3. Ensure certificate repository access works
4. See [CI_CD_SETUP.md](CI_CD_SETUP.md) for detailed instructions

## 🔒 Security

- ✅ Certificates stored in separate private repository
- ✅ Sensitive data in GitHub Secrets
- ✅ No hardcoded credentials in code
- ✅ Encrypted certificate storage with Match

## 📚 Documentation

- [Detailed Setup Guide](CI_CD_SETUP.md)
- [Fastlane Documentation](https://docs.fastlane.tools/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

---

**Need help?** Check the troubleshooting section or create an issue in this repository.
