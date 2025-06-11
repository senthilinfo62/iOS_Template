#!/bin/bash

# Fix Alamofire Dependency Script
# Run this script whenever you get "Missing package product 'Alamofire'" error

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔧 Fixing Alamofire Dependency Issue${NC}"
echo "====================================="

# Function to clean and reset dependencies
fix_alamofire_dependency() {
    echo -e "\n${BLUE}🧹 Cleaning derived data and package cache...${NC}"
    
    # Remove derived data
    rm -rf ~/Library/Developer/Xcode/DerivedData/template-* 2>/dev/null || true
    echo -e "${GREEN}✅ Derived data cleaned${NC}"
    
    # Remove Swift package cache
    rm -rf template.xcodeproj/project.xcworkspace/xcshareddata/swiftpm 2>/dev/null || true
    echo -e "${GREEN}✅ Swift package cache cleared${NC}"
    
    echo -e "\n${BLUE}📦 Resolving package dependencies...${NC}"
    
    # Resolve package dependencies
    xcodebuild -project template.xcodeproj -resolvePackageDependencies
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Package dependencies resolved successfully${NC}"
    else
        echo -e "${RED}❌ Failed to resolve package dependencies${NC}"
        exit 1
    fi
    
    echo -e "\n${BLUE}🔨 Testing build...${NC}"
    
    # Test build
    xcodebuild -project template.xcodeproj -scheme template -destination 'platform=iOS Simulator,name=iPhone 16' build -quiet
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Build successful! Alamofire dependency fixed${NC}"
    else
        echo -e "${RED}❌ Build failed. Please check the error messages above${NC}"
        exit 1
    fi
}

# Function to verify Alamofire is properly configured
verify_alamofire_config() {
    echo -e "\n${BLUE}🔍 Verifying Alamofire configuration...${NC}"
    
    # Check if Package.resolved exists and contains Alamofire
    if [ -f "template.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved" ]; then
        if grep -q "alamofire" "template.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved"; then
            echo -e "${GREEN}✅ Alamofire found in Package.resolved${NC}"
        else
            echo -e "${YELLOW}⚠️  Alamofire not found in Package.resolved${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  Package.resolved not found${NC}"
    fi
    
    # Check if project.pbxproj contains Alamofire references
    if grep -q "Alamofire" "template.xcodeproj/project.pbxproj"; then
        echo -e "${GREEN}✅ Alamofire references found in project file${NC}"
    else
        echo -e "${RED}❌ Alamofire references missing from project file${NC}"
        echo -e "${YELLOW}   This might require manual Xcode configuration${NC}"
    fi
}

# Function to provide troubleshooting tips
provide_troubleshooting_tips() {
    echo -e "\n${BLUE}💡 Troubleshooting Tips:${NC}"
    echo "========================"
    echo "1. If the issue persists, try opening Xcode and:"
    echo "   - Go to File → Swift Packages → Reset Package Caches"
    echo "   - Clean Build Folder (Cmd+Shift+K)"
    echo "   - Rebuild (Cmd+B)"
    echo ""
    echo "2. If Alamofire is still missing:"
    echo "   - Open template.xcodeproj in Xcode"
    echo "   - Select the project in navigator"
    echo "   - Go to Package Dependencies tab"
    echo "   - Verify Alamofire is listed"
    echo "   - If not, add it manually: https://github.com/Alamofire/Alamofire.git"
    echo ""
    echo "3. Alternative: Use this script whenever the issue occurs:"
    echo "   ./scripts/fix_alamofire_dependency.sh"
}

# Main function
main() {
    echo -e "${BLUE}Starting Alamofire dependency fix...${NC}"
    
    # Verify we're in the right directory
    if [ ! -f "template.xcodeproj/project.pbxproj" ]; then
        echo -e "${RED}❌ Error: template.xcodeproj not found in current directory${NC}"
        echo -e "${YELLOW}   Please run this script from the project root directory${NC}"
        exit 1
    fi
    
    # Run the fix
    fix_alamofire_dependency
    
    # Verify configuration
    verify_alamofire_config
    
    # Provide tips
    provide_troubleshooting_tips
    
    echo -e "\n${GREEN}🎉 Alamofire dependency fix complete!${NC}"
    echo -e "${BLUE}You can now build and run your app successfully.${NC}"
}

# Run main function
main
