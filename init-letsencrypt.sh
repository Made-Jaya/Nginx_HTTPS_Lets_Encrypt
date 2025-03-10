#!/bin/bash

# Check if email is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 your-email@example.com"
    exit 1
fi

email="$1"
domain="lol.maleh.my.id"

echo "### Installing Certbot..."
sudo apt update
sudo apt install -y certbot

echo "### Stopping any existing web servers..."
sudo systemctl stop nginx apache2 2>/dev/null || true

echo "### Obtaining certificate using standalone mode..."
sudo certbot certonly --standalone \
    --email "$email" \
    --agree-tos \
    --no-eff-email \
    -d "$domain"

if [ ! -d "/etc/letsencrypt/live/$domain" ]; then
    echo "Failed to obtain certificate!"
    exit 1
fi

echo "### Setting up Docker environment..."

# Create required directories and copy certificates
mkdir -p ./data/certbot/conf
mkdir -p ./data/certbot/www
mkdir -p ./html
mkdir -p ./log/nginx

# Copy certificates from Let's Encrypt to our project directory
sudo cp -rL /etc/letsencrypt/live/$domain/* ./data/certbot/conf/
sudo cp -r /etc/letsencrypt/archive/$domain ./data/certbot/conf/
sudo chown -R $USER:$USER ./data/certbot/conf/

echo "### Starting Docker containers..."
docker-compose down
docker-compose up -d

echo "### Setup completed!"
echo "Visit https://$domain to verify the installation"
