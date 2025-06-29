#!/bin/bash

sudo zypper install -y apache2
sudo systemctl stop apache2

sudo mkdir -p /srv/www/vhosts/locatierocmondriaan.nl
sudo mkdir -p /srv/www/vhosts/opleidingrocmondriaan.nl

sudo tee /srv/www/vhosts/locatierocmondriaan.nl/index.html > /dev/null <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>ROC Mondriaan</title>
</head>
<body>
    <h1>This is locatierocmondriaan.nl</h1>
</body>
</html>
EOF

sudo tee /srv/www/vhosts/opleidingrocmondriaan.nl/index.html > /dev/null <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>ROC Mondriaan</title>
</head>
<body>
    <h1>This is opleidingrocmondriaan.nl</h1>
</body>
</html>
EOF

sudo chown -R wwwrun:www /srv/www/vhosts/
sudo chmod -R 755 /srv/www/vhosts/

sudo mkdir -p /etc/apache2/vhosts.d

sudo tee /etc/apache2/vhosts.d/locatierocmondriaan.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerName locatierocmondriaan.nl
    DocumentRoot /srv/www/vhosts/locatierocmondriaan.nl
    <Directory "/srv/www/vhosts/locatierocmondriaan.nl">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

sudo tee /etc/apache2/vhosts.d/opleidingrocmondriaan.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerName opleidingrocmondriaan.nl
    DocumentRoot /srv/www/vhosts/opleidingrocmondriaan.nl
    <Directory "/srv/www/vhosts/opleidingrocmondriaan.nl">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
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