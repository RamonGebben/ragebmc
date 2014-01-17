#!/bin/sh 

# fix locale error messages with apt
echo "LANG=\"en_US.UTF-8\"" > /etc/default/locale
echo "LANGUAGE=\"en_US.UTF-8\"" >> /etc/default/locale
echo "LC_ALL=\"en_US.UTF-8\"" >> /etc/default/locale
locale-gen en_US en_US.UTF-8
dpkg-reconfigure locales

# upgrade to zero-day
apt-get update
apt-get -y upgrade

# add support for ppa
apt-get install -y python-software-properties

# repositories
add-apt-repository -y ppa:keithw/mosh            # mosh
apt-add-repository -y ppa:fish-shell/release-2   # fish
add-apt-repository ppa:transmissionbt/ppa        # transmission
apt-get update

# install it all at once
apt-get -y install mosh fish git toilet transmission-cli transmission-common transmission-daemon python2.6
apt-get -y install python-pip

# install flexget
pip install flexget
easy_install transmissionrpc

# set default group
usermod -g ragebmc root
addgroup ragebmc
echo "%ragebmc   ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/ragebmc
chmod 0440 /etc/sudoers.d/ragebmc

# checkout ragebmc
mkdir -p /ragebmc
cd /ragebmc
git clone https://github.com/RamonGebben/ragebmc.git .
mkdir -p /ragebmc/series
mkdir -p /ragebmc/movies
mkdir -p /ragebmc/incomplete
mkdir -p /ragebmc/resources

# fix ownership
chown -R root:ragebmc /ragebmc 
chown -R root:ragebmc /ragebmc

# link fish functions
ln -s /ragebmc/fish /etc/fish/functions

# fix default umask
sed -i 's/UMASK\s*022/UMASK 002/g' /etc/login.defs

echo "***************************"
echo "REBOOT and run rb-update"
#reboot
