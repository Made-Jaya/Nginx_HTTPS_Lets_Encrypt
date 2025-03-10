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

4. **Stop Any Running Web Servers**
   ```bash
   sudo systemctl stop nginx apache2
   ```

5. **Run the Setup Script**
   ```bash
   sudo ./init-letsencrypt.sh your-email@example.com
   ```

   This script will:
   - Install Certbot if not installed
   - Stop any running web servers
   - Obtain SSL certificate using standalone mode
   - Set up Docker environment
   - Copy certificates to the correct location
   - Start Nginx in Docker

6. **Verify the Setup**
   ```bash
   # Check the certificate
   curl -vI https://lol.maleh.my.id
   
   # Check nginx container
   docker-compose ps
   
   # View nginx logs
   docker-compose logs nginx
   ```

## Troubleshooting

1. **Certificate Issues**
   ```bash
   # Check certificate status
   sudo certbot certificates
   
   # View certificate details
   openssl x509 -in /etc/letsencrypt/live/lol.maleh.my.id/cert.pem -text -noout
   ```

2. **Nginx Container Issues**
   ```bash
   # Check container logs
   docker-compose logs nginx
   
   # Verify nginx config
   docker-compose exec nginx nginx -t
   ```

3. **Port Conflicts**
   ```bash
   # Check for processes using ports 80/443
   sudo lsof -i :80 -i :443
   
   # Stop conflicting services
   sudo systemctl stop apache2 nginx
   ```

4. **Permission Issues**
   ```bash
   # Fix certificate permissions
   sudo chown -R $USER:$USER ./data/certbot/conf/
   
   # Check directory permissions
   ls -la ./data/certbot/conf/
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
