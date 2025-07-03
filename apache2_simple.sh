# COMPLETE APACHE VIRTUAL HOST SETUP - OpenSUSE (EXAM READY)

# 1. Install and start Apache2
zypper install apache2
systemctl start apache2.service
systemctl enable apache2.service

# 2. Create directories and HTML files
mkdir -p /srv/www/vhosts/locatierocmondriaan.nl
mkdir -p /srv/www/vhosts/opleidingrocmondriaan.nl

# Create index.html for locatie
cat > /srv/www/vhosts/locatierocmondriaan.nl/index.html << 'EOF'
<html>
<head>
<title>Locatie ROC Mondriaan</title>
</head>
<body>
<h1>Locatie ROC Mondriaan</h1>
</body>
</html>
EOF

# Create index.html for opleiding
cat > /srv/www/vhosts/opleidingrocmondriaan.nl/index.html << 'EOF'
<html>
<head>
<title>Opleiding ROC Mondriaan</title>
</head>
<body>
<h1>Opleiding ROC Mondriaan</h1>
</body>
</html>
EOF

# 3. View the template (for exam knowledge)
cat /etc/apache2/vhosts.d/vhost.template

# 4. Create virtual host configuration files
cd /etc/apache2/vhosts.d

cat > locatie.conf << 'EOF'
<VirtualHost *:80>
    ServerName locatierocmondriaan.nl
    DocumentRoot /srv/www/vhosts/locatierocmondriaan.nl
    
    <Directory /srv/www/vhosts/locatierocmondriaan.nl>
        AllowOverride None
        Require all granted
    </Directory>
    
    ErrorLog /var/log/apache2/locatie_error.log
    CustomLog /var/log/apache2/locatie_access.log combined
</VirtualHost>
EOF

cat > opleiding.conf << 'EOF'
<VirtualHost *:80>
    ServerName opleidingrocmondriaan.nl
    DocumentRoot /srv/www/vhosts/opleidingrocmondriaan.nl
    
    <Directory /srv/www/vhosts/opleidingrocmondriaan.nl>
        AllowOverride None
        Require all granted
    </Directory>
    
    ErrorLog /var/log/apache2/opleiding_error.log
    CustomLog /var/log/apache2/opleiding_access.log combined
</VirtualHost>
EOF

# 5. Set correct permissions
chown -R wwwrun:www /srv/www/vhosts
chmod -R 755 /srv/www/vhosts
chmod 644 /srv/www/vhosts/*/index.html

# 6. Enable NameVirtualHost (if not already enabled)
echo "NameVirtualHost *:80" >> /etc/apache2/listen.conf

# 7. Test configuration
apache2ctl configtest

# 8. Restart Apache
systemctl restart apache2.service

# 9. Add entries to /etc/hosts for local testing
IP=$(hostname -I | awk '{print $1}')
echo "$IP locatierocmondriaan.nl" >> /etc/hosts
echo "$IP opleidingrocmondriaan.nl" >> /etc/hosts

# 10. Test the setup
echo "Testing locatie site:"
curl http://locatierocmondriaan.nl

echo "Testing opleiding site:"
curl http://opleidingrocmondriaan.nl

# 11. Test in Firefox browser
# firefox http://locatierocmondriaan.nl
# firefox http://opleidingrocmondriaan.nl

# FOR WINDOWS CLIENT CONFIGURATION:
# Add these lines to C:\Windows\System32\drivers\etc\hosts
# [Your-OpenSUSE-IP] locatierocmondriaan.nl
# [Your-OpenSUSE-IP] opleidingrocmondriaan.nl

echo "Setup complete! Ready for exam."
echo "Your server IP is: $IP"
echo "Add this IP to Windows hosts file for client testing."
#for windows 
echo 192.168.1.100 locatierocmondriaan.nl >> C:\Windows\System32\drivers\etc\hosts
echo 192.168.1.100 opleidingrocmondriaan.nl >> C:\Windows\System32\drivers\etc\hosts
