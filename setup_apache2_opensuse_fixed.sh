#!/bin/bash

# Fixed Apache2 Setup Script for OpenSUSE
# This script sets up Apache2 with two virtual hosts and includes verification steps

# Update system packages
sudo zypper refresh
sudo zypper update -y

# Install Apache2 and required packages with service
sudo zypper install -y apache2 apache2-utils apache2-mod_rewrite
sudo zypper install -y apache2.service

# Stop Apache2 if running
sudo systemctl stop apache2

# Create document root directories
sudo mkdir -p /srv/www/htdocs/locatie
sudo mkdir -p /srv/www/htdocs/opleiding

# Set proper permissions
sudo chown -R wwwrun:www /srv/www/htdocs/
sudo chmod -R 755 /srv/www/htdocs/

# Create HTML files
sudo tee /srv/www/htdocs/locatie/index.html > /dev/null <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>ROC Mondriaan</title>
</head>
<body>
    <h1>roc mondriaan</h1>
    <p>werket goed</p>
</body>
</html>
EOF

sudo tee /srv/www/htdocs/opleiding/index.html > /dev/null <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>ROC Mondriaan</title>
</head>
<body>
    <h1>roc mondriaan</h1>
    <p>werket goed</p>
</body>
</html>
EOF

# Clean and update hosts file
sudo sed -i '/locatierocmondriaan.nl/d' /etc/hosts
sudo sed -i '/opleidingrocmondriaan.nl/d' /etc/hosts
echo "127.0.0.1 locatierocmondriaan.nl" | sudo tee -a /etc/hosts
echo "127.0.0.1 opleidingrocmondriaan.nl" | sudo tee -a /etc/hosts

# Remove old virtual host files
sudo rm -f /etc/apache2/vhosts.d/locatierocmondriaan.conf
sudo rm -f /etc/apache2/vhosts.d/opleidingrocmondriaan.conf

# Create virtual host configurations with better settings
sudo tee /etc/apache2/vhosts.d/locatierocmondriaan.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerAdmin webmaster@locatierocmondriaan.nl
    ServerName locatierocmondriaan.nl
    DocumentRoot /srv/www/htdocs/locatie
    ErrorLog /var/log/apache2/locatie_error.log
    CustomLog /var/log/apache2/locatie_access.log combined
    <Directory "/srv/www/htdocs/locatie">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

sudo tee /etc/apache2/vhosts.d/opleidingrocmondriaan.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerAdmin webmaster@opleidingrocmondriaan.nl
    ServerName opleidingrocmondriaan.nl
    DocumentRoot /srv/www/htdocs/opleiding
    ErrorLog /var/log/apache2/opleiding_error.log
    CustomLog /var/log/apache2/opleiding_access.log combined
    <Directory "/srv/www/htdocs/opleiding">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

# Enable required Apache modules
sudo a2enmod rewrite
sudo a2enmod ssl
sudo a2enmod headers

# Create log directory
sudo mkdir -p /var/log/apache2
sudo chown -R wwwrun:www /var/log/apache2

# Test Apache configuration
sudo apache2ctl configtest

# Enable and start Apache2 service
sudo systemctl daemon-reload
sudo systemctl enable apache2.service
sudo systemctl start apache2.service

# Configure firewall
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --reload

# Restart Apache2 to ensure all changes are loaded
sudo systemctl restart apache2.service

# Wait for Apache to start
sleep 5

# Verification steps
echo "=== Verification ==="
echo "Apache2 status:"
sudo systemctl status apache2.service --no-pager

echo ""
echo "Testing local connections:"
curl -s -o /dev/null -w "locatierocmondriaan.nl: HTTP %{http_code}\n" http://locatierocmondriaan.nl
curl -s -o /dev/null -w "opleidingrocmondriaan.nl: HTTP %{http_code}\n" http://opleidingrocmondriaan.nl

echo ""
echo "Hosts file entries:"
grep "rocmondriaan.nl" /etc/hosts

echo ""
echo "Apache processes:"
ps aux | grep apache2 | grep -v grep

echo ""
echo "Listening ports:"
sudo netstat -tlnp | grep :80

echo ""
echo "Link 1: http://locatierocmondriaan.nl"
echo "Link 2: http://opleidingrocmondriaan.nl" 