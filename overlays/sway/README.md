# sway overlay

> This overlay implements sway using best practices.

## Resources

- https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
- https://github.com/swaywm/sway/wiki/Running-programs-natively-under-wayland
- https://wiki.archlinux.org/title/Uniform_look_for_Qt_and_GTK_applications
- https://wiki.archlinux.org/title/sway
- https://wiki.archlinux.org/title/wayland

## Roadmap

### Programs and features to add

- autotiling (python package)

### qgnomeplatform-qt5

qgnomeplatform-qt5 is only available for Sid and must be compiled for Bullseye.

Run the following to compile qgnomeplatform-qt5

```sh
sudo apt-get install -y \
  libadwaitaqt-dev \
  libc6-dev \
  libgtk-3-dev \
  libqt5waylandclient5-dev \
  qt5-style-plugins \
  qtbase5-private-dev
curl -L -o QGnomePlatform-0.9.0.tar.gz https://github.com/FedoraQt/QGnomePlatform/archive/refs/tags/0.9.0.tar.gz
tar -xzvf QGnomePlatform-0.9.0.tar.gz
cd QGnomePlatform-0.9.0
mkdir build
cd build
cmake ..
```
