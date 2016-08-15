# WordPress Installer

cd /var/www/html/
wget https://wordpress.org/latest.zip
unzip latest.zip
rm -rf latest.zip
chown -R $SUDO_USER:$SUDO_USER /var/www/html/wordpress
find /var/www/html/wordpress -type d -exec chmod 0755 {} \;
find /var/www/html/wordpress -type f -exec chmod 0644 {} \;
service apache2 restart
