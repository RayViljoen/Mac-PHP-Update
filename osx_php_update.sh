#!/bin/bash

# author: Ray Viljoen
# link: git remote add origin https://github.com/RayViljoen/Mac-PHP-Update.git
# Simple bash script to update OS X's bundled PHP to vers 5.4.
# Any problems please let me know at: https://github.com/RayViljoen

clear

echo -n "This update will take SEVERAL minutes to complete. Continue? (y/n)"
read ans
[ $ans == "n" ] && echo "OK, Bye!" && exit 0 || echo "Excellent. Let's begin..." && sleep 1

sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
ln -s /opt/X11 /usr/X11

# =================================================
# Update download version here
# Should simply increment on mirror site
PHP_VERS="5.4.10"
# =================================================

# Src target
PHP_SRC_DEST="${HOME}/Downloads/"

PHP_SRC_DIR="${PHP_SRC_DEST}php-${PHP_VERS}"

echo $PHP_SRC_DIR

# Download link. Update if needed. (stick with a .tar.gz)
PHP_SRC_LINK="http://uk3.php.net/get/php-${PHP_VERS}.tar.gz/from/this/mirror"

# Check for homebrew
command -v brew >/dev/null 2>&1 || { echo >&2 "
FAIL:
Homebrew is required to install some dependencies. (libjpeg & pcre)
Visit http://mxcl.github.com/homebrew/ for more info on installing Homebrew."; exit 1; }

# -----------------------
# Homebrew ok, so proceed
# -----------------------

# Update homebrew
echo "
-------------------------
1/9 - Updating Homebrew.
-------------------------"
sleep 1

# Check if user executed with sudo and set to user as homebrew doesn't want sudo
if [[ $SUDO_USER ]]; then sudo -u $SUDO_USER brew update
else brew update
fi

# Install dependancies
echo "
-------------------------------
2/9 - Installing dependancies.
-------------------------------"
sleep 1

# Check if user executed with sudo and set to user as homebrew doesn't want sudo
if [[ $SUDO_USER ]]; then sudo -u $SUDO_USER brew install libjpeg pcre libxml2 mcrypt
else brew install libjpeg pcre libxml2 mcrypt
fi

# Set -e as brew install stop script if already installed
set -e

# Download latest PHP to ~/Downloads
echo "
-------------------------------
3/9 - Downloading PHP 5.4 src.
-------------------------------"
sleep 1 && curl -L "${PHP_SRC_LINK}" > "${PHP_SRC_DIR}.tar.gz"

# Extract src and move to
echo "
----------------------
4/9 - Extracting src.
----------------------"
cd "${PHP_SRC_DEST}"
sleep 1 && tar -zxvf "${PHP_SRC_DIR}.tar.gz"
cd "${PHP_SRC_DIR}"

# Configure src
echo "
-----------------------
5/9 - Configuring src.
-----------------------"
sleep 1
./configure  \
--prefix=/usr  \
--mandir=/usr/share/man  \
--infodir=/usr/share/info  \
--sysconfdir=/private/etc  \
--with-apxs2=/usr/sbin/apxs  \
--enable-cli  \
--with-config-file-path=/etc  \
--with-libxml-dir=/usr  \
--with-openssl=/usr  \
--with-kerberos=/usr  \
--with-zlib=/usr  \
--enable-bcmath  \
--with-bz2=/usr  \
--enable-calendar  \
--with-curl=/usr  \
--enable-dba  \
--enable-exif  \
--enable-ftp  \
--with-gd  \
--enable-gd-native-ttf  \
--with-icu-dir=/usr  \
--with-iodbc=/usr  \
--with-ldap=/usr  \
--with-ldap-sasl=/usr  \
--with-libedit=/usr  \
--enable-mbstring  \
--enable-mbregex  \
--with-mysql=mysqlnd  \
--with-mysqli=mysqlnd  \
--without-pear  \
--with-pdo-mysql=mysqlnd  \
--with-mysql-sock=/var/mysql/mysql.sock  \
--with-readline=/usr  \
--enable-shmop  \
--with-snmp=/usr  \
--enable-soap  \
--enable-sockets  \
--enable-sysvmsg  \
--enable-sysvsem  \
--enable-sysvshm  \
--with-tidy  \
--enable-wddx  \
--with-xmlrpc  \
--with-iconv-dir=/usr  \
--with-xsl=/usr  \
--enable-zip  \
--with-pcre-regex  \
--with-pgsql=/usr  \
--with-pdo-pgsql=/usr \
--with-freetype-dir=/usr/X11 \
--with-jpeg-dir=/usr  \
--with-png-dir=/usr/X11

# Install
echo "
---------------------------------------------------
6/9 - Installing PHP 5.4 - sudo password required.
---------------------------------------------------"
sleep 2

# Check test flag else just install
if [ "${1}" = "--test" ]; then
	make test
fi

sudo make install

# Clean up
echo "
-----------------------------
7/9 - Cleaning up src files.
-----------------------------"
cd "${HOME}"
sleep 1
rm -rf "${PHP_SRC_DIR}".tar.gz
rm -rf "${PHP_SRC_DIR}"

# Print version
echo "
----------------------------
8/9 - Checking PHP version.
----------------------------"
php --version

# Done
echo "
-----------------
9/9 - All done.
-----------------"
