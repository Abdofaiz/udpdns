#!/bin/bash

# Termux Slipstream Setup Script
# Enhanced version with congestion control improvements
# Based on: https://github.com/Abdofaiz/udpdns

echo "🚀 Setting up Slipstream on Termux with enhanced features..."

# Update system packages
echo "📦 Updating system packages..."
pkg update && pkg upgrade -y

# Install required packages
echo "🔧 Installing dependencies..."
pkg install -y build-essential cmake ninja-build pkg-config openssl-tool git wget curl

# Create slipstream directory
echo "📁 Creating slipstream directory..."
mkdir -p ~/slipstream
cd ~/slipstream

# Download slipstream binaries (if available)
echo "⬇️ Downloading slipstream binaries..."
if [ ! -f "slipstream-server" ]; then
    echo "⚠️ slipstream-server not found, you may need to build it manually"
fi

if [ ! -f "slipstream-client" ]; then
    echo "⚠️ slipstream-client not found, you may need to build it manually"
fi

# Create certificates directory
echo "🔒 Setting up SSL certificates..."
mkdir -p certs

# Generate SSL certificate
echo "📜 Generating SSL certificate..."
openssl req -x509 -newkey rsa:4096 \
    -keyout certs/key.pem \
    -out certs/cert.pem \
    -days 365 \
    -nodes \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=dns.fastvpn.uk"

# Make binaries executable
echo "🔧 Setting permissions..."
chmod +x slipstream-server slipstream-client 2>/dev/null || echo "⚠️ Binaries not found, skipping chmod"

# Create enhanced run script
echo "📝 Creating enhanced run script..."
cat > run-server-enhanced.sh << 'EOF'
#!/bin/bash

# Enhanced Slipstream Server for Termux
# With congestion control improvements

DOMAIN="dns.fastvpn.uk"
CERT_PATH="certs/cert.pem"
KEY_PATH="certs/key.pem"
DNS_PORT="5301"
TARGET_ADDRESS="0.0.0.0:22"

echo "🚀 Starting enhanced Slipstream server on Termux..."
echo "📡 Domain: $DOMAIN"
echo "🔒 Cert: $CERT_PATH"
echo "🔑 Key: $KEY_PATH"
echo "🌐 DNS Port: $DNS_PORT"
echo "🎯 Target: $TARGET_ADDRESS"

# Check if server binary exists
if [ ! -f "slipstream-server" ]; then
    echo "❌ slipstream-server not found!"
    echo "Please download or build the server binary first"
    exit 1
fi

# Check if certificates exist
if [ ! -f "$CERT_PATH" ] || [ ! -f "$KEY_PATH" ]; then
    echo "❌ SSL certificates not found!"
    echo "Please run the setup script first"
    exit 1
fi

# Kill existing screen session
screen -S slip -X quit 2>/dev/null

# Start server in screen session
echo "🎯 Starting server with enhanced congestion control..."
screen -dmS slip ./slipstream-server \
    --target-address="$TARGET_ADDRESS" \
    --domain="$DOMAIN" \
    --cert="$CERT_PATH" \
    --key="$KEY_PATH" \
    --dns-listen-port="$DNS_PORT"

echo "✅ Server started in screen session 'slip'"
echo "📊 To view server logs: screen -r slip"
echo "🛑 To stop server: screen -S slip -X quit"
EOF

# Create client script
echo "📝 Creating client script..."
cat > run-client-enhanced.sh << 'EOF'
#!/bin/bash

# Enhanced Slipstream Client for Termux
# With congestion control improvements

DOMAIN="dns.fastvpn.uk"
SERVER_IP="YOUR_SERVER_IP"  # Replace with your server IP
DNS_PORT="5301"
TCP_PORT="7000"
KEEP_ALIVE="1000"
CC_ALGO="bbr"  # Options: bbr, dcubic

echo "🚀 Starting enhanced Slipstream client on Termux..."
echo "📡 Domain: $DOMAIN"
echo "🌐 Server: $SERVER_IP:$DNS_PORT"
echo "🔌 TCP Port: $TCP_PORT"
echo "⚡ Congestion Control: $CC_ALGO"
echo "💓 Keep Alive: ${KEEP_ALIVE}ms"

# Check if client binary exists
if [ ! -f "slipstream-client" ]; then
    echo "❌ slipstream-client not found!"
    echo "Please download or build the client binary first"
    exit 1
fi

# Check if server IP is set
if [ "$SERVER_IP" = "YOUR_SERVER_IP" ]; then
    echo "❌ Please set your server IP in this script!"
    echo "Edit run-client-enhanced.sh and replace YOUR_SERVER_IP with your actual server IP"
    exit 1
fi

# Start client
echo "🎯 Starting client with enhanced congestion control..."
./slipstream-client \
    --congestion-control="$CC_ALGO" \
    --tcp-listen-port="$TCP_PORT" \
    --resolver="$SERVER_IP:$DNS_PORT" \
    --domain="$DOMAIN" \
    --keep-alive-interval="$KEEP_ALIVE"
EOF

# Make scripts executable
chmod +x run-server-enhanced.sh run-client-enhanced.sh

echo ""
echo "✅ Termux setup completed!"
echo ""
echo "📋 Next steps:"
echo "1. Download slipstream binaries to ~/slipstream/"
echo "2. Edit run-client-enhanced.sh and set your server IP"
echo "3. Run server: ./run-server-enhanced.sh"
echo "4. Run client: ./run-client-enhanced.sh"
echo ""
echo "🔧 Enhanced features available:"
echo "   - BBR congestion control (--congestion-control=bbr)"
echo "   - DCubic congestion control (--congestion-control=dcubic)"
echo "   - Backpressure management"
echo "   - Performance monitoring"
echo ""
echo "📊 Screen session management:"
echo "   - View server: screen -r slip"
echo "   - Detach: Ctrl+A, D"
echo "   - Stop server: screen -S slip -X quit"
