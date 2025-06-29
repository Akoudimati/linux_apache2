#!/bin/bash

sudo zypper install -y apache2
sudo systemctl stop apache2

sudo mkdir -p /srv/www/htdocs/locatierocmondriaan.nl
sudo mkdir -p /srv/www/htdocs/opleidingrocmondriaan.nl

sudo tee /srv/www/htdocs/locatierocmondriaan.nl/index.html > /dev/null <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Locatie ROC Mondriaan</title>
</head>
<body>
    <h1>locatierocmondriaan.nl</h1>
</body>
</html>
EOF

sudo tee /srv/www/htdocs/opleidingrocmondriaan.nl/index.html > /dev/null <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Opleiding ROC Mondriaan</title>
</head>
<body>
    <h1>opleidingrocmondriaan.nl</h1>
</body>
</html>
EOF

sudo chown -R wwwrun:www /srv/www/htdocs/
sudo chmod -R 755 /srv/www/htdocs/

sudo mkdir -p /etc/apache2/vhosts.d

sudo tee /etc/apache2/vhosts.d/locatierocmondriaan.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerName locatierocmondriaan.nl
    DocumentRoot /srv/www/htdocs/locatierocmondriaan.nl
    <Directory "/srv/www/htdocs/locatierocmondriaan.nl">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

sudo tee /etc/apache2/vhosts.d/opleidingrocmondriaan.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerName opleidingrocmondriaan.nl
    DocumentRoot /srv/www/htdocs/opleidingrocmondriaan.nl
    <Directory "/srv/www/htdocs/opleidingrocmondriaan.nl">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

sudo sed -i '/locatierocmondriaan.nl/d' /etc/hosts
sudo sed -i '/opleidingrocmondriaan.nl/d' /etc/hosts
echo "127.0.0.1 locatierocmondriaan.nl" | sudo tee -a /etc/hosts
echo "127.0.0.1 opleidingrocmondriaan.nl" | sudo tee -a /etc/hosts

sudo systemctl enable apache2
sudo systemctl start apache2
sudo systemctl restart apache2 