# 🔐 Certificate Setup Guide for TestFlight

## 📋 Prerequisites Checklist

- [ ] Apple Developer Account (paid membership)
- [ ] App created in App Store Connect
- [ ] Private GitHub repository for certificates
- [ ] Two-factor authentication enabled

## 🚀 Step-by-Step Setup

### Step 1: Initialize Fastlane Match

Run this command in your project root:

```bash
bundle exec fastlane match init
```

When prompted:
1. **Storage mode**: Select `git`
2. **Git URL**: Enter your private repository URL
   ```
   https://github.com/senthilinfo62/ios-certificates.git
   ```

### Step 2: Create Development Certificates

```bash
bundle exec fastlane match development
```

This will:
- Create development certificates
- Create development provisioning profiles
- Store them securely in your git repository

### Step 3: Create App Store Certificates

```bash
bundle exec fastlane match appstore
```

This will:
- Create distribution certificates
- Create App Store provisioning profiles
- Enable TestFlight uploads

### Step 4: Set Up GitHub Secrets

Add these secrets to your GitHub repository:

1. **Go to GitHub Repository Settings:**
   - Navigate to your iOS_Template repository
   - Go to Settings → Secrets and variables → Actions
   - Click "New repository secret"

2. **Add Required Secrets:**

#### MATCH_PASSWORD
- **Name**: `MATCH_PASSWORD`
- **Value**: The password you chose when running `fastlane match`
- **Purpose**: Encrypts/decrypts certificates in git repository

#### MATCH_GIT_BASIC_AUTHORIZATION
- **Name**: `MATCH_GIT_BASIC_AUTHORIZATION`
- **Value**: Base64 encoded git credentials
- **How to generate**:
  ```bash
  echo -n "username:personal_access_token" | base64
  ```
  Replace with your GitHub username and personal access token

#### FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD
- **Name**: `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD`
- **Value**: App-specific password from Apple ID account
- **How to get**: appleid.apple.com → Security → Generate Password

#### FASTLANE_SESSION (Optional)
- **Name**: `FASTLANE_SESSION`
- **Value**: Session token for 2FA bypass
- **How to generate**:
  ```bash
  fastlane spaceauth -u senthilinfo62@gmail.com
  ```

### Step 5: Update Bundle Identifiers

Update your app bundle identifiers:
- **Production**: `com.yourcompany.yourapp`
- **Staging**: `com.yourcompany.yourapp.stg`

## 🔧 Configuration Files

Your Matchfile should look like this:

```ruby
git_url("https://github.com/senthilinfo62/ios-certificates.git")
storage_mode("git")
type("development") # Can be appstore, adhoc, development, enterprise
app_identifier(["com.yourcompany.yourapp", "com.yourcompany.yourapp.stg"])
username("senthilinfo62@gmail.com")
```

## 🚨 Security Notes

- Never commit certificates to your main repository
- Use a separate private repository for certificates
- Use strong passwords for Match
- Rotate certificates annually
