#!/bin/bash

# Script to generate MATCH_GIT_BASIC_AUTHORIZATION for GitHub secrets
# This encodes your GitHub credentials for Fastlane Match

echo "🔐 GitHub Credentials Encoder for Fastlane Match"
echo "================================================"
echo ""

echo "📋 You need:"
echo "1. Your GitHub username: senthilinfo62"
echo "2. A GitHub Personal Access Token with 'repo' scope"
echo ""

echo "🔗 To create a Personal Access Token:"
echo "1. Go to: https://github.com/settings/tokens"
echo "2. Click 'Generate new token (classic)'"
echo "3. Set expiration and check 'repo' scope"
echo "4. Copy the generated token"
echo ""

read -p "Enter your GitHub Personal Access Token: " -s GITHUB_TOKEN
echo ""

if [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ No token provided. Exiting."
    exit 1
fi

# Generate the base64 encoded credentials
USERNAME="senthilinfo62"
CREDENTIALS="$USERNAME:$GITHUB_TOKEN"
ENCODED=$(echo -n "$CREDENTIALS" | base64)

echo ""
echo "✅ Generated MATCH_GIT_BASIC_AUTHORIZATION:"
echo "=========================================="
echo "$ENCODED"
echo ""
echo "📋 Copy this value and add it as a GitHub secret:"
echo "Repository → Settings → Secrets → Actions → New repository secret"
echo "Name: MATCH_GIT_BASIC_AUTHORIZATION"
echo "Value: $ENCODED"
echo ""
echo "🔐 Also remember to set:"
echo "MATCH_PASSWORD = [your chosen strong password]"
echo "FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD = jdrz-grke-znrx-nzmj"
