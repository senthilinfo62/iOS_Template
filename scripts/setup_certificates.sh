#!/bin/bash

# Certificate Setup Script for TestFlight
# Run this script to set up certificates for your iOS app

set -e

echo "🔐 iOS Certificate Setup for TestFlight"
echo "======================================"
echo ""

# Check if we're in the right directory
if [ ! -f "fastlane/Matchfile" ]; then
    echo "❌ Error: Please run this script from the project root directory"
    exit 1
fi

echo "📋 Prerequisites Check:"
echo "----------------------"
echo "✅ Make sure you have:"
echo "   - Apple Developer Account (paid membership)"
echo "   - Created private repository: https://github.com/senthilinfo62/certificates"
echo "   - App created in App Store Connect"
echo "   - Two-factor authentication enabled"
echo ""

read -p "Have you completed all prerequisites? (y/n): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Please complete prerequisites first"
    exit 1
fi

echo ""
echo "🚀 Step 1: Generate Development Certificates"
echo "-------------------------------------------"
echo "This will create development certificates and provisioning profiles"
echo ""

# Generate development certificates
echo "Running: bundle exec fastlane match development"
bundle exec fastlane match development

echo ""
echo "🚀 Step 2: Generate App Store Certificates"
echo "------------------------------------------"
echo "This will create distribution certificates for TestFlight"
echo ""

# Generate App Store certificates
echo "Running: bundle exec fastlane match appstore"
bundle exec fastlane match appstore

echo ""
echo "✅ Certificate Setup Complete!"
echo "=============================="
echo ""
echo "📱 Next Steps:"
echo "1. Set up GitHub Secrets (see docs/CERTIFICATE_SETUP.md)"
echo "2. Update your bundle identifiers if needed"
echo "3. Test the staging build: bundle exec fastlane staging"
echo ""
echo "🔐 Important: Remember the password you set for Match!"
echo "You'll need it for GitHub Actions secrets."
