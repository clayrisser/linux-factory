#!/bin/sh

ARCH=${ARCH:-amd64}
sudo true
. /etc/os-release

# prevent password prompt for sudo
sudo sed -i 's|%sudo\s\+.*|%sudo ALL=(ALL:ALL) NOPASSWD:ALL|g' /etc/sudoers

# install swayvnc
curl -L https://gitlab.com/bitspur/community/swayvnc/-/raw/main/install.sh | sudo sh

# install gitlab runner
if ! which gitlab-runner >/dev/null 2>/dev/null; then
    curl -Lo /tmp/gitlab-runner.deb https://gitlab-runner-downloads.s3.amazonaws.com/latest/deb/gitlab-runner_${ARCH}.deb
    while sudo fuser /var/lib/dpkg/lock-frontend 2>/dev/null; do
        echo "DPKG is locked, waiting and then will check again"
        sleep 1
    done
    sudo dpkg -i /tmp/gitlab-runner.deb 2>/dev/null || ( sudo apt-get install -fy && sudo dpkg -i /tmp/gitlab-runner.deb )
    rm -rf /tmp/gitlab-runner.deb
    sudo /sbin/usermod -aG sudo gitlab-runner
    sudo -u gitlab-runner git lfs install
fi

# install virtualbox
wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg
echo "deb [arch=${ARCH} signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian $VERSION_CODENAME contrib" | \
    sudo tee /etc/apt/sources.list.d/virtualbox.list
sudo apt-get update
sudo apt-get install -y \
    virtualbox-7* \
    linux-headers-*
sudo /sbin/vboxconfig
