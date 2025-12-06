# Ansible Master--Slave Setup Guide

This guide explains how to configure an **Ansible Master Server** and
connect it with **two managed machines** using SSH keys. Follow each
step in order to set up a working automation environment.

## 📌 Server Details

  -------------------------------------------------------------------------------
  Role          IP Address                 SSH Command
  ------------- -------------------------- --------------------------------------
  **Ansible     `52.66.224.25`             `ssh -i mykey ubuntu@52.66.224.25`
  Server                                   
  (Master)**                               

  **Machine 1** `65.0.56.47`               `ssh -i mykey ubuntu@65.0.56.47`

  **Machine 2** `13.200.231.124`           `ssh -i mykey ubuntu@13.200.231.124`
  -------------------------------------------------------------------------------

## 📁 Step 1: Connect to Ansible Server

``` bash
ssh -i mykey ubuntu@52.66.224.25
cd ~/.ssh
```

## 📦 Step 2: Install Ansible on Master

``` bash
sudo apt update
sudo apt install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
```

### Check installation

``` bash
ansible --version
```

## 📄 Step 3: Update Hosts File

``` bash
cd /
sudo nano etc/ansible/hosts
```

Add this block:

``` ini
[dev]
server-1 ansible_host=65.0.56.47
server-2 ansible_host=13.200.231.124

[dev:vars]
ansible_user=ubuntu
ansible_private_key_file=/home/ubuntu/.ssh/mykey
```

## 🔐 Step 4: Generate SSH Key on Local Machine

``` bash
ssh-keygen -t rsa -b 4096 -C "mykey" -f mykey
```

## 📤 Step 5: Copy Keys to Ansible Server

``` bash
scp -i mykey -r ./* ubuntu@52.66.224.25:/home/ubuntu/.ssh
```

## 🔗 Step 6: Test SSH Access to Agents

``` bash
cd ~/.ssh
ssh -i mykey ubuntu@65.0.56.47
ssh -i mykey ubuntu@13.200.231.124
```

## 🚀 Step 7: Test Ansible Connectivity

``` bash
ansible dev -m ping
```

Expected output:

    server-1 | SUCCESS => pong
    server-2 | SUCCESS => pong

## ✅ Setup Complete

You now have a fully functional Ansible automation environment ready to
run playbooks.
