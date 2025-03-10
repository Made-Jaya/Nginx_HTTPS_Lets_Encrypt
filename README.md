# Nginx HTTPS Setup with Let's Encrypt

This repository contains configuration for setting up Nginx with HTTPS using Let's Encrypt SSL certificates for lol.maleh.my.id.

## Prerequisites

- Docker installed on your system
- Docker Compose installed on your system
- A domain name (lol.maleh.my.id) with DNS A record pointing to your server's IP address

## Required Ports

The following ports must be open on your server:

| Port | Protocol | Description                                           |
|------|----------|-------------------------------------------------------|
| 80   | TCP      | HTTP - Required for Let's Encrypt domain validation    |
| 443  | TCP      | HTTPS - Required for secure website access            |

### Opening Ports on UFW (Ubuntu Firewall)
```bash
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw reload
```

### Opening Ports on Firewalld (CentOS/RHEL)
```bash
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=443/tcp
sudo firewall-cmd --reload
```

### Check if Ports are Open
```bash
# Using netstat
sudo netstat -tulpn | grep -E ':80|:443'

# Using ss
sudo ss -tulpn | grep -E ':80|:443'

# Using lsof
sudo lsof -i :80 -i :443
```

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

3. **Make the Script Executable**
   ```bash
   chmod +x init-letsencrypt.sh
   ```

4. **Run the Setup with Your Email**
   ```bash
   ./init-letsencrypt.sh your-email@example.com
   ```

   This command:
   - Creates necessary directories
   - Generates temporary SSL certificate
   - Starts Nginx
   - Obtains Let's Encrypt certificate
   - Reloads Nginx with new certificate

5. **Verify the Setup**
   ```bash
   # Check running containers
   docker-compose ps
   
   # Check certbot logs
   docker-compose logs certbot
   
   # Check nginx logs
   docker-compose logs nginx
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

## Common Issues and Solutions

1. **Connection Refused Error**
   ```bash
   # Check if nginx is listening on ports
   sudo netstat -tulpn | grep -E ':80|:443'
   
   # Check nginx logs
   docker-compose logs nginx
   
   # Verify docker container is running
   docker-compose ps
   ```

2. **Certificate Issuance Fails**
   ```bash
   # Check if ports 80/443 are open
   curl -v http://lol.maleh.my.id/.well-known/acme-challenge/test
   
   # Check certbot logs
   docker-compose logs certbot
   ```

3. **DNS Issues**
   ```bash
   # Verify DNS resolution
   dig lol.maleh.my.id
   
   # Check A record is pointing to correct IP
   host lol.maleh.my.id
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
