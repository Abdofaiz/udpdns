apt-get update && apt-get upgrade && apt-get install iptables -y && apt-get install screen -y


chmod +x slipstream-server


screen -dmS slip ~/slipstream-server \
  --target-address=0.0.0.0:22 \
  --domain=dns.fastvpn.uk \
  --cert=/root/slipstream/certs/cert.pem \
  --key=/root/slipstream/certs/key.pem \
  --dns-listen-port=5301

