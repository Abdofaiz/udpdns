#!/bin/bash

# Build Slipstream for Termux (ARM64)
# This script builds the project from source for Termux

set -e

echo "🔨 Building Slipstream for Termux..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Update packages
print_status "Updating Termux packages..."
pkg update -y

# Install build dependencies
print_status "Installing build dependencies..."
pkg install -y build-essential cmake ninja-build pkg-config openssl-tool git wget

# Check if we have the source code
if [ ! -f "CMakeLists.txt" ]; then
    print_error "CMakeLists.txt not found! Make sure you're in the project directory."
    exit 1
fi

# Initialize submodules if needed
if [ -d ".git" ] && [ -f ".gitmodules" ]; then
    print_status "Initializing git submodules..."
    git submodule update --init --recursive
fi

# Clean previous build
print_status "Cleaning previous build..."
rm -rf build
mkdir -p build

# Configure build
print_status "Configuring build..."
cd build

# Use Termux-specific CMake configuration
cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_SYSTEM_NAME=Linux \
    -DCMAKE_SYSTEM_PROCESSOR=aarch64 \
    -DCMAKE_C_COMPILER=gcc \
    -DCMAKE_CXX_COMPILER=g++ \
    -DCMAKE_C_FLAGS="-O3 -DNDEBUG" \
    -DCMAKE_CXX_FLAGS="-O3 -DNDEBUG"

# Build
print_status "Building project..."
make -j$(nproc)

# Check if build was successful
if [ -f "slipstream-client" ] && [ -f "slipstream-server" ]; then
    print_success "Build completed successfully!"
    
    # Copy binaries to parent directory
    cp slipstream-client ../
    cp slipstream-server ../
    
    # Make them executable
    chmod +x ../slipstream-client
    chmod +x ../slipstream-server
    
    cd ..
    
    # Verify binaries
    print_status "Verifying binaries..."
    
    if file slipstream-client | grep -q "ARM\|aarch64\|armv7"; then
        print_success "slipstream-client is ARM compatible"
    else
        print_warning "slipstream-client architecture:"
        file slipstream-client
    fi
    
    if file slipstream-server | grep -q "ARM\|aarch64\|armv7"; then
        print_success "slipstream-server is ARM compatible"
    else
        print_warning "slipstream-server architecture:"
        file slipstream-server
    fi
    
    # Test execution
    print_status "Testing binary execution..."
    
    if ./slipstream-client --help >/dev/null 2>&1; then
        print_success "slipstream-client can execute successfully"
    else
        print_warning "slipstream-client execution test failed"
    fi
    
    if ./slipstream-server --help >/dev/null 2>&1; then
        print_success "slipstream-server can execute successfully"
    else
        print_warning "slipstream-server execution test failed"
    fi
    
    print_success "🎉 Build completed! You can now use:"
    echo "  ./slipstream-client --help"
    echo "  ./slipstream-server --help"
    
else
    print_error "Build failed! Check the output above for errors."
    cd ..
    exit 1
fi

# Show final status
print_status "Final directory contents:"
ls -la slipstream-*

echo ""
print_success "✅ Termux build completed successfully!"
