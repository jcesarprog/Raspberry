#! /bin/bash

sudo apt-get update
suso apt-get upgrade
sudo apt-get install vsftpd -y

# ? Backup oringinal conf file
sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.original

sudo rm /etc/vsftpd.conf

# ? Copy here the basic vsftpd.conf file from github
sudo wget -O /etc/vsftpd.conf https://raw.githubusercontent.com/jcesarprog/Raspberry/dev/scripts/vsftpd.conf

# ? Creating the rsa file for secure connections valid for 1 year
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/vsftpd.pem -out /etc/ssl/private/vsftpd.pem

sudo service vsftpd restart