#!/bin/bash

# Apache2 Setup Script for OpenSUSE
# This script sets up Apache2 with two virtual hosts: locatierocmondriaan.nl and opleidingrocmondriaan.nl

sudo zypper refresh
sudo zypper update -y

sudo zypper install -y apache2

sudo systemctl enable apache2
sudo systemctl start apache2

sudo mkdir -p /srv/www/htdocs/locatie
sudo mkdir -p /srv/www/htdocs/opleiding

sudo chown -R wwwrun:www /srv/www/htdocs/
sudo chmod -R 755 /srv/www/htdocs/

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

sudo sed -i '/locatierocmondriaan.nl/d' /etc/hosts
sudo sed -i '/opleidingrocmondriaan.nl/d' /etc/hosts

echo "192.168.1.100 locatierocmondriaan.nl" | sudo tee -a /etc/hosts
echo "192.168.1.100 opleidingrocmondriaan.nl" | sudo tee -a /etc/hosts

sudo rm -f /etc/apache2/vhosts.d/locatierocmondriaan.conf
sudo rm -f /etc/apache2/vhosts.d/opleidingrocmondriaan.conf

sudo tee /etc/apache2/vhosts.d/locatierocmondriaan.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerAdmin webmaster@locatierocmondriaan.nl
    ServerName locatierocmondriaan.nl
    DocumentRoot /srv/www/htdocs/locatie
    ErrorLog /var/log/apache2/locatie_error.log
    CustomLog /var/log/apache2/locatie_access.log combined
    <Directory "/srv/www/htdocs/locatie">
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
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

sudo a2enmod rewrite
sudo a2enmod ssl

sudo mkdir -p /var/log/apache2
sudo chown -R wwwrun:www /var/log/apache2

sudo systemctl stop apache2

sudo apache2ctl configtest

sudo systemctl start apache2
sudo systemctl restart apache2

sleep 3
sudo systemctl start apache2

sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --reload

sudo systemctl restart apache2

sleep 5

