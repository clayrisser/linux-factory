#!/bin/bash

# repos
echo | add-apt-repository ppa:codejamninja/jam-os

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

# oh my zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git /etc/skel/.oh-my-zsh
git clone https://github.com/denysdovhan/spaceship-prompt.git \
    /etc/skel/.oh-my-zsh/custom/themes/spaceship-prompt
ln -s /etc/skel/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme \
   /etc/skel/.oh-my-zsh/custom/themes/spaceship.zsh-theme
