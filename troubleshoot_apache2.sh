#!/bin/bash

# Apache2 Troubleshooting Script for OpenSUSE

echo "=== Apache2 Troubleshooting ==="
echo ""

echo "1. Checking Apache2 service status:"
sudo systemctl status apache2 --no-pager
echo ""

echo "2. Checking if Apache2 is listening on port 80:"
sudo netstat -tlnp | grep :80
echo ""

echo "3. Checking Apache2 processes:"
ps aux | grep apache2 | grep -v grep
echo ""

echo "4. Checking hosts file entries:"
grep "rocmondriaan.nl" /etc/hosts
echo ""

echo "5. Testing Apache configuration:"
sudo apache2ctl configtest
echo ""

echo "6. Checking virtual host files:"
ls -la /etc/apache2/vhosts.d/
echo ""

echo "7. Testing local DNS resolution:"
nslookup locatierocmondriaan.nl
nslookup opleidingrocmondriaan.nl
echo ""

echo "8. Testing HTTP connections:"
curl -I http://locatierocmondriaan.nl 2>/dev/null || echo "Failed to connect to locatierocmondriaan.nl"
curl -I http://opleidingrocmondriaan.nl 2>/dev/null || echo "Failed to connect to opleidingrocmondriaan.nl"
echo ""

echo "9. Checking firewall status:"
sudo firewall-cmd --list-all
echo ""

echo "10. Checking Apache error logs:"
echo "--- Locatie errors ---"
sudo tail -10 /var/log/apache2/locatie_error.log 2>/dev/null || echo "No locatie error log found"
echo "--- Opleiding errors ---"
sudo tail -10 /var/log/apache2/opleiding_error.log 2>/dev/null || echo "No opleiding error log found"
echo ""

echo "11. Checking document root permissions:"
ls -la /srv/www/htdocs/
echo ""

echo "12. Testing with localhost:"
curl -s http://localhost/ && echo "Apache default page accessible"
echo ""

echo "=== Quick Fixes ==="
echo "If sites are not working, try these commands:"
echo "sudo systemctl restart apache2"
echo "sudo firewall-cmd --permanent --add-service=http && sudo firewall-cmd --reload"
echo "sudo apache2ctl configtest" 