#!/bin/bash

# CI/CD Setup Script for iOS Template App
# This script helps set up the CI/CD pipeline

set -e

echo "🚀 Setting up CI/CD Pipeline for iOS Template App"
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if required tools are installed
echo "Checking prerequisites..."

# Check if Ruby is installed
if ! command -v ruby &> /dev/null; then
    print_error "Ruby is not installed. Please install Ruby first."
    exit 1
fi
print_status "Ruby is installed"

# Check if Bundler is installed
if ! command -v bundle &> /dev/null; then
    echo "Installing Bundler..."
    gem install bundler
fi
print_status "Bundler is available"

# Check if Git is installed
if ! command -v git &> /dev/null; then
    print_error "Git is not installed. Please install Git first."
    exit 1
fi
print_status "Git is available"

# Install Ruby dependencies
echo ""
echo "Installing Ruby dependencies..."
bundle install
print_status "Ruby dependencies installed"

# Check if Xcode is available (macOS only)
if [[ "$OSTYPE" == "darwin"* ]]; then
    if ! command -v xcodebuild &> /dev/null; then
        print_error "Xcode is not installed. Please install Xcode from the App Store."
        exit 1
    fi
    print_status "Xcode is available"
fi

echo ""
echo "🔧 Configuration Steps"
echo "====================="

print_warning "Manual steps required:"
echo ""
echo "1. 📱 Create App Store Connect Apps:"
echo "   - Production: com.nexware.template"
echo "   - Staging: com.nexware.template.stg"
echo ""
echo "2. 🔐 Set up GitHub Secrets:"
echo "   - FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD"
echo "   - MATCH_PASSWORD"
echo "   - MATCH_GIT_BASIC_AUTHORIZATION"
echo "   - SLACK_URL (optional)"
echo ""
echo "3. 📋 Create Certificate Repository:"
echo "   - Create private repo: https://github.com/senthilinfo62/certificates"
echo "   - Update fastlane/Matchfile if using different URL"
echo ""
echo "4. 🏗️ Configure Xcode Project:"
echo "   - Add Configuration files to Xcode project"
echo "   - Create Staging and Production build configurations"
echo ""

# Ask if user wants to initialize certificates
echo ""
read -p "Do you want to initialize certificates now? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Initializing certificates..."
    
    # Check if certificate repo exists
    if bundle exec fastlane match init; then
        print_status "Match initialized successfully"
        
        echo "Generating certificates and provisioning profiles..."
        if bundle exec fastlane certificates; then
            print_status "Certificates generated successfully"
        else
            print_warning "Certificate generation failed. You may need to set up the certificate repository first."
        fi
    else
        print_warning "Match initialization failed. Please check your configuration."
    fi
fi

echo ""
echo "🧪 Testing Setup"
echo "==============="

# Test if we can run fastlane
if bundle exec fastlane --version &> /dev/null; then
    print_status "Fastlane is working correctly"
else
    print_error "Fastlane setup has issues"
fi

echo ""
echo "✅ Setup Complete!"
echo "=================="
echo ""
echo "Next steps:"
echo "1. Complete the manual configuration steps above"
echo "2. Test the pipeline with: bundle exec fastlane test"
echo "3. Push to develop branch to trigger staging build"
echo "4. Push to main branch to trigger production build"
echo ""
echo "📚 For detailed instructions, see: CI_CD_SETUP.md"
echo ""
print_status "CI/CD Pipeline setup completed successfully!"
