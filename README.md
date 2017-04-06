# Install Ansible and Git on the machine.
sudo apt-get update
sudo apt-get install python-pip git python-dev sshpass
sudo pip install ansible

# ansible
wget https://raw.githubusercontent.com/Revenberg/ansible/master/install.sh && chmod +x install.sh
