#!/bin/bash
# sudo ./setnetwork.sh
# setnetwork.sh - Configure static IP and firewall on Ubuntu

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Network configuration
IP_ADDRESS="172.25.99.10"
NETMASK="255.255.255.0"
GATEWAY="172.25.99.1"
DNS_SERVERS="8.8.8.8 8.8.4.4"  # Google DNS as example
INTERFACE=$(ip route | grep default | awk '{print $5}' | head -n1)

# Function to print status messages
print_status() {
    echo -e "${GREEN}[+]${NC} $1"
}

print_error() {
    echo -e "${RED}[!]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[*]${NC} $1"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    print_error "Please run as root (use sudo)"
    exit 1
fi

print_status "Starting network configuration..."

# Backup current netplan configuration
print_status "Backing up current netplan configuration..."
if [ -d /etc/netplan/ ]; then
    cp /etc/netplan/*.yaml /etc/netplan/*.yaml.backup 2>/dev/null
fi

# For Ubuntu 18.04+ with netplan
print_status "Configuring static IP address..."

# Create netplan configuration
cat > /etc/netplan/01-network-config.yaml << EOF
network:
  version: 2
  ethernets:
    $INTERFACE:
      addresses:
        - $IP_ADDRESS/24
      routes:
        - to: default
          via: $GATEWAY
      nameservers:
        addresses: [$DNS_SERVERS]
EOF

# Apply netplan configuration
print_status "Applying network configuration..."
netplan apply

# Wait for network to settle
sleep 3

# Verify IP configuration
print_status "Verifying network configuration..."
ip addr show $INTERFACE | grep "inet "

# Test connectivity
print_status "Testing connectivity..."
ping -c 3 $GATEWAY > /dev/null 2>&1
if [ $? -eq 0 ]; then
    print_status "Gateway is reachable"
else
    print_warning "Gateway is not reachable, please check configuration"
fi

# Configure firewall (UFW)
print_status "Configuring firewall (UFW)..."

# Enable UFW if not enabled
if ! ufw status | grep -q "Status: active"; then
    print_status "Enabling UFW..."
    ufw --force enable
fi

# Reset UFW to default deny
print_status "Setting default UFW policies..."
ufw default deny incoming
ufw default allow outgoing

# Allow SSH (adjust port if needed)
print_status "Configuring firewall rules..."
ufw allow 22/tcp comment 'SSH'

# Allow common services (customize as needed)
ufw allow 80/tcp comment 'HTTP'
ufw allow 443/tcp comment 'HTTPS'
ufw allow 53 comment 'DNS'

# Allow ICMP (ping)
ufw allow proto icmp

# Allow traffic within local network
ufw allow from 172.25.99.0/24

# Enable logging
ufw logging on

# Show configured rules
print_status "Firewall rules configured:"
ufw status numbered

# Alternative: If using iptables directly (uncomment if needed)
# print_status "Configuring iptables..."
# iptables -F
# iptables -P INPUT DROP
# iptables -P FORWARD DROP
# iptables -P OUTPUT ACCEPT
# iptables -A INPUT -i lo -j ACCEPT
# iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
# iptables -A INPUT -p tcp --dport 22 -j ACCEPT
# iptables -A INPUT -s 172.25.99.0/24 -j ACCEPT
# iptables -A INPUT -p icmp -j ACCEPT

# Save iptables rules (if using iptables)
# iptables-save > /etc/iptables/rules.v4

# Configure DNS resolution
print_status "Configuring DNS..."
cat > /etc/resolv.conf << EOF
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF

# Make resolv.conf immutable to prevent overwrite
chattr +i /etc/resolv.conf 2>/dev/null || true

# Test DNS resolution
print_status "Testing DNS resolution..."
nslookup google.com > /dev/null 2>&1
if [ $? -eq 0 ]; then
    print_status "DNS resolution working"
else
    print_warning "DNS resolution test failed"
fi

# Display final configuration
print_status "Network configuration complete!"
echo ""
print_status "Summary:"
echo "  IP Address:  $IP_ADDRESS"
echo "  Netmask:     $NETMASK"
echo "  Gateway:     $GATEWAY"
echo "  Interface:   $INTERFACE"
echo "  DNS Servers: $DNS_SERVERS"
echo ""
print_status "Firewall is active with the following rules:"
ufw status
echo ""
print_warning "Note: SSH access is allowed. Adjust firewall rules as needed."
print_warning "Network configuration saved to /etc/netplan/01-network-config.yaml"