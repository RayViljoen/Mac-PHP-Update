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

# Src target
PHP_SRC_DEST="${HOME}/Downloads/"

PHP_SRC_DIR="${PHP_SRC_DEST}"php-5.4.6

# Download link. Update if needed. Currently at 5.4.6 (And obviously stick with a .tar.gz)
PHP_SRC_LINK="http://uk3.php.net/get/php-5.4.9.tar.gz/from/this/mirror"

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
-----------------------------------------------------
1/10 - Updating Homebrew and installing dependencies.
-----------------------------------------------------"
sleep 1 && brew update

# Install libjpeg
echo "
--------------------------
2/10 - Installing libjpeg.
--------------------------"
sleep 1

brew install libjpeg
brew install pcre
brew install libxml2
brew install mcrypt

# Install pcre
echo "
-----------------------
3/10 - Installing pcre.
-----------------------"
sleep 1 && brew install pcre

# Set -e as brew install stop script if already installed
set -e

# Download latest PHP to ~/Downloads
echo "
-------------------------------
4/10 - Downloading PHP 5.4 src.
-------------------------------"
sleep 1 && curl -L "${PHP_SRC_LINK}" > "${PHP_SRC_DIR}.tar.gz"

# Extract src and move to
echo "
----------------------
5/10 - Extracting src.
----------------------"
cd "${PHP_SRC_DEST}"
sleep 1 && tar -zxvf "${PHP_SRC_DIR}.tar.gz"
cd "${PHP_SRC_DIR}"

# Configure src
echo "
-----------------------
6/10 - Configuring src.
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
7/10 - Installing PHP 5.4 - sudo password required.
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
8/10 - Cleaning up src files.
-----------------------------"
cd "${HOME}"
sleep 1
rm -rf "${PHP_SRC_DIR}".tar.gz
rm -rf "${PHP_SRC_DIR}"

# Print version
echo "
----------------------------
9/10 - Checking PHP version.
----------------------------"
php --version

# Done
echo "
-----------------
10/10 - All done.
-----------------"