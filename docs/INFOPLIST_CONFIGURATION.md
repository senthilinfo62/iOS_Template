# Info.plist Configuration Guide

Since the project uses Xcode's auto-generated Info.plist approach, you need to configure the Info.plist settings through Xcode's Build Settings.

## Required Configuration Steps

### 1. Open Xcode Project
```bash
open template.xcodeproj
```

### 2. Configure Build Settings

1. Select the project in the navigator
2. Select the 'template' target
3. Go to Build Settings tab
4. Search for "Info.plist" or scroll to "Packaging"

### 3. Add Required Info.plist Keys

Add these keys in Build Settings (search for each key name):

#### App Information
- `PRODUCT_NAME` = `$(TARGET_NAME)`
- `PRODUCT_BUNDLE_IDENTIFIER` = `com.nexware.template`
- `MARKETING_VERSION` = `1.0`
- `CURRENT_PROJECT_VERSION` = `1`

#### Privacy Usage Descriptions
Add these as custom build settings (Build Settings → + → Add User-Defined Setting):

- `INFOPLIST_KEY_NSCameraUsageDescription` = `This app needs camera access to take photos for your profile and content.`
- `INFOPLIST_KEY_NSPhotoLibraryUsageDescription` = `This app needs photo library access to select and save images.`
- `INFOPLIST_KEY_NSLocationWhenInUseUsageDescription` = `This app needs location access to provide location-based features.`
- `INFOPLIST_KEY_NSMicrophoneUsageDescription` = `This app needs microphone access to record audio for voice messages.`
- `INFOPLIST_KEY_NSContactsUsageDescription` = `This app needs contacts access to help you connect with friends.`
- `INFOPLIST_KEY_NSFaceIDUsageDescription` = `This app uses Face ID for secure authentication.`
- `INFOPLIST_KEY_NSUserTrackingUsageDescription` = `This app would like to track your activity to provide personalized content.`

#### Background Modes
- `INFOPLIST_KEY_UIBackgroundModes` = `background-fetch background-processing remote-notification`

#### URL Schemes
- `INFOPLIST_KEY_CFBundleURLTypes` = `[{"CFBundleURLName": "com.nexware.template.url", "CFBundleURLSchemes": ["iostemplate"]}]`

#### App Transport Security
Add as custom build setting:
- `INFOPLIST_KEY_NSAppTransportSecurity` = `{"NSAllowsArbitraryLoads": false, "NSExceptionDomains": {"yourapp.com": {"NSExceptionRequiresForwardSecrecy": false, "NSExceptionMinimumTLSVersion": "TLSv1.2", "NSIncludesSubdomains": true}}}`

### 4. Alternative: Use Info.plist File

If you prefer to use a custom Info.plist file:

1. In Build Settings, set `Generate Info.plist File` to `No`
2. Set `Info.plist File` to `template/Info.plist.reference`
3. Rename `template/Info.plist.reference` back to `template/Info.plist`
4. Make sure the Info.plist file is NOT in the "Copy Bundle Resources" build phase

### 5. Verify Configuration

1. Build the project to ensure no conflicts
2. Check that all privacy permissions work correctly
3. Test URL schemes and background modes

## Reference Info.plist Content

The complete Info.plist content is available in `template/Info.plist.reference` for reference.

## Troubleshooting

If you still get "Multiple commands produce Info.plist" error:

1. Clean Build Folder (Product → Clean Build Folder)
2. Delete Derived Data (~/Library/Developer/Xcode/DerivedData/template-*)
3. Ensure Info.plist is not in Copy Bundle Resources build phase
4. Restart Xcode

## Recommended Approach

For simplicity, we recommend using the auto-generated Info.plist approach with build settings configuration. This avoids conflicts and is the modern Xcode way.
