#!/bin/bash
if [ $# -ne 1 ]; then
    echo $0: usage: ./install.sh  password
    return 0
fi

sudo apt-get update
sudo apt-get autoremove

sudo apt-get install git -y

# Install Ansible and Git on the machine.
sudo apt-get install python-pip git python-dev sshpass -y
sudo pip install ansible
sudo pip install markupsafe

sudo rm -rf /home/pi/ansible*
git clone https://github.com/Revenberg/ansible-install.git
git clone https://github.com/Revenberg/ansible-screen.git
git clone https://github.com/Revenberg/ansible-wifi.git
git clone https://github.com/Revenberg/ansible-media.git
git clone https://github.com/Revenberg/ansible-kiosk.git
git clone https://github.com/Revenberg/ansible-bluetooth.git

# Configure IP address in "hosts" file. If you have more than one
# Raspberry Pi, add more lines and enter details
i=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')
h=$(hostname)

echo "$h ansible_host=$i" > /home/pi/ansible.log

echo "[rpi]" > ~/ansible/hosts
echo "$i  ansible_connection=ssh ansible_ssh_user=pi ansible_ssh_pass="$1 >> ~/ansible/hosts

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
