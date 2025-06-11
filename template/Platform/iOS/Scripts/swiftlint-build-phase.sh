#!/bin/bash

# SwiftLint Build Phase Script
# Add this as a "Run Script Phase" in Xcode Build Phases

if [[ "$(uname -m)" == arm64 ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi

if which swiftlint > /dev/null; then
    swiftlint
else
    echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
