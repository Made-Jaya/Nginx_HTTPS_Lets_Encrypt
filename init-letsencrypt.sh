#!/bin/bash

domains=(lol.maleh.my.id)
email="" # Add your email address here
staging=0 # Set to 1 if you're testing your setup

# Create required directories
mkdir -p data/certbot/conf
mkdir -p data/certbot/www
mkdir -p html

# Stop any existing containers
docker-compose down

# Create dummy certificates
path="/etc/letsencrypt/live/lol.maleh.my.id"
docker-compose run --rm --entrypoint "\
  openssl req -x509 -nodes -newkey rsa:4096 -days 1\
    -keyout '$path/privkey.pem' \
    -out '$path/fullchain.pem' \
    -subj '/CN=localhost'" certbot

# Start nginx
docker-compose up --force-recreate -d nginx

# Request Let's Encrypt certificate
docker-compose run --rm --entrypoint "\
  certbot certonly --webroot -w /var/www/certbot \
    --email $email \
    --agree-tos \
    --no-eff-email \
    --force-renewal" certbot

# Reload nginx
docker-compose exec nginx nginx -s reload
