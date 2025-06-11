# CI/CD Pipeline Setup Guide

This document explains how to set up and use the CI/CD pipeline for automatic builds and TestFlight uploads.

## Overview

The CI/CD pipeline automatically builds and deploys your iOS app to TestFlight with different configurations:

- **Staging**: `com.ios.template.stg` - For QA testing
- **Production**: `com.ios.template` - For production releases

## Prerequisites

### 1. Apple Developer Account Setup
- Ensure you have an active Apple Developer account
- Create App Store Connect apps for both bundle identifiers:
  - `com.ios.template.stg` (Staging)
  - `com.ios.template` (Production)

### 2. Certificate Management
Create a separate repository for storing certificates and provisioning profiles:
```bash
# Create a new private repository named 'certificates'
# Update the git_url in fastlane/Matchfile if different
```

### 3. GitHub Secrets Configuration
Add the following secrets to your GitHub repository:

#### Required Secrets:
- `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD`: App-specific password for your Apple ID
- `FASTLANE_SESSION`: Fastlane session token (optional, for 2FA)
- `MATCH_PASSWORD`: Password for encrypting certificates
- `MATCH_GIT_BASIC_AUTHORIZATION`: Base64 encoded git credentials for certificate repo

#### Optional Secrets:
- `SLACK_URL`: Slack webhook URL for notifications

## Setup Instructions

### 1. Install Dependencies
```bash
# Install Ruby dependencies
bundle install

# Install Fastlane (if not using bundle)
gem install fastlane
```

### 2. Initialize Match (First Time Only)
```bash
# Initialize match for certificate management
bundle exec fastlane match init

# Generate certificates and provisioning profiles
bundle exec fastlane match appstore
```

### 3. Configure Xcode Project
1. Add the configuration files to your Xcode project:
   - `template/Configuration/Staging.xcconfig`
   - `template/Configuration/Production.xcconfig`

2. Create new build configurations in Xcode:
   - Duplicate "Debug" → "Staging"
   - Duplicate "Release" → "Production"
   - Set configuration files for each

## Workflow Triggers

### Staging Builds
Triggered on:
- Push to `develop` branch
- Push to `staging` branch
- Pull requests to `develop`

### Production Builds
Triggered on:
- Push to `main` or `master` branch
- GitHub releases

## Fastlane Lanes

### Available Lanes:
```bash
# Run tests
bundle exec fastlane test

# Build and upload staging
bundle exec fastlane staging

# Build and upload production
bundle exec fastlane production

# Download certificates
bundle exec fastlane certificates
```

## Environment Configuration

The app uses different configurations based on the build:

### Staging Environment:
- Bundle ID: `com.ios.template.stg`
- App Name: "Template STG"
- API Base URL: `https://staging-api.yourapp.com`
- Analytics: Disabled
- Logging: Verbose

### Production Environment:
- Bundle ID: `com.ios.template`
- App Name: "Template"
- API Base URL: `https://api.yourapp.com`
- Analytics: Enabled
- Logging: Error only

## TestFlight Groups

### Staging Builds:
- QA Team
- Internal Testers

### Production Builds:
- External Testers

## Troubleshooting

### Common Issues:

1. **Certificate Issues**
   ```bash
   # Reset certificates
   bundle exec fastlane match nuke appstore
   bundle exec fastlane match appstore
   ```

2. **Build Number Conflicts**
   - Build numbers are automatically incremented
   - Ensure App Store Connect apps exist for both bundle IDs

3. **2FA Issues**
   - Use app-specific passwords
   - Set up FASTLANE_SESSION for persistent sessions

### Getting Help:
- Check GitHub Actions logs for detailed error messages
- Verify all secrets are properly configured
- Ensure certificate repository access is working

## Security Notes

- Never commit certificates or private keys to the repository
- Use GitHub Secrets for all sensitive information
- Regularly rotate app-specific passwords
- Keep the certificate repository private and secure

## Monitoring

- GitHub Actions provide build status and logs
- Slack notifications (if configured) provide real-time updates
- TestFlight provides build processing status
