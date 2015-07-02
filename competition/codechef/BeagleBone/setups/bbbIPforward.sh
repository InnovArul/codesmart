#!/bin/sh

# bbbIPforward.sh -- Enable internet access for my BeagleBone Black (BBB)
# using my Linux HOST as a router
# Inspired by http://shallowsky.com/blog/hardware/talking-to-beaglebone.html

# basically the belwo settings has to be done 
#
# IN BBB (this can be added to /usr/bin/g-ether-load.sh for automatic setting up while booting)
#
# /sbin/ifconfig usb0 192.168.7.2 netmask 255.255.255.252    # configure IP address of USB
# /sbin/route add default gw 192.168.7.1                     # configure defafult gateway
# echo 'nameserver 8.8.8.8' >> /etc/resolv.conf              # configure google nameserver
#
# IN LINUX HOST (IP FORWARDING)
#
# sudo iptables -A POSTROUTING -t nat -j MASQUERADE
# echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward > /dev/null
#

bbbAddr="192.168.7.2"
hostAddr="192.168.7.1"

# Configure IP forwarding on HOST
sudo iptables -A POSTROUTING -t nat -j MASQUERADE
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward > /dev/null

# Copy ssh key to BBB for passwordless logins
ssh-copy-id root@$bbbAddr

# Configure BBB to use HOST as gateway
ssh root@$bbbAddr "/sbin/route add default gw $hostAddr"

# Backup and substitute BBB resolv.conf with HOST resolv.conf
ssh root@$bbbAddr "mv -n /etc/resolv.conf /etc/resolv.conf.bak"
scp /etc/resolv.conf root@$bbbAddr:/etc/
