# Private Internet Access Installer

wget https://www.privateinternetaccess.com/installer/install_ubuntu.sh
sed -i 's#/usr/bin/nmcli nm enable false#/usr/bin/nmcli networking off#g' install_ubuntu.sh
sed -i 's#/usr/bin/nmcli nm enable true#/usr/bin/nmcli networking on#g' install_ubuntu.sh
chmod +x install_ubuntu.sh
sh ./install_ubuntu.sh
rm -rf install_ubuntu.sh
