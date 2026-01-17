# GitHub Secrets Setup Checklist

## Required GitHub Secrets

Go to your GitHub repository → **Settings** → **Secrets and variables** → **Actions** → **New repository secret**

Add these 6 secrets:

### 1. DOCKER_USERNAME
```
Your Docker Hub username
Example: baokhang12356
```

### 2. DOCKER_PASSWORD
```
Your Docker Hub Access Token (NOT your password)
Get it from: Docker Hub → Account Settings → Security → New Access Token
Example: dckr_pat_ABC123XYZ...
```

### 3. AZURE_VM_IP
```
The public IP address of your Azure VM
Find it in: Azure Portal → Virtual Machine → Overview
Example: 20.123.45.67
```

### 4. AZURE_VM_USER
```
The SSH username for your Azure VM
Usually: azureuser
```

### 5. AZURE_SSH_KEY
```
The ENTIRE content of your .pem file (private key)
Open the .pem file with Notepad and copy everything including:
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA...
(many lines)
...
-----END RSA PRIVATE KEY-----
```

### 6. DB_PASSWORD
```
Your desired MySQL root password
Example: MySecurePassword123!
This will be used for the MySQL database in Docker
```

---

## Quick Verification

After adding all secrets, verify:
- [ ] All 6 secrets are created
- [ ] Secret names are EXACTLY as shown above (case-sensitive)
- [ ] DOCKER_PASSWORD is an Access Token, not your password
- [ ] AZURE_SSH_KEY includes the BEGIN and END lines
- [ ] AZURE_VM_IP is the public IP (not private IP)

---

## Next Steps

1. Make sure Docker is installed on your Azure VM:
```bash
# SSH into your VM and run:
sudo apt update && sudo apt install docker.io -y
sudo usermod -aG docker $USER
```

2. Push your code to the main branch:
```bash
git add .
git commit -m "Setup CI/CD"
git push origin main
```

3. Watch the deployment in GitHub Actions tab

4. Access your app at: http://YOUR_AZURE_VM_IP:8080
