# First, check current status
sudo ufw status verbose
# Allow all ports with sudo
sudo ufw allow 80
sudo ufw allow 8080
sudo ufw allow 8089
sudo ufw allow 89
sudo ufw allow 88
sudo ufw allow 21
sudo ufw allow 22
sudo ufw allow 23
sudo ufw allow 443
sudo ufw allow 445
sudo ufw allow 5050
sudo ufw allow 5000
sudo ufw allow 5432
sudo ufw allow 5433
sudo ufw allow 5434
sudo ufw allow 5435
sudo ufw allow 50000
sudo ufw allow 3000
sudo ufw allow 3001
sudo ufw allow 3002
sudo ufw allow 3003
sudo ufw allow 3004
sudo ufw allow 1880
sudo ufw allow 1881
sudo ufw allow 1883
sudo ufw allow 1884
# Check the rules
sudo ufw status verbose
# Set defaults (be careful - this will block all other incoming traffic)
sudo ufw default deny incoming
sudo ufw default allow outgoing