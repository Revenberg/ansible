#!/bin/bash
if [ $# -ne 1 ]; then
    echo $0: usage: ./install.sh  password
    return 0
fi

sudo rm -rf /home/pi/ansible*

date >> /home/pi/ansible.log
sudo apt-get update >> /home/pi/ansible.log
sudo apt-get autoremove >> /home/pi/ansible.log

sudo apt-get install git -y >> /home/pi/ansible.log

# Install Ansible and Git on the machine.
sudo apt-get install python-pip git python-dev sshpass -y >> /home/pi/ansible.log
sudo pip install ansible >> /home/pi/ansible.log
sudo pip install markupsafe >> /home/pi/ansible.log

git clone https://github.com/Revenberg/ansible-install.git >> /home/pi/ansible.log
git clone https://github.com/Revenberg/ansible-screen.git >> /home/pi/ansible.log
git clone https://github.com/Revenberg/ansible-wifi.git >> /home/pi/ansible.log
git clone https://github.com/Revenberg/ansible-media.git >> /home/pi/ansible.log
git clone https://github.com/Revenberg/ansible-kiosk.git >> /home/pi/ansible.log
git clone https://github.com/Revenberg/ansible-bluetooth.git >> /home/pi/ansible.log

# Configure IP address in "hosts" file. If you have more than one
# Raspberry Pi, add more lines and enter details
i=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')
h=$(hostname)

echo "$h ansible_host=$i" >> /home/pi/ansible.log

echo "[rpi]" > ~/ansible/hosts

cd ~/ansible-install
ansible-playbook setup.yml >> /home/pi/ansible.log
 
cd ~/ansible-screen
ansible-playbook setup.yml >> /home/pi/ansible.log

cd ~/ansible-wifi
ansible-playbook setup.yml >> /home/pi/ansible.log

cd ~/ansible-media
ansible-playbook setup.yml >> /home/pi/ansible.log

cd ~/ansible-kiosk
ansible-playbook setup.yml >> /home/pi/ansible.log

cd ~/ansible-bluetooth
ansible-playbook setup.yml >> /home/pi/ansible.log

sudo reboot
