#!/bin/bash

# Validation script for CI/CD setup
# This script checks if all required files and configurations are in place

set -e

echo "🔍 Validating CI/CD Setup"
echo "========================="

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

success_count=0
total_checks=0

check_file() {
    local file=$1
    local description=$2
    total_checks=$((total_checks + 1))
    
    if [ -f "$file" ]; then
        echo -e "${GREEN}✅ $description${NC}"
        success_count=$((success_count + 1))
    else
        echo -e "${RED}❌ $description${NC}"
        echo "   Missing: $file"
    fi
}

check_directory() {
    local dir=$1
    local description=$2
    total_checks=$((total_checks + 1))
    
    if [ -d "$dir" ]; then
        echo -e "${GREEN}✅ $description${NC}"
        success_count=$((success_count + 1))
    else
        echo -e "${RED}❌ $description${NC}"
        echo "   Missing: $dir"
    fi
}

echo "Checking required files..."
echo ""

# Check Fastlane files
check_file "fastlane/Fastfile" "Fastlane configuration"
check_file "fastlane/Appfile" "Fastlane app configuration"
check_file "fastlane/Matchfile" "Fastlane match configuration"

# Check GitHub Actions
check_file ".github/workflows/staging.yml" "Staging workflow"
check_file ".github/workflows/production.yml" "Production workflow"

# Check configuration files
check_file "template/Configuration/Environment.swift" "Environment configuration"
check_file "template/Configuration/Staging.xcconfig" "Staging build configuration"
check_file "template/Configuration/Production.xcconfig" "Production build configuration"

# Check Ruby files
check_file "Gemfile" "Ruby dependencies"

# Check documentation
check_file "CI_CD_SETUP.md" "Setup documentation"
check_file "README_CICD.md" "CI/CD README"

# Check scripts
check_file "scripts/setup_ci_cd.sh" "Setup script"
check_directory "scripts" "Scripts directory"

# Check gitignore
check_file ".gitignore" "Git ignore file"

echo ""
echo "Checking Ruby environment..."

if command -v ruby &> /dev/null; then
    echo -e "${GREEN}✅ Ruby is installed${NC}"
    success_count=$((success_count + 1))
else
    echo -e "${RED}❌ Ruby is not installed${NC}"
fi
total_checks=$((total_checks + 1))

if command -v bundle &> /dev/null; then
    echo -e "${GREEN}✅ Bundler is available${NC}"
    success_count=$((success_count + 1))
else
    echo -e "${RED}❌ Bundler is not installed${NC}"
fi
total_checks=$((total_checks + 1))

if [ -f "Gemfile.lock" ]; then
    echo -e "${GREEN}✅ Ruby dependencies installed${NC}"
    success_count=$((success_count + 1))
else
    echo -e "${YELLOW}⚠️  Ruby dependencies not installed (run: bundle install)${NC}"
fi
total_checks=$((total_checks + 1))

echo ""
echo "Checking Fastlane..."

if bundle exec fastlane --version &> /dev/null; then
    echo -e "${GREEN}✅ Fastlane is working${NC}"
    success_count=$((success_count + 1))
else
    echo -e "${RED}❌ Fastlane is not working${NC}"
fi
total_checks=$((total_checks + 1))

echo ""
echo "Summary"
echo "======="

if [ $success_count -eq $total_checks ]; then
    echo -e "${GREEN}🎉 All checks passed! ($success_count/$total_checks)${NC}"
    echo ""
    echo "Your CI/CD setup is ready! 🚀"
    echo ""
    echo "Next steps:"
    echo "1. Configure GitHub Secrets"
    echo "2. Set up certificate repository"
    echo "3. Create App Store Connect apps"
    echo "4. Test with: bundle exec fastlane test"
else
    echo -e "${YELLOW}⚠️  $success_count/$total_checks checks passed${NC}"
    echo ""
    echo "Please fix the missing items above before proceeding."
fi

echo ""
echo "For detailed setup instructions, see: CI_CD_SETUP.md"
