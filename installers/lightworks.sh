# Lightworks Installer #

cd /tmp
apt-get install -y nvidia-cg-toolkit libportaudiocpp0
apt-get install -fy
wget http://downloads.lwks.com/lwks-12.6.0-amd64.deb
dpkg -i lwks*-amd64.deb
