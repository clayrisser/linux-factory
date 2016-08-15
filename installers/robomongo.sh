# RoboMongo Installer

cd /tmp
wget https://download.robomongo.org/0.9.0-rc9/linux/robomongo-0.9.0-rc9-linux-x86_64-0bb5668.tar.gz
tar -vxzf robomongo-*.tar.gz
mkdir /opt/robomongo/
mv robomongo-*/* /opt/robomongo
rm -rf robomongo-*.tar.gz
