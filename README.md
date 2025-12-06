# Ansible + Terraform Full Setup Guide

This guide explains how to configure an **Ansible Master Server**,
connect it with **two managed machines**, generate SSH keys, prepare a
VM folder structure, and use **Terraform** to provision AWS
infrastructure. Follow the steps carefully to build a fully automated
IaC workflow.

------------------------------------------------------------------------

## 📂 Step 0: Create VM Folder & Generate SSH Key

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

## 📁 Step 1: Connect to Ansible Server

``` bash
ssh -i mykey ubuntu@52.66.224.25
cd ~/.ssh
```

------------------------------------------------------------------------

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

------------------------------------------------------------------------

## 📄 Step 3: Update Hosts File

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

## 📤 Step 4: Copy SSH Keys to Ansible Server

Inside your local **vm** folder:

``` bash
scp -i mykey -r ./* ubuntu@52.66.224.25:/home/ubuntu/.ssh
```

------------------------------------------------------------------------

## 🔗 Step 5: Test SSH Access to Both Machines

On the Ansible server:

``` bash
cd ~/.ssh
ssh -i mykey ubuntu@65.0.56.47
ssh -i mykey ubuntu@13.200.231.124
```

If both connect without prompts, SSH is configured correctly.

------------------------------------------------------------------------

## 🌩 Step 6: Configure AWS CLI on Ansible Server

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

## 🏗 Step 7: Run Terraform to Provision Infrastructure

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

## 🚀 Step 8: Test Ansible Connectivity

``` bash
ansible dev -m ping
```

Expected output:

    server-1 | SUCCESS => pong
    server-2 | SUCCESS => pong

------------------------------------------------------------------------

## ✅ Setup Complete

You now have:

-   A VM root folder containing your SSH key\
-   Terraform‑provisioned AWS infrastructure\
-   Ansible master configured\
-   Passwordless SSH to all managed nodes\
-   A fully automated IaC pipeline

You can now deploy playbooks, configure servers, or extend
infrastructure using Terraform.
