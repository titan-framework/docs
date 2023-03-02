#!/bin/bash

echo "This script prepare a Titan Framework's deployment environment."

echo "Starting script..."

echo "Updating and upgrading..."

apt-get -y update
apt-get -y upgrade
apt-get -y dist-upgrade

echo "Done!"

echo "Install a lot of dependencies..."

echo "postfix postfix/mailname string localhost" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

DEBIAN_FRONTEND=noninteractive apt-get install -y antiword aptitude build-essential bzip2 curl default-jdk git imagemagick ffmpeg locales locate mailutils memcached nginx ntpdate php7.4-fpm php7.4-cli php7.4-curl php7.4-dev php7.4-gd php-imagick php7.4-ldap php7.4-mbstring php-memcached php7.4-pgsql php7.4-sqlite3 php-pear postfix postgresql-13 subversion xpdf-utils unzip vim

echo "Done!"

echo "Configuring locales..."

locale-gen "en_US.UTF-8"
locale-gen "es_ES.UTF-8"
locale-gen "pt_BR.UTF-8"

echo -e 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' > /etc/default/locale

dpkg-reconfigure --frontend=noninteractive locales

echo "Done!"

echo "Installing PHP Composer..."

curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

echo "Done!"

echo "Cleaning apt-get..."

apt-get autoremove
apt-get clean -y
apt-get autoclean -y

find /var/lib/apt -type f | xargs rm -f

find /var/lib/doc -type f | xargs rm -f

echo "Done!"

echo "Configuring services..."

echo "PostgreSQL..."

wget -qO /etc/postgresql/13/main/pg_hba.conf https://www.titanframework.com/environment/settings/pg_hba.conf

wget -qO /etc/postgresql/13/main/postgresql.conf https://www.titanframework.com/environment/settings/postgresql.conf

/etc/init.d/postgresql restart

echo "Done!"

echo "Memcached..."

wget -qO /etc/memcached.conf https://www.titanframework.com/environment/settings/memcached.conf

/etc/init.d/memcached restart

echo "Done!"

echo "PHP 7.0 FPM..."

wget -qO /etc/php/7.4/fpm/php.ini https://www.titanframework.com/environment/settings/php-fpm.ini

wget -qO /etc/php/7.4/cli/php.ini https://www.titanframework.com/environment/settings/php-cli.ini

wget -qO /etc/php/7.4/fpm/pool.d/www.conf https://www.titanframework.com/environment/settings/php-www.conf

/etc/init.d/php7.4-fpm restart

echo "Done!"

echo "Nginx..."

rm -rf /var/www/html

mkdir -p /var/www/app

mkdir -p /var/www/log

echo "<?php
phpinfo ();" > /var/www/app/index.php

chown -R root:staff /var/www/app
find /var/www/app -type d -exec chmod 775 {} \;
find /var/www/app -type f -exec chmod 664 {} \;

wget -qO /etc/nginx/sites-available/default https://www.titanframework.com/environment/settings/nginx-default

/etc/init.d/nginx restart

echo "Done!"

echo "SSH..."

wget -qO /etc/ssh/sshd_config https://www.titanframework.com/environment/settings/sshd_config

/etc/init.d/ssh restart

echo "Done!"

echo "CRON..."

wget -qO /etc/cron.d/titan https://www.titanframework.com/environment/settings/cron

/etc/init.d/cron reload
/etc/init.d/cron restart

echo "Done!"

echo "Getting Titan Framework..."

composer create-project titan-framework/install /var/www/titan

chown -R root:staff /var/www/titan
find /var/www/titan -type d -exec chmod 775 {} \;
find /var/www/titan -type f -exec chmod 664 {} \;

echo "Done!"

echo "Runnig 'updatedb' command (for locate)..."

updatedb

echo "All done!"

echo "Thanks for using Titan Framework! Enjoy it ;-)"

echo "http://titanframework.com"
