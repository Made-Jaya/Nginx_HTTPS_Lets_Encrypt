# Nginx HTTPS Setup with Let's Encrypt

This repository contains configuration for setting up Nginx with HTTPS using Let's Encrypt SSL certificates for lol.maleh.my.id.

## Prerequisites

- Docker installed on your system
- Docker Compose installed on your system
- A domain name (lol.maleh.my.id) with DNS A record pointing to your server's IP address
- Port 80 and 443 available on your server

## Directory Structure

```
.
├── docker-compose.yml          # Docker compose configuration
├── nginx.conf                  # Nginx server configuration
├── init-letsencrypt.sh        # Initial SSL certificate setup script
├── html/                      # Website files
├── data/                      # Created automatically
│   └── certbot/              # Let's Encrypt certificates
├── log/                      # Created automatically
│   └── nginx/               # Nginx log files
```

## Setup Instructions

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd Nginx_HTTPS_Lets_Encrypt
   ```

2. **Configure Domain**
   - Make sure your DNS A record is set up:
     - lol.maleh.my.id → [Your Server IP]

3. **Edit init-letsencrypt.sh**
   ```bash
   # Open init-letsencrypt.sh and update the email variable
   email="your-email@example.com"  # Replace with your actual email
   ```

4. **Make the Script Executable**
   ```bash
   chmod +x init-letsencrypt.sh
   ```

5. **Run the Setup**
   ```bash
   ./init-letsencrypt.sh
   ```
   This will:
   - Create required directories
   - Generate temporary SSL certificates
   - Start Nginx
   - Obtain real Let's Encrypt certificates

6. **Start the Services**
   ```bash
   docker-compose up -d
   ```

## Verification

1. Check if the containers are running:
   ```bash
   docker-compose ps
   ```

2. Visit your website:
   ```
   https://lol.maleh.my.id
   ```

3. Check SSL certificate:
   ```bash
   curl -vI https://lol.maleh.my.id
   ```

## Maintenance

- Certificates will auto-renew every 12 hours if needed
- Nginx will automatically reload when certificates are renewed
- Check logs:
  ```bash
  # Nginx logs
  docker-compose logs nginx
  
  # Certbot logs
  docker-compose logs certbot
  ```

## Troubleshooting

1. **Certificate Issues**
   - Check certbot logs:
     ```bash
     docker-compose logs certbot
     ```
   - Verify domain DNS settings:
     ```bash
     dig lol.maleh.my.id
     ```

2. **Nginx Issues**
   - Check nginx logs:
     ```bash
     docker-compose logs nginx
     ```
   - Test nginx configuration:
     ```bash
     docker-compose exec nginx nginx -t
     ```

3. **Port Conflicts**
   - Check if ports 80/443 are in use:
     ```bash
     sudo lsof -i :80
     sudo lsof -i :443
     ```

## Security Notes

- The setup includes:
  - HTTP/2 support
  - Modern SSL configuration
  - Security headers
  - Automatic redirects from HTTP to HTTPS
  - Regular certificate renewal

## License

This project is licensed under the MIT License - see the LICENSE file for details.
