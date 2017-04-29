#!/bin/bash

sudo rm -rf /home/volumio/ansible*
date >> /home/volumio/ansible.log

i=$(sudo grep "pi ALL=NOPASSWD: ALL" /etc/sudoers | wc -l)
if (( "$i" == "0" )); then
        sudo adduser pi volumio
        sudo sh -c "echo 'pi:'$1  | chpasswd pi"

        sudo sh -c "echo 'pi ALL=NOPASSWD: ALL' >> /etc/sudoers"
fi

i=$(sudo ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'| head -n1)
h=$(hostname)

sudo /bin/rm -v /etc/ssh/ssh_host_* -f
sudo dpkg-reconfigure openssh-server
sudo /etc/init.d/ssh restart

ssh-keygen -t rsa -b 4096 -C "pi" -P "" -f "/home/volumio/.ssh/id_rsa" -q
sudo cp /home/volumio/.ssh/id_rsa /home/pi/.ssh/id_rsa
sudo chown pi:pi /home/volumio/.ssh/id_rsa

ssh-keygen -f "/home/volumio/.ssh/known_hosts" -R $i

sudo apt-get update
sudo apt-get autoremove

sudo apt-get install git -y

# Install Ansible and Git on the machine.
sudo apt-get install python-pip git python-dev sshpass -y
sudo pip install ansible
sudo pip install markupsafe

git clone https://github.com/Revenberg/ansible.git
git clone https://github.com/Revenberg/ansible-install.git
git clone https://github.com/Revenberg/ansible-volumio-media.git

echo "$h ansible_host=$i" >> /home/volumio/ansible.log

echo "[rpi]" > /home/volumio/ansible/hosts
echo "$i ansible_connection=ssh ansible_ssh_user=pi ansible_ssh_pass="$1 >> /home/volumio/ansible/hosts

cd /home/volumio/ansible-install
ansible-playbook setup.yml  >> /home/volumio/ansible.log

cd /home/volumio/ansible-volumio-media
ansible-playbook setup.yml >> /home/volumio/ansible.log
