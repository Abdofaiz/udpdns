# Slipstream Client for Termux - Enhanced Version

## 🚀 Quick Start

### Method 1: Quick Setup
```bash
# Edit the script and set your server IP
nano client-quick.sh
# Change SERVER_IP="YOUR_SERVER_IP" to your actual server IP

# Run the client
chmod +x client-quick.sh
./client-quick.sh
```

### Method 2: Advanced Setup
```bash
# Run with server IP and congestion control
chmod +x client-advanced.sh
./client-advanced.sh YOUR_SERVER_IP bbr
```

### Method 3: Manual Command
```bash
# Make client executable
chmod +x slipstream-client

# Run with BBR (recommended)
./slipstream-client \
    --congestion-control=bbr \
    --tcp-listen-port=7000 \
    --resolver=YOUR_SERVER_IP:5301 \
    --domain=dns.fastvpn.uk \
    --keep-alive-interval=1000
```

## 🎯 Congestion Control Options

### BBR (Recommended)
```bash
./client-advanced.sh YOUR_SERVER_IP bbr
```
**Benefits:**
- Better bandwidth utilization
- Lower latency
- Smart pacing
- RTT optimization

### DCubic (Alternative)
```bash
./client-advanced.sh YOUR_SERVER_IP dcubic
```
**Benefits:**
- Fast recovery after packet loss
- Efficient congestion window management
- Quick adaptation to network conditions

## 📊 Enhanced Features

### Backpressure Management
- Automatic handling of EAGAIN conditions
- Smart retry mechanism with configurable delays
- Buffer monitoring and management
- Prevents data loss during high load

### Performance Monitoring
- Real-time congestion control metrics
- Bandwidth utilization tracking
- RTT measurement and optimization
- Packet loss detection and recovery

### Error Handling
- Automatic reconnection on connection loss
- Graceful handling of network interruptions
- Smart retry logic with exponential backoff
- Detailed error logging

## 🔧 Configuration Options

### Basic Parameters
- `--congestion-control`: Algorithm (bbr/dcubic)
- `--tcp-listen-port`: Local TCP port (default: 7000)
- `--resolver`: Server IP and DNS port
- `--domain`: Domain name for DNS tunneling
- `--keep-alive-interval`: Keep-alive ping interval (ms)

### Advanced Parameters
- `--gso`: Generic Segmentation Offload
- `--help`: Show all available options

## 📱 Termux Specific Tips

### Performance Optimization
```bash
# Prevent device sleep during transfers
termux-wake-lock

# Monitor network usage
termux-notification -t "Slipstream Active" -c "Data transfer in progress"
```

### Troubleshooting
```bash
# Check if client is running
ps aux | grep slipstream-client

# Kill existing client processes
pkill -f slipstream-client

# Check network connectivity
ping YOUR_SERVER_IP

# Test DNS resolution
nslookup dns.fastvpn.uk
```

## 🔍 Common Issues

### Connection Failed
1. Check server IP and port
2. Verify server is running
3. Check firewall settings
4. Test basic connectivity

### Poor Performance
1. Try different congestion control algorithm
2. Adjust keep-alive interval
3. Check network conditions
4. Monitor server resources

### Client Crashes
1. Check client binary permissions
2. Verify all dependencies are installed
3. Check system resources
4. Review error logs

## 📋 Example Configurations

### High Performance Setup
```bash
./slipstream-client \
    --congestion-control=bbr \
    --tcp-listen-port=7000 \
    --resolver=YOUR_SERVER_IP:5301 \
    --domain=dns.fastvpn.uk \
    --keep-alive-interval=500 \
    --gso=true
```

### Stable Connection Setup
```bash
./slipstream-client \
    --congestion-control=dcubic \
    --tcp-listen-port=7000 \
    --resolver=YOUR_SERVER_IP:5301 \
    --domain=dns.fastvpn.uk \
    --keep-alive-interval=2000
```

### Low Latency Setup
```bash
./slipstream-client \
    --congestion-control=bbr \
    --tcp-listen-port=7000 \
    --resolver=YOUR_SERVER_IP:5301 \
    --domain=dns.fastvpn.uk \
    --keep-alive-interval=100
```

## 🆕 What's New

- Enhanced BBR congestion control algorithm
- Improved DCubic implementation
- Smart backpressure management
- Performance monitoring and logging
- Better error handling and recovery
- Termux-optimized scripts
- Multiple configuration options
