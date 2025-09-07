#!/bin/bash

# Quick Slipstream Client for Termux
# Simple and fast client setup

# Configuration - EDIT THESE VALUES
SERVER_IP="YOUR_SERVER_IP"  # Change this to your server IP
DOMAIN="dns.fastvpn.uk"
TCP_PORT="7000"
DNS_PORT="5301"

echo "🚀 Quick Slipstream Client Setup"

# Check if server IP is set
if [ "$SERVER_IP" = "YOUR_SERVER_IP" ]; then
    echo "❌ Please edit this script and set your server IP!"
    echo "Change SERVER_IP=\"YOUR_SERVER_IP\" to your actual server IP"
    exit 1
fi

# Make client executable
chmod +x slipstream-client

# Start client with BBR (best performance)
echo "🎯 Starting client with BBR congestion control..."
./slipstream-client \
    --congestion-control=bbr \
    --tcp-listen-port="$TCP_PORT" \
    --resolver="$SERVER_IP:$DNS_PORT" \
    --domain="$DOMAIN" \
    --keep-alive-interval=1000
