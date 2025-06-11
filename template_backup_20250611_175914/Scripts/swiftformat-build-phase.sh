#!/bin/bash

# SwiftFormat Build Phase Script
# Add this as a "Run Script Phase" in Xcode Build Phases

if [[ "$(uname -m)" == arm64 ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi

if which swiftformat > /dev/null; then
    swiftformat .
else
    echo "warning: SwiftFormat not installed, download from https://github.com/nicklockwood/SwiftFormat"
fi
