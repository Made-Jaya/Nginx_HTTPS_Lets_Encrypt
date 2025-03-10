#!/bin/bash

# Check if email is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 your-email@example.com"
    exit 1
fi

email="$1"
domain="lol.maleh.my.id"
rsa_key_size=4096
data_path="./data/certbot"

# Create required directories
mkdir -p "$data_path/conf/live/$domain"
mkdir -p "$data_path/www"
mkdir -p "html"

# Stop any existing containers
docker-compose down

# Create dummy certificate
openssl req -x509 -nodes -newkey rsa:$rsa_key_size -days 1 \
    -keyout "$data_path/conf/live/$domain/privkey.pem" \
    -out "$data_path/conf/live/$domain/fullchain.pem" \
    -subj "/CN=localhost"

echo "### Starting nginx container..."
docker-compose up -d nginx

echo "### Deleting dummy certificate..."
rm -rf "$data_path/conf/live/$domain"

echo "### Requesting Let's Encrypt certificate for $domain..."

# Enable staging mode if needed
staging=""
if [ "$staging" != "0" ]; then
    staging="--staging"
fi

docker-compose run --rm --entrypoint "\
    certbot certonly --webroot -w /var/www/certbot \
    $staging \
    --email $email \
    --agree-tos \
    --no-eff-email \
    -d $domain \
    --force-renewal" certbot

echo "### Reloading nginx..."
docker-compose exec nginx nginx -s reload
