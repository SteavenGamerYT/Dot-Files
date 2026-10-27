#!/usr/bin/env bash
sudo systemctl disable --now firewalld
sudo ufw disable
sudo ufw allow ssh comment 'ssh'
sudo ufw allow 1714:1764/udp comment 'kde connect'
sudo ufw allow 1714:1764/tcp comment 'kde connect'
sudo ufw allow 631 comment 'cups'
sudo ufw allow 24872 comment 'suyu'
sudo ufw allow 25565/tcp comment 'minecraft'
sudo ufw allow 4995/tcp comment 'moonlight PC'
sudo ufw allow 5000/tcp comment 'moonlight PC'
sudo ufw allow 5001/tcp comment 'moonlight PC'
sudo ufw allow 5021/tcp comment 'moonlight PC'
sudo ufw allow 5009/udp comment 'moonlight PC'
sudo ufw allow 5010/udp comment 'moonlight PC'
sudo ufw allow 5011/udp comment 'moonlight PC'
sudo ufw allow 5995/tcp comment 'moonlight Laptop'
sudo ufw allow 6000/tcp comment 'moonlight Laptop'
sudo ufw allow 6001/tcp comment 'moonlight Laptop'
sudo ufw allow 6021/tcp comment 'moonlight Laptop'
sudo ufw allow 6009/udp comment 'moonlight Laptop'
sudo ufw allow 6010/udp comment 'moonlight Laptop'
sudo ufw allow 6011/udp comment 'moonlight Laptop'
sudo ufw allow 8384 comment "syncthing"
sudo ufw allow 137/udp comment "samba"
sudo ufw allow 138/udp comment "samba"
sudo ufw allow 139/tcp comment "samba"
sudo ufw allow 445/tcp comment "samba"
sudo ufw allow 27015/tcp comment "portal 1"
sudo ufw allow 27015/udp comment "portal 1"
sudo ufw allow 27040/tcp comment "steam network transfer"
sudo ufw allow 27031/udp comment "steam client discovery"
sudo ufw allow 27032/udp comment "steam client discovery"
sudo ufw allow 27033/udp comment "steam client discovery"
sudo ufw allow 27034/udp comment "steam client discovery"
sudo ufw allow 27035/udp comment "steam client discovery"
sudo ufw allow 27036/udp comment "steam client discovery"
sudo ufw allow 5353/udp comment "avahi-daemon"
sudo ufw allow 4242 comment "lan-mouse"
sudo ufw allow 9100 comment "hplip"
sudo ufw allow 53 comment "waydroid"
sudo ufw allow 67 comment "waydroid"
sudo ufw route allow in on waydroid0 out on $(ip route | awk '/default/ {print $5}') comment "waydroid"
sudo ufw route allow in on $(ip route | awk '/default/ {print $5}') out on waydroid0 comment "waydroid"
sudo ufw reload
sudo ufw enable
sudo ufw status numbered
sudo ufw status verbose
