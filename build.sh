#!/bin/bash

# Detect OS
OS="$(uname -s)"
ARCH="$(uname -m)"

echo "Detected system: $OS on $ARCH architecture"

# Default platform
PLATFORM_FLAG=""

# Handle Apple Silicon Macs
if [ "$OS" = "Darwin" ] && [ "$ARCH" = "arm64" ]; then
    echo "Detected Apple Silicon Mac (M1/M2/M3)"
    read -p "Build for ARM64 architecture? (Y/n, default is Y): " USE_ARM
    
    if [ "$USE_ARM" = "n" ] || [ "$USE_ARM" = "N" ]; then
        echo "Building for x86_64 architecture with Rosetta emulation..."
        PLATFORM_FLAG="--platform linux/amd64"
    else
        echo "Building for native ARM64 architecture..."
        PLATFORM_FLAG="--platform linux/arm64/v8"
    fi
fi

# Build the Bitnami root Spark Docker image
echo "Building Bitnami root Spark Docker image..."
docker build $PLATFORM_FLAG -t bitnami-root-spark .

# Check if the build was successful
if [ $? -eq 0 ]; then
    echo "Docker image built successfully!"
    echo "You can now run 'docker-compose up -d' to start the Spark cluster."
else
    echo "Error building Docker image."
    exit 1
fi
