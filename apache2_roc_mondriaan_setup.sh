#!/bin/bash

sudo zypper refresh
sudo zypper update -y
sudo zypper install -y apache2 apache2-utils
sudo systemctl stop apache2
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

sudo mkdir -p /etc/apache2/vhosts.d
sudo rm -f /etc/apache2/vhosts.d/locatie.conf
sudo rm -f /etc/apache2/vhosts.d/opleiding.conf

sudo tee /etc/apache2/vhosts.d/locatie.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerName locatierocmondriaan.nl
    DocumentRoot /srv/www/htdocs/locatie
    <Directory "/srv/www/htdocs/locatie">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

sudo tee /etc/apache2/vhosts.d/opleiding.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerName opleidingrocmondriaan.nl
    DocumentRoot /srv/www/htdocs/opleiding
    <Directory "/srv/www/htdocs/opleiding">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

sudo tee /etc/apache2/listen.conf > /dev/null <<EOF
Listen 80
NameVirtualHost *:80
EOF

sudo sed -i '/locatierocmondriaan.nl/d' /etc/hosts
sudo sed -i '/opleidingrocmondriaan.nl/d' /etc/hosts
echo "127.0.0.1 locatierocmondriaan.nl" | sudo tee -a /etc/hosts
echo "127.0.0.1 opleidingrocmondriaan.nl" | sudo tee -a /etc/hosts
sudo mkdir -p /var/log/apache2
sudo chown -R wwwrun:www /var/log/apache2
sudo systemctl enable apache2
sudo systemctl start apache2
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --reload
sudo systemctl restart apache2 