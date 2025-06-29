# Apache2 Setup for OpenSUSE

This repository contains a complete setup script for configuring Apache2 on OpenSUSE with two virtual hosts.

## What the script does:

1. **Updates system packages** using zypper
2. **Installs Apache2** if not already installed
3. **Creates directories**:
   - `/srv/www/htdocs/locatie`
   - `/srv/www/htdocs/opleiding`
4. **Sets up virtual hosts**:
   - `locatierocmondriaan.nl` → `/srv/www/htdocs/locatie`
   - `opleidingrocmondriaan.nl` → `/srv/www/htdocs/opleiding`
5. **Adds host entries**:
   - `192.168.1.100 locatierocmondriaan.nl`
   - `192.168.1.100 opleidingrocmondriaan.nl`
6. **Creates simple HTML files** with "roc mondriaan" and "werket goed"
7. **Configures firewall** to allow HTTP traffic
8. **Restarts Apache2** service

## How to use:

1. **Transfer the script** to your OpenSUSE system
2. **Make it executable**:
   ```bash
   chmod +x setup_apache2_opensuse.sh
   ```
3. **Run the script**:
   ```bash
   ./setup_apache2_opensuse.sh
   ```

## After installation:

- Visit: `http://locatierocmondriaan.nl`
- Visit: `http://opleidingrocmondriaan.nl`

Both sites will display "roc mondriaan" and "werket goed".

## Log files:

- `/var/log/apache2/locatie_error.log`
- `/var/log/apache2/locatie_access.log`
- `/var/log/apache2/opleiding_error.log`
- `/var/log/apache2/opleiding_access.log`

## Configuration files:

- Virtual hosts: `/etc/apache2/vhosts.d/`
- Hosts file: `/etc/hosts`

The script includes error handling and will provide status updates during execution. 