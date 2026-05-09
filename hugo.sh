#!/bin/bash

# Path to the version file
VERSION_FILE=".hugo-version"

if [ ! -f "$VERSION_FILE" ]; then
    echo "Error: $VERSION_FILE not found."
    exit 1
fi

# Read version and strip any whitespace/newlines
REQUIRED_VERSION=$(cat "$VERSION_FILE" | tr -d '[:space:]')

# Function to check version
check_version() {
    local cmd=$1
    if command -v "$cmd" >/dev/null 2>&1; then
        # Hugo version output format: "hugo v0.160.1-d6bc8165...+extended ..."
        # We extract the version part (e.g. 0.160.1)
        local version=$("$cmd" version | awk '{print $2}' | sed 's/v//' | sed 's/-.*//' | cut -d'+' -f1)
        if [[ "$version" == "$REQUIRED_VERSION" ]]; then
            echo "$cmd"
            return 0
        fi
    fi
    return 1
}

# 1. Check if 'hugo' is the right version
# We use || true to avoid failing if the version doesn't match
HUGO_CMD=$(check_version "hugo" || true)

if [ -z "$HUGO_CMD" ]; then
    echo "Warning: System 'hugo' version does not match REQUIRED_VERSION ($REQUIRED_VERSION)"
    echo "Current version info: $(hugo version 2>&1 || echo 'hugo not found')"
    echo "Attempting to run with available 'hugo' anyway..."
    HUGO_CMD="hugo"
fi

exec $HUGO_CMD "$@"
