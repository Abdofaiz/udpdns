# Slipstream for Termux - Enhanced Version

## 🚀 Quick Setup

### Prerequisites
```bash
# Update packages
pkg update && pkg upgrade -y

# Install dependencies
pkg install -y build-essential cmake ninja-build pkg-config openssl-tool git screen
```

### Server Setup
```bash
# Clone repository
git clone https://github.com/Abdofaiz/udpdns.git
cd udpdns

# Make server executable
chmod +x slipstream-server

# Create certificates
mkdir -p certs
openssl req -x509 -newkey rsa:4096 \
    -keyout certs/key.pem \
    -out certs/cert.pem \
    -days 365 \
    -nodes \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=dns.fastvpn.uk"

# Start server
screen -dmS slip ./slipstream-server \
    --target-address=0.0.0.0:22 \
    --domain=dns.fastvpn.uk \
    --cert=certs/cert.pem \
    --key=certs/key.pem \
    --dns-listen-port=5301
```

### Client Setup
```bash
# Make client executable
chmod +x slipstream-client

# Start client with enhanced features
./slipstream-client \
    --congestion-control=bbr \
    --tcp-listen-port=7000 \
    --resolver=YOUR_SERVER_IP:5301 \
    --domain=dns.fastvpn.uk \
    --keep-alive-interval=1000
```

## 🎯 Enhanced Features

### Congestion Control
- **BBR**: Better bandwidth utilization, lower latency
- **DCubic**: Fast recovery after packet loss

### Backpressure Management
- Smart handling of EAGAIN conditions
- Automatic retry with configurable delays
- Buffer monitoring and management

### Performance Monitoring
- Real-time congestion control metrics
- Bandwidth utilization tracking
- RTT measurement and optimization

## 📊 Screen Management

```bash
# View server logs
screen -r slip

# Detach from screen
Ctrl+A, D

# Stop server
screen -S slip -X quit

# List screen sessions
screen -ls
```

## 🔧 Troubleshooting

### Common Issues
1. **Binary not found**: Make sure to download the correct binaries for your architecture
2. **Permission denied**: Run `chmod +x slipstream-*`
3. **Port in use**: Check with `netstat -tulpn | grep :5301`
4. **Certificate errors**: Regenerate certificates with the correct domain

### Performance Tips
- Use BBR for better performance
- Adjust keep-alive interval based on network conditions
- Monitor server resources during high load
- Use screen sessions for background operation

## 📱 Termux Specific

- Grant storage permissions if needed: `termux-setup-storage`
- Prevent sleep during transfers: `termux-wake-lock`
- Monitor network usage with notifications
- Use `termux-notification` for status updates

## 🔗 Links

- [Repository](https://github.com/Abdofaiz/udpdns)
- [Original Slipstream](https://github.com/EndPositive/slipstream)
- [Termux Documentation](https://termux.com/)
