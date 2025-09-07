#!/bin/bash

# Quick fix for Termux binary compatibility issue
# This script provides immediate solutions for the "cannot execute binary file" error

set -e

echo "🚀 Quick Fix for Termux Binary Issue"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

# Check current architecture
ARCH=$(uname -m)
print_status "Current architecture: $ARCH"

# Check if binaries exist
if [ ! -f "slipstream-client" ] || [ ! -f "slipstream-server" ]; then
    print_error "Binary files not found!"
    exit 1
fi

# Check binary architecture
print_status "Checking binary architecture..."
file slipstream-client
file slipstream-server

echo ""
print_warning "The error 'cannot execute binary file: Exec format error' means:"
echo "  - The binaries are built for x86_64 (Intel/AMD)"
echo "  - Termux runs on ARM64 (aarch64)"
echo "  - They are incompatible!"

echo ""
print_status "🔧 SOLUTIONS:"

echo ""
echo "1️⃣  BUILD FROM SOURCE (Recommended):"
echo "   chmod +x build-termux.sh"
echo "   ./build-termux.sh"

echo ""
echo "2️⃣  USE PRE-BUILT ARM64 BINARIES:"
echo "   chmod +x fix-termux-binaries.sh"
echo "   ./fix-termux-binaries.sh"

echo ""
echo "3️⃣  MANUAL BUILD:"
echo "   pkg update && pkg upgrade -y"
echo "   pkg install -y build-essential cmake ninja-build pkg-config openssl-tool git"
echo "   mkdir build && cd build"
echo "   cmake .. -DCMAKE_BUILD_TYPE=Release"
echo "   make -j4"
echo "   cp slipstream-* .."
echo "   chmod +x slipstream-*"

echo ""
echo "4️⃣  USE QEMU EMULATION (Not recommended for performance):"
echo "   pkg install -y qemu-user-x86_64"
echo "   qemu-x86_64 ./slipstream-client --help"

echo ""
print_status "Which solution would you like to try?"

# Interactive menu
echo ""
echo "Select an option:"
echo "1) Build from source (Recommended)"
echo "2) Download ARM64 binaries"
echo "3) Manual build instructions"
echo "4) Use QEMU emulation"
echo "5) Exit"

read -p "Enter your choice (1-5): " choice

case $choice in
    1)
        print_status "Building from source..."
        chmod +x build-termux.sh
        ./build-termux.sh
        ;;
    2)
        print_status "Downloading ARM64 binaries..."
        chmod +x fix-termux-binaries.sh
        ./fix-termux-binaries.sh
        ;;
    3)
        print_status "Manual build instructions:"
        echo ""
        echo "Run these commands:"
        echo "pkg update && pkg upgrade -y"
        echo "pkg install -y build-essential cmake ninja-build pkg-config openssl-tool git"
        echo "mkdir build && cd build"
        echo "cmake .. -DCMAKE_BUILD_TYPE=Release"
        echo "make -j4"
        echo "cp slipstream-* .."
        echo "chmod +x slipstream-*"
        ;;
    4)
        print_status "Installing QEMU emulation..."
        pkg install -y qemu-user-x86_64
        print_success "QEMU installed. You can now run:"
        echo "qemu-x86_64 ./slipstream-client --help"
        ;;
    5)
        print_status "Exiting..."
        exit 0
        ;;
    *)
        print_error "Invalid choice!"
        exit 1
        ;;
esac

echo ""
print_success "✅ Fix completed! Try running your command again."
