#!/bin/bash

sudo rm -rf ~/ansible* 2>/dev/null
sudo rm -rf ~/foreman* 2>/dev/null

date >> ~/ansible.log
sudo apt-get update 
sudo apt-get autoremove

sudo apt-get install git -y 

# Install Ansible and Git on the machine.
sudo apt-get install python-pip git python-dev sshpass -y
sudo pip install ansible 
sudo pip install markupsafe 

git clone https://github.com/adfinis-sygroup/foreman-ansible.git

i=$(sudo ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'| head -n1)
h=$(hostname)

echo "$i ansible_connection=ssh ansible_ssh_user=root ansible_ssh_pass=1234" > ~/foreman-ansible/ansible
cd ~/foreman-ansible/ansible

ansible-playbook foreman.yml -i /tmp/inventory -u root
