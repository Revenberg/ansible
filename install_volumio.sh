#!/bin/bash
#if [ $# -ne 1 ]; then
#    echo $0: usage: ./install.sh  password
#    return 0
#fi

sudo rm -rf /home/volumio/ansible*
date >> /home/volumio/ansible.log

i=$(sudo ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'| head -n1)
h=$(hostname)

sudo dpkg-reconfigure openssh-server
sudo /etc/init.d/ssh restart

sudo deluser pi
sudo deluser -G pi

sudo chmod 4511 /usr/bin/passwd
u=$(id pi | grep uid | wc -l)
if (( "$u" == "0" )); then
        sudo useradd -p '$6$D.dfIAuX$zMBRXgKwX04mo7TmEeD98Hw4uuwVYHQsn5VukbpBYFnKRWQukktf22DGQ1KPTsd5UOMPEloLZikqFtQU918C04' pi

#       sudo sh -c "echo 'pi ALL=NOPASSWD: ALL' >> /etc/sudoers"
#       sudo sh -c "ssh-keygen -t rsa -b 4096 -C "pi" -P "" -f "/home/pi/.ssh/id_rsa" -q"
#       ssh-copy-id $i
fi

sudo /bin/rm -v /etc/ssh/ssh_host_* -f
sudo dpkg-reconfigure openssh-server
sudo /etc/init.d/ssh restart

#sudo rm /home/volumio/.ssh/*
#ssh-keygen -f "/home/volumio/.ssh/known_hosts" -R $i

#ssh-keygen -t rsa -b 4096 -C "pi" -P "" -f "/home/volumio/.ssh/id_rsa" -q
#sudo cp /home/volumio/.ssh/id_rsa /home/pi/.ssh/id_rsa
#sudo chown pi:pi /home/pi/.ssh/id_rsa

#ssh-copy-id $i
