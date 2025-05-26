#!/bin/bash
# setup_env.sh
# This script helps set up the environment variables for macOS/Linux

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "Error: .env file not found. Please create it from .env.example"
    exit 1
fi

# Source the .env file
export $(grep -v '^#' .env | xargs)

# Create strings.xml from example
if [ ! -f "android/app/src/main/res/values/strings.xml.example" ]; then
    echo "Error: android/app/src/main/res/values/strings.xml.example not found"
    exit 1
fi

# Create strings.xml with environment variables
envsubst < android/app/src/main/res/values/strings.xml.example > android/app/src/main/res/values/strings.xml

echo "Environment setup complete!"
