#!/bin/bash

# Script to automatically sync team ID from Xcode project to Fastlane Appfile
# Usage: ./scripts/sync_team_id.sh

set -e

# Determine project file path (handle both local and CI environments)
if [ -f "template.xcodeproj/project.pbxproj" ]; then
    PROJECT_FILE="template.xcodeproj/project.pbxproj"
elif [ -f "../template.xcodeproj/project.pbxproj" ]; then
    PROJECT_FILE="../template.xcodeproj/project.pbxproj"
else
    echo "❌ Could not find template.xcodeproj/project.pbxproj"
    exit 1
fi

# Determine Appfile path (handle both local and CI environments)
if [ -f "fastlane/Appfile" ]; then
    APPFILE="fastlane/Appfile"
elif [ -f "../fastlane/Appfile" ]; then
    APPFILE="../fastlane/Appfile"
else
    echo "❌ Could not find fastlane/Appfile"
    exit 1
fi

echo "🔍 Reading team ID from Xcode project..."
echo "📁 Project file: $PROJECT_FILE"
echo "📁 Appfile: $APPFILE"

# Extract team ID from the main app target (first occurrence)
TEAM_ID=$(grep -m 1 "DEVELOPMENT_TEAM = " "$PROJECT_FILE" | sed 's/.*DEVELOPMENT_TEAM = \(.*\);/\1/' | tr -d ' ')

if [ -z "$TEAM_ID" ]; then
    echo "❌ No team ID found in Xcode project"
    exit 1
fi

echo "📱 Found team ID: $TEAM_ID"

# Check if Appfile exists
if [ ! -f "$APPFILE" ]; then
    echo "❌ Appfile not found at $APPFILE"
    exit 1
fi

echo "📝 Updating Appfile with team ID: $TEAM_ID"

# Update team_id in Appfile
sed -i '' "s/team_id(\".*\")/team_id(\"$TEAM_ID\")/" "$APPFILE"

# Update itc_team_id in Appfile  
sed -i '' "s/itc_team_id(\".*\")/itc_team_id(\"$TEAM_ID\")/" "$APPFILE"

echo "✅ Appfile updated successfully!"
echo ""
echo "📋 Current Appfile configuration:"
cat "$APPFILE"
