#!/bin/bash

# Use at your own risk

# Update all the things
sudo apt-get update
sudo apt-get upgrade # or dist-upgrade
sudo apt-get install screen build-essential libboost-filesystem-dev libboost-program-options-dev libboost-system-dev libboost-thread-dev scons libboost-all-dev python-pymongo git

# http://weworkweplay.com/play/raspberry-pi-nodejs/
cd; wget http://node-arm.herokuapp.com/node_latest_armhf.deb
sudo dpkg -i node_latest_armhf.deb
touch /home/pi/app.js
su pi -c 'node /home/pi/app.js < /dev/null &'

# http://ni-c.github.io/heimcontrol.js/get-started.html
cd; git clone git://github.com/RickP/mongopi.git; cd mongopi
# 4-6 hours - may want to run in screen
sudo scons
# 4-6 hours - may want to run in screen
sudo scons --prefix=/opt/mongo install
sudo scons -c
PATH=$PATH:/opt/mongo/bin/; export PATH
sudo useradd mongodb
sudo mkdir /var/lib/mongodb
sudo chown mongodb:mongodb /var/lib/mongodb
sudo mkdir /etc/mongodb/
sudo sh -c 'echo "dbpath=/var/lib/mongodb" > /etc/mongodb/mongodb.conf'
cd /etc/init.d
sudo wget -O mongodb https://gist.github.com/ni-c/fd4df404bda6e87fb718/raw/36d45897cd943fbd6d071c096eb4b71b37d0fcbb/mongodb.sh
sudo chmod +x mongodb
sudo update-rc.d mongodb defaults
sudo service mongodb start

# https://github.com/4commerce-technologies-AG/meteor/tree/release-0.9.3-universal
cd; git clone https://github.com/4commerce-technologies-AG/meteor.git; cd meteor

# If mongo and/or mongodb fail on the dev bundle script below:
#	PATH=$PATH:/opt/mongo/bin which mongo should return /opt/mongo/bin/mongo
# If it does enter:
#	PATH=$PATH:/opt/mongo/bin; export PATH
#	which mongo
./scripts/generate-dev-bundle.sh

# I coudldn't get the symlink to work from the git readme, so ~/meteor/./meteor where you'd normally type meteor works

# Backup and write img
# http://smittytone.wordpress.com/2013/09/06/back-up-a-raspberry-pi-sd-card-using-a-mac/