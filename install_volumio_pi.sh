#!/bin/bash
sudo rm -rf /home/pi/ansible*
date >> /home/pi/ansible.log

i=$(sudo ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'| head -n1)
h=$(hostname)

sudo apt-get update
sudo apt-get autoremove
sudo apt-get -f install 
sudo apt-get install git aptitude apt-utils -y

# Install Ansible and Git on the machine.
sudo apt-get install python-pip git python-dev sshpass -y
sudo pip install ansible
sudo pip install markupsafe

git clone https://github.com/Revenberg/ansible.git
git clone https://github.com/Revenberg/ansible-install.git
git clone https://github.com/Revenberg/ansible-volumio-media.git
echo "$h ansible_host=$i" >> /home/pi/ansible.log

echo "[rpi]" > /home/pi/ansible/hosts
echo "$i ansible_connection=ssh ansible_ssh_user=pi ansible_ssh_pass=raspberry" >> /home/pi/ansible/hosts

cd /home/pi/ansible-install
ansible-playbook setup.yml  >> /home/pi/ansible.log

cd /home/pi/ansible-volumio-media
ansible-playbook setup.yml >> /home/pi/ansible.log
