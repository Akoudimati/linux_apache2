# Apache2 Setup for OpenSUSE

This repository contains a complete setup script for configuring Apache2 on OpenSUSE with two virtual hosts.

## Files:

1. **`setup_apache2_opensuse.sh`** - Original setup script
2. **`setup_apache2_opensuse_fixed.sh`** - **RECOMMENDED** Fixed setup script with better error handling
3. **`troubleshoot_apache2.sh`** - Troubleshooting script to diagnose issues

## What the fixed script does:

1. **Updates system packages** using zypper
2. **Installs Apache2** and required utilities
3. **Creates directories**:
   - `/srv/www/htdocs/locatie`
   - `/srv/www/htdocs/opleiding`
4. **Sets up virtual hosts**:
   - `locatierocmondriaan.nl` → `/srv/www/htdocs/locatie`
   - `opleidingrocmondriaan.nl` → `/srv/www/htdocs/opleiding`
5. **Adds host entries** using `127.0.0.1` (localhost):
   - `127.0.0.1 locatierocmondriaan.nl`
   - `127.0.0.1 opleidingrocmondriaan.nl`
6. **Creates simple HTML files** with "roc mondriaan" and "werket goed"
7. **Configures firewall** to allow HTTP traffic
8. **Includes verification steps** to check if everything is working

## How to use:

1. **Transfer the scripts** to your OpenSUSE system
2. **Make them executable**:
   ```bash
   chmod +x setup_apache2_opensuse_fixed.sh
   chmod +x troubleshoot_apache2.sh
   ```
3. **Run the fixed setup script**:
   ```bash
   ./setup_apache2_opensuse_fixed.sh
   ```

## If sites are not working:

1. **Run the troubleshooting script**:
   ```bash
   ./troubleshoot_apache2.sh
   ```

2. **Check the verification output** from the setup script

## After installation:

- Visit: `http://locatierocmondriaan.nl`
- Visit: `http://opleidingrocmondriaan.nl`

Both sites will display "roc mondriaan" and "werket goed".

## Key fixes in the improved script:

- ✅ Uses `127.0.0.1` instead of `192.168.1.100` for better local testing
- ✅ Includes verification steps and diagnostic information
- ✅ Better Apache module configuration
- ✅ Improved error handling and service management
- ✅ Comprehensive troubleshooting script included

## Log files:

- `/var/log/apache2/locatie_error.log`
- `/var/log/apache2/locatie_access.log`
- `/var/log/apache2/opleiding_error.log`
- `/var/log/apache2/opleiding_access.log`

## Configuration files:

- Virtual hosts: `/etc/apache2/vhosts.d/`
- Hosts file: `/etc/hosts`

The scripts include verification steps and will provide detailed status information during execution. 