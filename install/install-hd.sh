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

#make flexget daemon run 
echo '# Configuration for /etc/init.d/flexget' > /etc/default/flexget
echo '# User to run flexget as.' >> /etc/default/flexget
echo '# Daemon will not start if left empty.' >> /etc/default/flexget
echo 'FGUSER="root"' >> /etc/default/flexget
echo '\n' >> /etc/default/flexget
echo '# Full path to the flexget config.yml file to use.' >> /etc/default/flexget
echo '# Defaults to FGUSER $HOME/.flexget/config.yml' >> /etc/default/flexget
echo 'CONFIG="/ragebmc/.flexget"' >> /etc/default/flexget
echo '\n' >> /etc/default/flexget
echo '# Path to the directory where flexget should log. Do not add trailing slash.' >> /etc/default/flexget
echo '# Defaults to the FGUSER $HOME/.flexget directory' >> /etc/default/flexget
echo 'LOG="/ragebmc/.flexget"' >> /etc/default/flexget
echo '\n' >> /etc/default/flexget
echo "# Log verbosity" >> /etc/default/flexget
echo "# Available options : none critical error warning info verbose debug trace" >> /etc/default/flexget
echo "# Defaults to info" >> /etc/default/flexget
echo "LEVEL="error"" >> /etc/default/flexget
cp /media/ce8d2931-bc64-4338-a65b-e647ae81f1f0/ragebmc/resources/config/flexget /etc/init.d/flexget
update-rc.d flexget defaults

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
