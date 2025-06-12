# 🚀 Fastlane Configuration for iOS Template

This directory contains the Fastlane configuration for automated iOS builds and TestFlight deployments.

## 📋 Prerequisites

### 1. Install Xcode Command Line Tools
```bash
xcode-select --install
```

### 2. Install Fastlane
```bash
# Install via Bundler (recommended)
bundle install

# Or install globally
gem install fastlane
```

### 3. Apple Developer Account Setup
- **Apple ID**: `senthilkumar.m@nexware-global.com`
- **Team ID**: `FC25M3HCWJ`
- **App IDs Created**:
  - Production: `com.nexware.template` (44RP8BK62Z)
  - Staging: `com.nexware.template.stg` (QW8XZ2VH49)

## 🔐 Required GitHub Secrets

For CI/CD automation, add these secrets to your GitHub repository:

### Go to: `https://github.com/senthilinfo62/iOS_Template/settings/secrets/actions`

#### Secret 1: MATCH_PASSWORD
```
Name: MATCH_PASSWORD
Value: [Choose a strong password for certificate encryption]
Example: FastlaneMatch2024!SecureCerts#
```

#### Secret 2: MATCH_GIT_BASIC_AUTHORIZATION
```
Name: MATCH_GIT_BASIC_AUTHORIZATION
Value: c2VudGhpbGluZm82MjpnaHBfN2VFdXhONVlHUUNUdHR2MGpUM2F5dzNGVzBSUXlsM2xXYjFo
```

#### Secret 3: FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD
```
Name: FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD
Value: jdrz-grke-znrx-nzmj
```

## 🚀 Available Actions

### ios staging
```bash
[bundle exec] fastlane ios staging
```
**Purpose**: Build and deploy staging version to TestFlight
- **Bundle ID**: `com.nexware.template.stg`
- **Configuration**: Debug with staging settings
- **Target**: TestFlight internal testing
- **Trigger**: Automatic on push to `develop` branch

### ios production
```bash
[bundle exec] fastlane ios production
```
**Purpose**: Build and deploy production version to TestFlight
- **Bundle ID**: `com.nexware.template`
- **Configuration**: Release with production settings
- **Target**: TestFlight production testing
- **Trigger**: Automatic on push to `main` branch

### ios certificates
```bash
[bundle exec] fastlane ios certificates
```
**Purpose**: Download certificates and provisioning profiles
- **Type**: App Store distribution certificates
- **Storage**: Private git repository (`template-certificates`)
- **Encryption**: AES-256 with MATCH_PASSWORD

### ios test
```bash
[bundle exec] fastlane ios test
```
**Purpose**: Run unit and UI tests
- **Target**: iOS Simulator
- **Coverage**: Generate code coverage reports
- **Integration**: Works with CI/CD pipeline

### ios sync_team
```bash
[bundle exec] fastlane ios sync_team
```
**Purpose**: Sync team ID from Xcode project to Appfile
- **Automatic**: Runs before each build
- **Source**: Reads from `template.xcodeproj`
- **Updates**: `fastlane/Appfile` configuration

## 🔧 Local Development Setup

### 1. Generate Certificates (First Time)
```bash
# Set environment variable
export MATCH_PASSWORD="YourChosenStrongPassword"

# Generate development certificates
bundle exec fastlane match development

# Generate App Store certificates
bundle exec fastlane match appstore
```

### 2. Test Local Builds
```bash
# Test staging build
bundle exec fastlane staging

# Test production build
bundle exec fastlane production
```

## 🎯 CI/CD Pipeline

### Staging Workflow (`.github/workflows/staging.yml`)
- **Trigger**: Push to `develop` branch
- **Actions**: Build → Test → Deploy to TestFlight
- **Bundle ID**: `com.nexware.template.stg`

### Production Workflow (`.github/workflows/production.yml`)
- **Trigger**: Push to `main` branch
- **Actions**: Build → Test → Deploy to TestFlight
- **Bundle ID**: `com.nexware.template`

## 🔍 Troubleshooting

### Certificate Repository Access Error
```
fatal: could not read Username for 'https://github.com': terminal prompts disabled
```
**Solution**: Add `MATCH_GIT_BASIC_AUTHORIZATION` secret to GitHub repository.

### Bundle Installation Error
```
undefined method `untaint' for an instance of String (NoMethodError)
```
**Solution**: Ensure bundler 2.6.9 is used (already configured in workflows).

### Provisioning Profile Mismatch
```
Provisioning profile doesn't include signing certificate
```
**Solution**: Run `bundle exec fastlane match appstore --force` to regenerate profiles.

## 📱 Certificate Repository

- **Repository**: `https://github.com/senthilinfo62/template-certificates`
- **Type**: Private repository for secure certificate storage
- **Encryption**: AES-256 with password protection
- **Access**: Requires `MATCH_GIT_BASIC_AUTHORIZATION` for CI/CD

## 📚 Additional Resources

- [Fastlane Documentation](https://docs.fastlane.tools)
- [Fastlane Match Guide](https://docs.fastlane.tools/actions/match/)
- [TestFlight Deployment](https://docs.fastlane.tools/actions/upload_to_testflight/)
- [GitHub Actions Integration](https://docs.fastlane.tools/best-practices/continuous-integration/)

---

**🎉 Once GitHub secrets are configured, your TestFlight automation will be fully functional!**
