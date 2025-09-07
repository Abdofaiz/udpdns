#!/bin/bash

# Immediate fix for Termux binary issue
# Run this script to fix the "cannot execute binary file" error

echo "🔧 Fixing Termux binary compatibility issue..."

# Check if we're in Termux
if [ ! -d "/data/data/com.termux" ]; then
    echo "❌ This script is for Termux only!"
    exit 1
fi

# Check architecture
ARCH=$(uname -m)
echo "📱 Architecture: $ARCH"

# Install build tools
echo "📦 Installing build tools..."
pkg update -y
pkg install -y build-essential cmake ninja-build pkg-config openssl-tool git

# Clean and build
echo "🔨 Building from source..."
rm -rf build
mkdir build
cd build

# Configure
cmake .. -DCMAKE_BUILD_TYPE=Release

# Build
make -j4

# Copy binaries
echo "📋 Copying binaries..."
cp slipstream-client ../
cp slipstream-server ../
cd ..

# Make executable
chmod +x slipstream-client slipstream-server

# Verify
echo "✅ Verifying build..."
file slipstream-client
file slipstream-server

echo ""
echo "🎉 Fix completed! You can now run:"
echo "   ./slipstream-client --help"
echo "   ./slipstream-server --help"
echo ""
echo "🚀 Try your original command again:"
echo "   ./slipstream-client --congestion-control=bbr --tcp-listen-port=7000 --resolver=1.1.1.1:53 --domain=dns.fastvpn.uk --keep-alive-interval=1000"
