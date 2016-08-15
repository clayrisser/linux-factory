# PyCharm Installer

cd /tmp
wget https://download-cf.jetbrains.com/python/pycharm-community-2016.1.4.tar.gz
tar -vxzf pycharm-community-*.tar.gz
mkdir /opt/pycharm/
mv pycharm-community-*/* /opt/pycharm/
rm -rf pycharm-community-*.tar.gz
