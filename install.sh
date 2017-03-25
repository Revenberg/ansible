sudo apt-get update

sudo apt-get install git -y

# Install Ansible and Git on the machine.
sudo apt-get install python-pip git python-dev sshpass -y
sudo pip install ansible

# Configure IP address in "hosts" file. If you have more than one
# Raspberry Pi, add more lines and enter details
i=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')
h=$(hostname)

echo "$h ansible_host=$i" > hosts

echo "[rpi]" > ~/ansible/hosts
echo "$i  ansible_connection=ssh ansible_ssh_user=pi ansible_ssh_pass=xxxxxxxx" >> ~/ansible/hosts

cd ~/ansible
ansible-playbook setup.yml

cd ~/ansible-install
ansible-playbook setup.yml

cd ~/ansible-media
ansible-playbook setup.yml
