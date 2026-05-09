#!/bin/bash
set -e

# Path to the version file
VERSION_FILE=".hugo-version"

if [ ! -f "$VERSION_FILE" ]; then
    echo "Error: $VERSION_FILE not found."
    exit 1
fi

REQUIRED_VERSION=$(cat "$VERSION_FILE")

# Function to check version
check_version() {
    local cmd=$1
    if command -v "$cmd" >/dev/null 2>&1; then
        local version=$("$cmd" version | awk '{print $2}' | sed 's/v//' | cut -d'+' -f1)
        if [[ "$version" == "$REQUIRED_VERSION" ]]; then
            echo "$cmd"
            return 0
        fi
    fi
    return 1
}

# 1. Check if 'hugo' is the right version
HUGO_CMD=$(check_version "hugo")

# 2. If not, and we are in a CI environment, we might want to fail or install it
if [ -z "$HUGO_CMD" ]; then
    echo "Warning: System 'hugo' version does not match $REQUIRED_VERSION"
    echo "Attempting to run with available 'hugo' anyway..."
    HUGO_CMD="hugo"
fi

exec $HUGO_CMD "$@"
