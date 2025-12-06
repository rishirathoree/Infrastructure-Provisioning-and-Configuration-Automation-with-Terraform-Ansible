# Ansible + Terraform Full Setup Guide

This guide explains how to configure an **Ansible Master Server**,
connect it with **two managed machines**, generate SSH keys, prepare a
VM folder structure, and use **Terraform** to provision AWS
infrastructure. Follow the steps carefully to build a fully automated
IaC workflow.

## 📂 Create VM Folder & Generate SSH Key

On your **local machine**, create a VM workspace and generate your SSH
key:

``` bash
mkdir vm
cd vm
ssh-keygen -t rsa -b 4096 -C "mykey" -f mykey
```

This will create:

    vm/mykey        (private key)
    vm/mykey.pub    (public key)

------------------------------------------------------------------------


------------------------------------------------------------------------

## 🌩 Configure AWS CLI on Ansible Server

Terraform requires AWS CLI credentials with **AdministratorAccess**.

``` bash
aws configure
```

Provide:

-   AWS Access Key ID\
-   AWS Secret Access Key\
-   Default region (ex: ap-south-1)\
-   Output → json

Ensure IAM user/role has:

    AdministratorAccess

------------------------------------------------------------------------



## 🏗  Run Terraform to Provision Infrastructure

Go to your Terraform folder inside `dev`:

``` bash
cd dev/terraform-files
```

Initialize Terraform:

``` bash
terraform init
```

Provision with auto-approve:

``` bash
terraform apply -auto-approve
```

Terraform will create AWS resources such as EC2 instances, VPC,
networking, etc.

------------------------------------------------------------------------

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

------------------------------------------------------------------------

## 📁  Connect to Ansible Server

``` bash
ssh -i mykey ubuntu@52.66.224.25
cd ~/.ssh
```

------------------------------------------------------------------------

## 📦Install Ansible on Master

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

------------------------------------------------------------------------

## 📄 Update Hosts File

``` bash
cd /
sudo nano etc/ansible/hosts
```

Add the following block:

``` ini
[dev]
server-1 ansible_host=65.0.56.47
server-2 ansible_host=13.200.231.124

[dev:vars]
ansible_user=ubuntu
ansible_private_key_file=/home/ubuntu/.ssh/mykey
```

------------------------------------------------------------------------

## 📤 Copy SSH Keys to Ansible Server

Inside your local **vm** folder:

``` bash
scp -i mykey -r ./* ubuntu@52.66.224.25:/home/ubuntu/.ssh
```

------------------------------------------------------------------------

## 🔗 Test SSH Access to Both Machines

On the Ansible server:

``` bash
cd ~/.ssh
ssh -i mykey ubuntu@65.0.56.47
ssh -i mykey ubuntu@13.200.231.124
```

If both connect without prompts, SSH is configured correctly.

------------------------------------------------------------------------


## 🚀  Test Ansible Connectivity

``` bash
ansible dev -m ping
```

Expected output:

    server-1 | SUCCESS => pong
    server-2 | SUCCESS => pong

------------------------------------------------------------------------

## Check All Dev Machines free space


``` bash
ansible dev -a "df -h"
```

Expected output:

```

[WARNING]: Host 'server-2' is using the discovered Python interpreter at '/usr/bin/python3.12', but future installation of another Python interpreter could cause a different interpreter to be discovered. See https://docs.ansible.com/ansible-core/2.19/reference_appendices/interpreter_discovery.html for more information.
server-2 | CHANGED | rc=0 >>
               total        used        free      shared  buff/cache   available
Mem:           914Mi       355Mi       352Mi       2.7Mi       364Mi       558Mi
Swap:             0B          0B          0B


[WARNING]: Host 'server-1' is using the discovered Python interpreter at '/usr/bin/python3.12', but future installation of another Python interpreter could cause a different interpreter to be discovered. See https://docs.ansible.com/ansible-core/2.19/reference_appendices/interpreter_discovery.html for more information.
server-1 | CHANGED | rc=0 >>
               total        used        free      shared  buff/cache   available
Mem:           914Mi       373Mi       305Mi       2.7Mi       393Mi       540Mi
Swap:             0B          0B          0B

```

------------------------------------------------------------------------

## Create Ansible Playbook to Install Nginx on Host Mentioned Machines

Create the playbook file
```
mkdir -p /home/ubuntu/playbook
```

Add the playbook
```
touch nginx.yml
```

Edit the playbook
```
sudo nano nginx.yml
```

Add the following YAML content:
```
---
- name: Install Ngninx Server
  hosts: dev
  become: true
  tasks:
    - name: Install Ngninx Server
      apt:
        name: nginx
        state: present
    - name: Start Nginx Server
      service:
        name: nginx
        state: started
```

Running the Playbook
```
ansible-playbook nginx.yml
```

Destroy all the aws configurations after using:

Go to Terraform-files -> environment -> dev

```
terraform destroy --auto-approve
```


## ✅ Setup Complete
You can now deploy playbooks, configure servers, or extend
infrastructure using Terraform.
