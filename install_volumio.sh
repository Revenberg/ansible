#!/bin/bash

sudo rm -rf /home/volumio/ansible*
date >> /home/volumio/ansible.log

sudo chmod u+s `which ping`

wget https://github.com/Revenberg/ansible-volumio/blob/master/sudoers
sudo chown root:root ./sudoers

sudo mv ./sudoers /etc/sudoers

sudo /bin/rm -v /etc/ssh/ssh_host_* -f
sudo dpkg-reconfigure openssh-server
sudo /etc/init.d/ssh restart

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

# Configure IP address in "hosts" file. If you have more than one
# Raspberry Pi, add more lines and enter details
#i=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | head -n1 | tail -n1)
#h=$(hostname)
#echo $i
#echo $h

echo "127.0.0.1 ansible_host=volumio" >> /home/volumio/ansible.log

echo "[rpi]" > /home/volumio/ansible/hosts
echo "volumio ansible_connection=ssh ansible_ssh_user=volumio ansible_ssh_pass=volumio" >> /home/volumio/ansible/hosts

cd /home/volumio/ansible-install
ansible-playbook setup.yml  >> /home/volumio/ansible.log

cd /home/volumio/ansible-volumio-media
ansible-playbook setup.yml >> /home/volumio/ansible.log
