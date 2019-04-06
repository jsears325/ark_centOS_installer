#! /bin/bash

# Update systedm and then install tools
yum update -y
yum install nano wget screen tar glibc.i686 libgcc.i686 libstc++.i686 -y

# Set file limits
echo "fs.file-max=100000" >> /etc/sysctl.conf
sysctl -p
echo "* soft nofile 1000000" >> /etc/security/limits.conf
echo "* hard nofile 1000000" >> /etc/security/limits.conf
echo "session required pam_limits.so" >> /etc/pam.d/system-auth

# Modify firewalls
firewall-cmd --permanent --add-port=27015/udp
firewall-cmd --permanent --add-port=7777/udp
firewall-cmd --permanent --add-port=32330/tcp
iptables -A INPUT -p udp -m udp --sport 27015 --dport 1025:65355 -j ACCEPT
iptables -A INPUT -p udp -m udp --sport 7777 --dport 1025:65355 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --sport 32330 --dport 1025:65355 -j ACCEPT

# User Creation
adduser -s /usr/sbin/nologin steam
su -s /bin/bash/ steam
cd ~

# Pull steamcmd, creat script files, etc
wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
tar -zxvf steamcmd_linux.tar.gz
rm steamcmd_linux.tar.gz
./steamcmd.sh +login anonymous +force_installdir ./arkserver +app_update 376030 validate +quit
echo "login anonymous" >> /home/steam/upscript
echo "force_install_dir ./arkserver" >> /home/steam/upscript
echo "app_update 376030" >> /home/steam/upscript
echo "quit" >> /home/steam/upscript
