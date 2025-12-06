# Jenkins CI/CD Pipeline Setup (Terraform → Jenkins → GitHub Webhook)

This guide explains the full setup of Jenkins from scratch: provisioning EC2 instances using Terraform, configuring Jenkins and its agent, setting up SSH, and enabling GitHub webhooks for CI/CD pipeline automation.

---

## 📁 Project Structure

```
terraform-files/
   └── environment/
         └── dev/
                main.tf
                variables.tf
                outputs.tf
scripts/
   └── agent-setup.sh
   └── jenkins-setup.sh
Jenkinsfile
README.md
```

---

# 1. 🚀 Provision Infrastructure Using Terraform

Go to your Terraform DEV environment:

```sh
cd terraform-files/environment/dev
```

Initialize Terraform (only needed once):

```sh
terraform init
```

Apply configuration:

```sh
terraform apply --auto-approve
```

### ✔ Terraform Creates

- **1 Jenkins EC2**
- **1 Jenkins Agent EC2**

---

# 2. 🔐 Configure SSH Between Jenkins → Agent

SSH into the Jenkins EC2:

```sh
ssh -i <your-key.pem> ubuntu@<jenkins-public-ip>
```

Generate SSH key:

```sh
ssh-keygen -t rsa -b 4096 -C "jenkins-key" -f ~/.ssh/jenkins
```

This creates:

- `~/.ssh/jenkins` (private key)
- `~/.ssh/jenkins.pub` (public key)

### Add Public Key to Agent

SSH into the **agent EC2**:

```sh
ssh -i <your-key.pem> ubuntu@<agent-public-ip>
```

Open `authorized_keys`:

```sh
vim ~/.ssh/authorized_keys
```

Paste the **Jenkins public key** here.

> **Important:** If this step is wrong, Jenkins will NOT connect to the agent.

---

# 3. ⚙️ Run Project Setup Scripts

### On Agent EC2:

```sh
bash scripts/agent-setup.sh
```

### On Jenkins EC2:

```sh
bash scripts/jenkins-setup.sh
```

---

# 4. 🧩 Access Jenkins UI

Open Jenkins in browser:

```
http://<jenkins-public-ip>:8080
```

Retrieve initial password:

```sh
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Finish Jenkins setup (recommended plugins).

---

# 5. 🤝 Add Jenkins Agent

Navigate to:

```
Manage Jenkins → Manage Nodes → New Node
```

Fill in:

| Field | Value |
|-------|-------|
| **Name** | jenkins-dev-agent |
| **Executors** | 1 |
| **Remote Root Directory** | /home/ubuntu |
| **Labels** | jenkins-dev-agent |
| **Launch Method** | Launch via SSH |
| **Host** | <agent-ip> |
| **Credentials** | Add SSH key (private key created earlier) |
| **Host Verification Strategy** | Non-verifying |

Save.

> Ensure Jenkins public key exists in agent's `authorized_keys`.

---

# 6. 🔗 Configure GitHub Webhook

Go to your GitHub repo:

```
Settings → Webhooks → Add Webhook
```

Enter:

```
http://<jenkins-public-ip>:8080/jenkins-webhook/
```

Set:

- **Content type:** application/json  
- **Trigger:** Just the push event  

Save webhook.

---

# 7. 🧪 Run Jenkins Pipeline

Make sure Jenkinsfile includes:

```groovy
agent { label 'jenkins-dev-agent' }
```

Push any Git commit → webhook triggers Jenkins → pipeline runs.

---

# 🎉 Setup Complete  
You now have a fully automated CI/CD pipeline: Terraform infra → Jenkins master/agent → GitHub webhook → Jenkinsfile builds.

