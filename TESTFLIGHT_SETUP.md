# 🚀 TestFlight Integration Setup Guide

This guide will help you complete the TestFlight integration for your iOS template project.

## 📋 Current Status

✅ **Completed:**
- Bundle identifiers updated to `com.nexware.template`
- Certificate repository created: `https://github.com/senthilinfo62/template-certificates`
- App IDs created in Apple Developer Portal
- Certificates generated locally
- GitHub Actions workflows configured
- Bundler compatibility fixed for Ruby 3.3

⚠️ **Remaining:** Add GitHub Secrets (5 minutes)

## 🔐 Add GitHub Secrets (Final Step)

### Step 1: Go to GitHub Repository Settings
Navigate to: `https://github.com/senthilinfo62/iOS_Template/settings/secrets/actions`

### Step 2: Add These 6 Secrets

Click **"New repository secret"** for each:

#### Secret 1: MATCH_PASSWORD
```
Name: MATCH_PASSWORD
Value: FastlaneMatch2024!SecureCerts#
```
*Choose your own strong password for certificate encryption*

#### Secret 2: MATCH_GIT_BASIC_AUTHORIZATION
```
Name: MATCH_GIT_BASIC_AUTHORIZATION
Value: c2VudGhpbGluZm82MjpnaHBfN2VFdXhONVlHUUNUdHR2MGpUM2F5dzNGVzBSUXlsM2xXYjFo
```
*This is your GitHub credentials encoded in base64*

#### Secret 3: FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD
```
Name: FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD
Value: jdrz-grke-znrx-nzmj
```
*Your Apple app-specific password for TestFlight uploads*

#### Secret 4: FASTLANE_PASSWORD
```
Name: FASTLANE_PASSWORD
Value: [Your Apple Developer account password]
```
*Your Apple Developer account password for certificate generation*

#### Secret 5: FASTLANE_SESSION (For 2FA)
```
Name: FASTLANE_SESSION
Value: [Generated session token - see instructions below]
```
*Session token to bypass 2FA in CI/CD - expires periodically*

#### Secret 6: SPACESHIP_2FA_SMS_DEFAULT_PHONE_NUMBER (Optional)
```
Name: SPACESHIP_2FA_SMS_DEFAULT_PHONE_NUMBER
Value: +1234567890
```
*Your phone number for 2FA SMS (format: +countrycode+number)*

## 🔐 How to Generate FASTLANE_SESSION (2FA Bypass)

Since your Apple Developer account has 2-Factor Authentication enabled, you need to generate a session token:

### Method 1: Using Our Script (Recommended)
```bash
# Run the session generator script
cd /Users/senthilkumarmaruthasalam/Documents/template
ruby scripts/generate_fastlane_session.rb
```

### Method 2: Manual Generation
```bash
# Install spaceship gem if needed
gem install spaceship

# Generate session interactively
fastlane spaceauth -u senthilkumar.m@nexware-global.com
```

### Method 3: Using Fastlane Command
```bash
# Generate session with fastlane
bundle exec fastlane run spaceship_login username:senthilkumar.m@nexware-global.com
```

**Important Notes:**
- The session token will expire after some time (usually 30 days)
- You'll need to regenerate it when it expires
- Keep the token secure - it provides access to your Apple Developer account

## 🎯 What Happens After Adding Secrets

Once you add these secrets, your CI/CD pipeline will:

1. ✅ **Clone certificate repository** successfully
2. ✅ **Download certificates** and provisioning profiles
3. ✅ **Build iOS app** for device (not just simulator)
4. ✅ **Upload to TestFlight** automatically
5. ✅ **Send notifications** about build status

## 🚀 Automated Workflows

### Staging Builds
- **Trigger**: Push to `develop` branch
- **Bundle ID**: `com.nexware.template.stg`
- **TestFlight**: Internal testing

### Production Builds
- **Trigger**: Push to `main` branch
- **Bundle ID**: `com.nexware.template`
- **TestFlight**: Production testing

## 🧪 Test Your Setup

After adding secrets, test the integration:

```bash
# Make a test change
echo "# TestFlight Ready!" >> README.md
git add README.md
git commit -m "test: Verify complete TestFlight integration"
git push origin develop
```

Then monitor: `https://github.com/senthilinfo62/iOS_Template/actions`

## 🔍 Expected Results

### Before Adding Secrets (Current):
```
fatal: could not read Username for 'https://github.com': terminal prompts disabled
⚠️ Match failed: Error cloning certificates git repo
Using locally installed certificates...
✅ Simulator build completed
```

### After Adding Secrets (Goal):
```
✅ Successfully cloned certificate repository
✅ Downloaded certificates and provisioning profiles
✅ Built iOS app for device
✅ Uploaded to TestFlight successfully
🎉 Build available for testing
```

## 📱 Apple Developer Portal

Your apps are already configured:

- **Production App**: `com.nexware.template` (ID: 44RP8BK62Z)
- **Staging App**: `com.nexware.template.stg` (ID: QW8XZ2VH49)
- **Certificates**: App Store distribution certificates generated
- **Profiles**: Provisioning profiles created for both apps

## 🎉 You're Almost There!

**The hard work is done!** Your iOS template project has:

- ✅ Complete CI/CD pipeline configured
- ✅ Automatic TestFlight uploads ready
- ✅ Separate staging and production environments
- ✅ Professional deployment workflow
- ✅ Certificate management system

**Just add those 3 GitHub secrets and you'll have a fully automated TestFlight integration!** 🚀✨

---

## 📞 Need Help?

If you encounter any issues after adding the secrets:

1. **Check GitHub Actions logs**: Look for specific error messages
2. **Verify secrets**: Ensure all 3 secrets are added correctly
3. **Certificate issues**: Run `bundle exec fastlane match appstore --force` locally
4. **TestFlight access**: Verify your Apple ID has TestFlight permissions

**Your TestFlight automation is 99% complete - just one configuration step away!**
