#!/bin/bash

# Enhanced Slipstream Client for Termux
# With congestion control improvements and backpressure management

echo "🚀 Enhanced Slipstream Client for Termux"

# Configuration
DOMAIN="dns.fastvpn.uk"
SERVER_IP="YOUR_SERVER_IP"  # Replace with your server IP
DNS_PORT="5301"
TCP_PORT="7000"
KEEP_ALIVE="1000"
CC_ALGO="bbr"  # Options: bbr, dcubic

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}📡 Configuration:${NC}"
echo -e "   Domain: ${GREEN}$DOMAIN${NC}"
echo -e "   Server: ${GREEN}$SERVER_IP:$DNS_PORT${NC}"
echo -e "   TCP Port: ${GREEN}$TCP_PORT${NC}"
echo -e "   Congestion Control: ${GREEN}$CC_ALGO${NC}"
echo -e "   Keep Alive: ${GREEN}${KEEP_ALIVE}ms${NC}"
echo ""

# Check if client binary exists
if [ ! -f "slipstream-client" ]; then
    echo -e "${RED}❌ slipstream-client not found!${NC}"
    echo -e "${YELLOW}Please download or build the client binary first${NC}"
    echo ""
    echo "Download options:"
    echo "1. From your repository: git clone https://github.com/Abdofaiz/udpdns.git"
    echo "2. Build from source: Follow build instructions"
    exit 1
fi

# Check if server IP is set
if [ "$SERVER_IP" = "YOUR_SERVER_IP" ]; then
    echo -e "${RED}❌ Please set your server IP!${NC}"
    echo ""
    echo -e "${YELLOW}Edit this script and replace YOUR_SERVER_IP with your actual server IP${NC}"
    echo "Example: SERVER_IP=\"192.168.1.100\""
    echo ""
    echo "Or run with custom IP:"
    echo "SERVER_IP=\"YOUR_IP\" ./termux-client.sh"
    exit 1
fi

# Make client executable
chmod +x slipstream-client

# Test server connectivity
echo -e "${BLUE}🔍 Testing server connectivity...${NC}"
if ping -c 1 "$SERVER_IP" > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Server is reachable${NC}"
else
    echo -e "${YELLOW}⚠️  Server ping failed, but continuing...${NC}"
fi

# Kill existing client processes
echo -e "${BLUE}🧹 Cleaning up existing processes...${NC}"
pkill -f slipstream-client 2>/dev/null || true

# Start client with enhanced features
echo -e "${BLUE}🎯 Starting enhanced Slipstream client...${NC}"
echo -e "${GREEN}🚀 Features enabled:${NC}"
echo -e "   - ${GREEN}BBR Congestion Control${NC} (better bandwidth utilization)"
echo -e "   - ${GREEN}Backpressure Management${NC} (prevents data loss)"
echo -e "   - ${GREEN}Performance Monitoring${NC} (real-time metrics)"
echo -e "   - ${GREEN}Smart Retry Logic${NC} (automatic error recovery)"
echo ""

# Run the client
./slipstream-client \
    --congestion-control="$CC_ALGO" \
    --tcp-listen-port="$TCP_PORT" \
    --resolver="$SERVER_IP:$DNS_PORT" \
    --domain="$DOMAIN" \
    --keep-alive-interval="$KEEP_ALIVE"

# Check exit status
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Client stopped normally${NC}"
else
    echo -e "${RED}❌ Client stopped with error${NC}"
    echo -e "${YELLOW}Check the logs above for details${NC}"
fi
