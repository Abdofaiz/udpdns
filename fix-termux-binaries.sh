#!/bin/bash

# Fix Termux binaries - Download correct ARM64 binaries
# This script downloads the correct binaries for Termux (ARM64)

set -e

echo "🔧 Fixing Termux binaries..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in Termux
if [ ! -d "/data/data/com.termux" ]; then
    print_error "This script is designed for Termux only!"
    exit 1
fi

# Check architecture
ARCH=$(uname -m)
print_status "Detected architecture: $ARCH"

if [ "$ARCH" != "aarch64" ] && [ "$ARCH" != "armv7l" ]; then
    print_warning "Unsupported architecture: $ARCH"
    print_status "Trying to continue anyway..."
fi

# Create backup of existing binaries
print_status "Creating backup of existing binaries..."
mkdir -p backup
if [ -f "slipstream-client" ]; then
    mv slipstream-client backup/slipstream-client.x86_64
    print_status "Backed up slipstream-client"
fi
if [ -f "slipstream-server" ]; then
    mv slipstream-server backup/slipstream-server.x86_64
    print_status "Backed up slipstream-server"
fi

# Download correct binaries for ARM64
print_status "Downloading ARM64 binaries..."

# GitHub releases URL (you may need to update this with actual release)
RELEASE_URL="https://github.com/EndPositive/slipstream/releases/latest"

# Try to get the latest release
LATEST_RELEASE=$(curl -s https://api.github.com/repos/EndPositive/slipstream/releases/latest | grep "tag_name" | cut -d '"' -f 4)

if [ -z "$LATEST_RELEASE" ]; then
    print_warning "Could not fetch latest release, using fallback method"
    # Fallback: try to build from source
    print_status "Building from source..."
    
    # Install build dependencies
    print_status "Installing build dependencies..."
    pkg update -y
    pkg install -y build-essential cmake ninja-build pkg-config openssl-tool git
    
    # Build the project
    print_status "Building project..."
    if [ -f "build-on-server.sh" ]; then
        chmod +x build-on-server.sh
        ./build-on-server.sh
    else
        # Manual build
        mkdir -p build
        cd build
        cmake .. -DCMAKE_BUILD_TYPE=Release
        make -j$(nproc)
        cd ..
        
        # Copy binaries
        if [ -f "build/slipstream-client" ]; then
            cp build/slipstream-client .
            chmod +x slipstream-client
        fi
        if [ -f "build/slipstream-server" ]; then
            cp build/slipstream-server .
            chmod +x slipstream-server
        fi
    fi
else
    print_status "Latest release: $LATEST_RELEASE"
    
    # Download ARM64 binaries
    CLIENT_URL="https://github.com/EndPositive/slipstream/releases/download/${LATEST_RELEASE}/slipstream-client-linux-arm64"
    SERVER_URL="https://github.com/EndPositive/slipstream/releases/download/${LATEST_RELEASE}/slipstream-server-linux-arm64"
    
    print_status "Downloading client binary..."
    if wget -O slipstream-client "$CLIENT_URL" 2>/dev/null; then
        chmod +x slipstream-client
        print_success "Downloaded slipstream-client"
    else
        print_warning "Failed to download client binary, will build from source"
        # Build from source as fallback
        pkg update -y
        pkg install -y build-essential cmake ninja-build pkg-config openssl-tool git
        mkdir -p build
        cd build
        cmake .. -DCMAKE_BUILD_TYPE=Release
        make -j$(nproc)
        cd ..
        if [ -f "build/slipstream-client" ]; then
            cp build/slipstream-client .
            chmod +x slipstream-client
        fi
    fi
    
    print_status "Downloading server binary..."
    if wget -O slipstream-server "$SERVER_URL" 2>/dev/null; then
        chmod +x slipstream-server
        print_success "Downloaded slipstream-server"
    else
        print_warning "Failed to download server binary, will build from source"
        if [ -f "build/slipstream-server" ]; then
            cp build/slipstream-server .
            chmod +x slipstream-server
        fi
    fi
fi

# Verify binaries
print_status "Verifying binaries..."

if [ -f "slipstream-client" ]; then
    if file slipstream-client | grep -q "ARM\|aarch64\|armv7"; then
        print_success "slipstream-client is ARM compatible"
    else
        print_warning "slipstream-client may not be ARM compatible"
        file slipstream-client
    fi
else
    print_error "slipstream-client not found!"
fi

if [ -f "slipstream-server" ]; then
    if file slipstream-server | grep -q "ARM\|aarch64\|armv7"; then
        print_success "slipstream-server is ARM compatible"
    else
        print_warning "slipstream-server may not be ARM compatible"
        file slipstream-server
    fi
else
    print_error "slipstream-server not found!"
fi

# Test if binaries can execute
print_status "Testing binary execution..."

if [ -f "slipstream-client" ]; then
    if ./slipstream-client --help >/dev/null 2>&1; then
        print_success "slipstream-client can execute successfully"
    else
        print_warning "slipstream-client execution test failed, but binary exists"
    fi
fi

if [ -f "slipstream-server" ]; then
    if ./slipstream-server --help >/dev/null 2>&1; then
        print_success "slipstream-server can execute successfully"
    else
        print_warning "slipstream-server execution test failed, but binary exists"
    fi
fi

print_success "Binary fix completed!"
print_status "You can now try running:"
echo "  ./slipstream-client --help"
echo "  ./slipstream-server --help"

# Show current directory contents
print_status "Current directory contents:"
ls -la slipstream-*

echo ""
print_success "🎉 Termux binaries fixed! You can now use the enhanced slipstream client and server."
