#!/bin/bash

# setup
cd /root
apt-get install -y \
    curl \
    git \
    gnupg \
    python3-pip

# nerd fonts
git clone https://github.com/ryanoasis/nerd-fonts.git
cd nerd-fonts
bash ./install.sh -S
cd /root
rm -rf ./nerd-fonts

# virtualenv
pip3 install virtualenv

# i3pystatus
pip3 install git+https://github.com/enkore/i3pystatus.git

