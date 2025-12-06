Ansible Server
52.66.224.25

Machine 1
65.0.56.47

Machine 2
13.200.231.124

Ansible Server
ssh -i mykey ubuntu@52.66.224.25

Machine 1
ssh -i mykey ubuntu@65.0.56.47

Machine 2
ssh -i mykey ubuntu@13.200.231.124

cd ~/.ssh

# Install Ansible On Master
sudo apt update
sudo apt install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y

# Check Ansible Version
ansible --version

# Mention all server to host file
cd /
sudo nano etc/ansible/hosts

// on/for your current destination
ssh-keygen -t rsa -b 4096 -C "mykey" -f mykey 
==================


# Go to your vm on local code root folder and it copies all the key and paste on your ansible server
scp -i mykey -r ./* ubuntu@52.66.224.25:/home/ubuntu/.ssh

# Your Ansible Server Block Host
[dev]
server-1 ansible_host=65.0.56.47
server-2 ansible_host=13.200.231.124

[dev:vars]
ansible_user=ubuntu 
ansible_private_key_file=/home/ubuntu/.ssh/mykey

# run both after going inside ssh folder "cd ~/.ssh" cmd
ssh -i mykey ubuntu@65.0.56.47
ssh -i mykey ubuntu@13.200.231.124

ansible dev -m ping

 git add .
 git commit -m "added changes"
 git push origin main

# Add Duckerhub Credential in Jenkins
# Add Github Repo
# Add Jenkins Server Private Key In Credential to access the jenkins agent
# Add Github Webhook in Jenkins to jenkins server ip http://yourip:jenkinport/github-webhooks/
# Add Stage View Plugin
# Add Github Branch Source Plugin
