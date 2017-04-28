#!/bin/bash

if [ $# -ne 1 ]; then
    echo $0: usage: ./install.sh  password
    return 0
fi

sudo rm -rf /home/volumio/ansible*
date >> /home/volumio/ansible.log

i=$(sudo grep "pi ALL=NOPASSWD: ALL" /etc/sudoers | wc -l)
if (( "$i" == "0" )); then
        sudo adduser pi volumio
        sudo sh -c "echo 'pi:'$1  | chpasswd pi"

        sudo sh -c "echo 'pi ALL=NOPASSWD: ALL' >> /etc/sudoers"
fi

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

echo "127.0.0.1 ansible_host=volumio" >> /home/volumio/ansible.log

echo "[rpi]" > /home/volumio/ansible/hosts
echo "volumio ansible_connection=ssh ansible_ssh_user=pi ansible_ssh_pass="$1 >> /home/volumio/ansible/hosts

cd /home/volumio/ansible-install
ansible-playbook setup.yml  >> /home/volumio/ansible.log

cd /home/volumio/ansible-volumio-media
ansible-playbook setup.yml >> /home/volumio/ansible.log
