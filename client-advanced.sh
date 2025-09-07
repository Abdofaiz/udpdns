#!/bin/bash

# Advanced Slipstream Client for Termux
# Multiple configuration options and congestion control algorithms

# Default configuration
DOMAIN="dns.fastvpn.uk"
TCP_PORT="7000"
DNS_PORT="5301"
KEEP_ALIVE="1000"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🚀 Advanced Slipstream Client${NC}"
echo ""

# Get server IP
if [ -z "$1" ]; then
    echo -e "${YELLOW}Usage: $0 <SERVER_IP> [congestion_control]${NC}"
    echo ""
    echo "Examples:"
    echo "  $0 192.168.1.100 bbr"
    echo "  $0 192.168.1.100 dcubic"
    echo "  $0 your-server.com bbr"
    echo ""
    echo "Congestion Control Options:"
    echo "  bbr    - BBR (recommended for better performance)"
    echo "  dcubic - DCubic (alternative algorithm)"
    exit 1
fi

SERVER_IP="$1"
CC_ALGO="${2:-bbr}"  # Default to BBR if not specified

echo -e "${GREEN}📡 Configuration:${NC}"
echo -e "   Server IP: ${GREEN}$SERVER_IP${NC}"
echo -e "   Domain: ${GREEN}$DOMAIN${NC}"
echo -e "   TCP Port: ${GREEN}$TCP_PORT${NC}"
echo -e "   DNS Port: ${GREEN}$DNS_PORT${NC}"
echo -e "   Congestion Control: ${GREEN}$CC_ALGO${NC}"
echo -e "   Keep Alive: ${GREEN}${KEEP_ALIVE}ms${NC}"
echo ""

# Validate congestion control algorithm
if [[ "$CC_ALGO" != "bbr" && "$CC_ALGO" != "dcubic" ]]; then
    echo -e "${RED}❌ Invalid congestion control algorithm: $CC_ALGO${NC}"
    echo -e "${YELLOW}Valid options: bbr, dcubic${NC}"
    exit 1
fi

# Check if client binary exists
if [ ! -f "slipstream-client" ]; then
    echo -e "${RED}❌ slipstream-client not found!${NC}"
    echo -e "${YELLOW}Please download or build the client binary first${NC}"
    exit 1
fi

# Make client executable
chmod +x slipstream-client

# Test connectivity
echo -e "${BLUE}🔍 Testing server connectivity...${NC}"
if ping -c 1 "$SERVER_IP" > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Server is reachable${NC}"
else
    echo -e "${YELLOW}⚠️  Server ping failed, but continuing...${NC}"
fi

# Kill existing processes
pkill -f slipstream-client 2>/dev/null || true

# Show algorithm benefits
echo ""
echo -e "${GREEN}🚀 Enhanced Features:${NC}"
if [ "$CC_ALGO" = "bbr" ]; then
    echo -e "   - ${GREEN}BBR Algorithm${NC}: Better bandwidth utilization, lower latency"
    echo -e "   - ${GREEN}Smart Pacing${NC}: Optimal packet sending rate"
    echo -e "   - ${GREEN}RTT Optimization${NC}: Minimizes round-trip time"
else
    echo -e "   - ${GREEN}DCubic Algorithm${NC}: Fast recovery after packet loss"
    echo -e "   - ${GREEN}Cubic Growth${NC}: Efficient congestion window management"
    echo -e "   - ${GREEN}Loss Recovery${NC}: Quick adaptation to network conditions"
fi
echo -e "   - ${GREEN}Backpressure Management${NC}: Prevents data loss"
echo -e "   - ${GREEN}Performance Monitoring${NC}: Real-time metrics"
echo ""

# Start the client
echo -e "${BLUE}🎯 Starting client...${NC}"
./slipstream-client \
    --congestion-control="$CC_ALGO" \
    --tcp-listen-port="$TCP_PORT" \
    --resolver="$SERVER_IP:$DNS_PORT" \
    --domain="$DOMAIN" \
    --keep-alive-interval="$KEEP_ALIVE"

# Handle exit
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Client stopped normally${NC}"
else
    echo -e "${RED}❌ Client stopped with error${NC}"
    echo -e "${YELLOW}Check the configuration and server status${NC}"
fi
