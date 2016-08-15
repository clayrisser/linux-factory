# Enpass Installer

cd /tmp
echo deb http://repo.sinew.in/ stable main | tee /etc/apt/sources.list.d/enpass.list
wget -O - http://repo.sinew.in/keys/enpass-linux.key | apt-key add -
apt-get update
apt-get install -y enpass
