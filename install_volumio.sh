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

sudo delgroup -remove-home pi
sudo deluser pi

sudo chmod 4511 /usr/bin/passwd
sudo chmod u+s /bin/*

u=$(id pi | grep uid | wc -l)
if (( "$u" == "0" )); then
        sudo addgroup --gid 1001 pi
        sudo useradd -m -d /home/pi -s /bin/bash -g 1001 -p '' -u 1001 pi
        sudo sh -c "echo 'pi:raspberry'  | sudo chpasswd  "
        sudo sh -c "echo 'pi ALL=NOPASSWD: ALL' >> /etc/sudoers"
fi

sudo /bin/rm -v /etc/ssh/ssh_host_* -f
sudo dpkg-reconfigure openssh-server
sudo /etc/init.d/ssh restart
