#!/usr/bin/env bash

xdebug () {
read xdebugpart
echo "xdebug location at $xdebugpart"
cat << EOF | sudo tee -a /etc/php5/apache2/php.ini
xdebug.remote_host = 192.168.33.1
xdebug.remote_enable = 1
xdebug.remote_port = 9000
xdebug.remote_handler = dbgp
xdebug.remote_mode = req
zend_extension=$xdebugpart
EOF

cat << EOF | sudo tee -a /etc/php5/cli/php.ini
xdebug.remote_host = 192.168.33.1
xdebug.remote_enable = 1
xdebug.remote_port = 9000
xdebug.remote_handler = dbgp
xdebug.remote_mode = req
EOF
}


mkDirIfNotExist() {
if [ -d $1 ];
then
    echo $1 " exists"
else
    echo $1 " not exists"
    sudo mkdir -p $1
    echo $1 " created"
fi
}

forceSymLink() {
    sudo rm -rf $2
    sudo ln -s $1 $2
    echo $2 " created"
}

echo "Start provisioning"

sudo apt-get update >/dev/null 2>&1

sudo a2enmod headers
echo "installing phing"
sudo apt-get install php5-dev >/dev/null 2>&1
sudo apt-get install php-pear >/dev/null 2>&1
sudo pear channel-discover pear.phing.info >/dev/null 2>&1
sudo pear install --alldeps phing/phing >/dev/null 2>&1

sudo apt-get install php5-xdebug >/dev/null 2>&1
echo "writing xdebug"
cd /usr/lib
find $PWD -name "xdebug.so"  | xdebug
cd /vagrant

sudo rm -rf /etc/apache2/sites-enabled/*
sudo cp -r /vagrant/apache_hosts/* /etc/apache2/sites-available/
sudo a2ensite 0_macro.conf
sudo a2ensite vhosts.conf
sudo a2ensite ssl.conf
forceSymLink "/var/www/www.zf2.dev/project/public" "/var/www/www.zf2.dev/webroot"

sudo chown -R www-data.www-data /var/www/www.zf2.dev

sudo service apache2 restart >/dev/null 2>&1
#in case mysql is not running
sudo service mysql restart >/dev/null 2>&1

echo "Provisioning complete"