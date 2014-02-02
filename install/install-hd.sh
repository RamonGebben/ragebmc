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
apt-add-repository -y ppa:fish-shell/release-2   # fish
add-apt-repository -y ppa:transmissionbt/ppa        # transmission
apt-get update

# install it all at once
apt-get -y install mosh fish git toilet transmission-cli transmission-common transmission-daemon python2.6
apt-get -y install python-pip

# install flexget
pip install flexget
easy_install transmissionrpc

# set default group
addgroup ragebmc
usermod -g ragebmc root
echo "%ragebmc   ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/ragebmc
chmod 0440 /etc/sudoers.d/ragebmc

# checkout ragebmc
mkdir -p /media/ce8d2931-bc64-4338-a65b-e647ae81f1f0/ragebmc
cd /media/ce8d2931-bc64-4338-a65b-e647ae81f1f0/ragebmc
git clone https://github.com/RamonGebben/ragebmc.git .
mkdir -p /media/ce8d2931-bc64-4338-a65b-e647ae81f1f0/ragebmc/series
mkdir -p /media/ce8d2931-bc64-4338-a65b-e647ae81f1f0/ragebmc/movies
mkdir -p /media/ce8d2931-bc64-4338-a65b-e647ae81f1f0/ragebmc/incomplete
mkdir -p /media/ce8d2931-bc64-4338-a65b-e647ae81f1f0/ragebmc/resources

# fix ownership
chown -R root:ragebmc /media/ce8d2931-bc64-4338-a65b-e647ae81f1f0/ragebmc 
chown -R root:ragebmc /media/ce8d2931-bc64-4338-a65b-e647ae81f1f0/ragebmc

#fixing up transmission"
service transmission-daemon stop
cp /media/ce8d2931-bc64-4338-a65b-e647ae81f1f0/ragebmc/resources/config/settings.json /etc/transmission-daemon/settings.json
cp /media/ce8d2931-bc64-4338-a65b-e647ae81f1f0/ragebmc/resources/config/transmission-daemon /etc/init.d/transmission-daemon
service transmission-daemon start

# link fish functions
ln -s /media/ce8d2931-bc64-4338-a65b-e647ae81f1f0/ragebmc/fish /etc/fish/functions


# fix default umask
sed -i 's/UMASK\s*022/UMASK 002/g' /etc/login.defs

echo "***************************"
echo "REBOOT and run rb-upgrade"
#reboot
