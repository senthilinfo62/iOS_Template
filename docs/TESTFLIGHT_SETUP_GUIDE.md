# 🚀 Complete TestFlight Setup Guide

## 📱 Overview

This guide will walk you through setting up TestFlight uploads for your iOS app using Fastlane Match for certificate management.

## 🎯 What You'll Achieve

- ✅ Automatic certificate management
- ✅ TestFlight uploads from CI/CD
- ✅ Separate staging and production builds
- ✅ Secure credential storage

## 📋 Prerequisites

### Required Accounts & Access
- [ ] **Apple Developer Account** (paid membership - $99/year)
- [ ] **App Store Connect access** with App Manager role
- [ ] **GitHub account** with repository access
- [ ] **Two-Factor Authentication** enabled on Apple ID

### Required Information
- **Apple ID**: `senthilinfo62@gmail.com`
- **Team ID**: `FC25M3HCWJ`
- **Bundle IDs**: 
  - Production: `com.ios.template`
  - Staging: `com.ios.template.stg`

## 🚀 Step-by-Step Setup

### Step 1: Create Certificate Repository

1. **Create Private GitHub Repository:**
   - Go to GitHub
   - Create new repository: `certificates`
   - **Make it PRIVATE** (critical for security)
   - URL: `https://github.com/senthilinfo62/certificates`

### Step 2: Create App in App Store Connect

1. **Go to App Store Connect:**
   - Visit [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
   - Sign in with `senthilinfo62@gmail.com`

2. **Create New App:**
   - Click "My Apps" → "+" → "New App"
   - **Platform**: iOS
   - **Name**: Your app name
   - **Bundle ID**: `com.ios.template`
   - **SKU**: Unique identifier

3. **Create Staging App (Optional):**
   - Repeat for staging with Bundle ID: `com.ios.template.stg`

### Step 3: Generate App-Specific Password

1. **Go to Apple ID Account:**
   - Visit [appleid.apple.com](https://appleid.apple.com)
   - Sign in with `senthilinfo62@gmail.com`

2. **Generate Password:**
   - Security → App-Specific Passwords
   - Generate new password
   - Label: "Fastlane CI/CD"
   - **Save this password** for GitHub secrets

### Step 4: Run Certificate Setup

```bash
# Make script executable
chmod +x scripts/setup_certificates.sh

# Run the setup script
./scripts/setup_certificates.sh
```

This will:
- Generate development certificates
- Generate App Store certificates
- Create provisioning profiles
- Store everything securely in git

### Step 5: Configure GitHub Secrets

Add these secrets to your GitHub repository (Settings → Secrets → Actions):

1. **MATCH_PASSWORD**: Password you chose during Match setup
2. **MATCH_GIT_BASIC_AUTHORIZATION**: Base64 encoded git credentials
3. **FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD**: App-specific password
4. **FASTLANE_SESSION**: Session token (optional)

### Step 6: Test the Setup

```bash
# Test staging build
bundle exec fastlane staging

# Test production build  
bundle exec fastlane production
```

## 🔐 Security Best Practices

- ✅ Use private repository for certificates
- ✅ Use strong passwords for Match
- ✅ Rotate certificates annually
- ✅ Never commit certificates to main repository
- ✅ Use GitHub secrets for sensitive data

## 🚨 Troubleshooting

### Common Issues

1. **"No matching provisioning profiles"**
   - Run: `bundle exec fastlane match appstore --force`

2. **"Invalid credentials"**
   - Check GitHub secrets are correctly set
   - Verify app-specific password

3. **"Bundle ID not found"**
   - Create app in App Store Connect first
   - Verify bundle identifier matches

### Getting Help

- Check Fastlane logs for detailed error messages
- Verify all prerequisites are completed
- Ensure certificates repository is accessible
