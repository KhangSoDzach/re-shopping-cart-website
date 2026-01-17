# 🚀 Hướng Dẫn Triển Khai (Deployment Guide)

## 📋 Tổng Quan

File này hướng dẫn bạn cách thiết lập CI/CD tự động để triển khai ứng dụng Shopping Cart lên Azure VM sử dụng GitHub Actions và Docker.

## 🔧 Yêu Cầu Chuẩn Bị

### 1. Tài Khoản Docker Hub
- Tạo tài khoản tại [Docker Hub](https://hub.docker.com/)
- Tạo Access Token:
  1. Đăng nhập Docker Hub
  2. Vào **Account Settings** → **Security** → **New Access Token**
  3. Đặt tên token (ví dụ: `shopping-cart-deploy`)
  4. Copy token và lưu lại (chỉ hiển thị 1 lần)

### 2. Azure Virtual Machine
- Tạo Ubuntu VM trên Azure Portal (khuyến nghị gói **B1s** hoặc **B2s**)
- Cấu hình:
  - **Hệ điều hành**: Ubuntu 22.04 LTS
  - **Networking**: Mở port 8080 (Web) và 3306 (MySQL)
  - **SSH**: Tải xuống file `.pem` khi tạo VM

### 3. Cài Đặt Docker Trên Azure VM

Sau khi tạo VM, SSH vào máy và chạy các lệnh sau:

```bash
# Cập nhật hệ thống
sudo apt update && sudo apt upgrade -y

# Cài đặt Docker
sudo apt install docker.io -y

# Thêm user vào group docker (để chạy docker không cần sudo)
sudo usermod -aG docker $USER

# Thoát và SSH lại để cập nhật quyền
exit
```

**Tăng RAM ảo (SWAP) cho VM có ít RAM:**
```bash
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

---

## 🔐 Cấu Hình GitHub Secrets

Vào repository GitHub của bạn:
1. Nhấp vào **Settings**
2. Chọn **Secrets and variables** → **Actions**
3. Nhấp **New repository secret**

Thêm các secrets sau:

| Secret Name | Mô Tả | Ví Dụ |
|-------------|-------|-------|
| `DOCKER_USERNAME` | Tên tài khoản Docker Hub | `baokhang12356` |
| `DOCKER_PASSWORD` | Access Token từ Docker Hub | `dckr_pat_xxxxx...` |
| `AZURE_VM_IP` | Địa chỉ IP Public của Azure VM | `20.123.45.67` |
| `AZURE_VM_USER` | Username SSH vào VM | `azureuser` |
| `AZURE_SSH_KEY` | Nội dung file `.pem` (private key) | Mở file `.pem` bằng Notepad, copy toàn bộ |
| `DB_PASSWORD` | Mật khẩu MySQL (tự đặt) | `MySecurePassword123!` |

### Cách Lấy SSH Private Key:

1. Tìm file `.pem` đã tải khi tạo VM
2. Mở bằng Notepad
3. Copy **toàn bộ** nội dung, bao gồm:
```
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA...
(nhiều dòng base64)
...
-----END RSA PRIVATE KEY-----
```
4. Paste vào GitHub Secret `AZURE_SSH_KEY`

---

## 🎯 Cách Sử Dụng

### Triển Khai Tự Động

Sau khi đã cấu hình xong tất cả Secrets:

1. **Commit và Push code lên branch `main`:**
```bash
git add .
git commit -m "Setup CI/CD deployment"
git push origin main
```

2. **Kiểm tra workflow:**
- Vào tab **Actions** trên GitHub repository
- Bạn sẽ thấy workflow "Deploy Shopping Cart to Azure" đang chạy
- Chờ đến khi tất cả các bước chuyển sang màu xanh ✅

3. **Truy cập ứng dụng:**
```
http://<AZURE_VM_IP>:8080
```

### Triển Khai Thủ Công (Manual Trigger)

Bạn cũng có thể chạy workflow bất kỳ lúc nào:
1. Vào tab **Actions**
2. Chọn workflow **Deploy Shopping Cart to Azure**
3. Nhấp **Run workflow** → **Run workflow**

---

## 🔍 Kiểm Tra & Debug

### Xem Log Ứng Dụng Trên Azure

SSH vào VM và chạy:

```bash
# Xem log ứng dụng Spring Boot
docker logs shopping-app -f

# Xem log MySQL
docker logs mysql-db -f

# Kiểm tra container đang chạy
docker ps

# Kiểm tra trạng thái network
docker network inspect app-network
```

### Các Lỗi Thường Gặp

#### 1. **Lỗi "Permission denied" khi chạy Docker**
```bash
# Đảm bảo user có quyền chạy Docker
sudo usermod -aG docker $USER
# Thoát và SSH lại
```

#### 2. **Ứng dụng không khởi động (Out of Memory)**
```bash
# Kiểm tra log
docker logs shopping-app

# Thêm SWAP RAM (xem phần trên)
```

#### 3. **Không kết nối được database**
```bash
# Kiểm tra MySQL container đang chạy
docker ps | grep mysql-db

# Restart MySQL nếu cần
docker restart mysql-db

# Kiểm tra network
docker network inspect app-network
```

#### 4. **Port 8080 không truy cập được**
- Kiểm tra Azure Portal → VM → **Networking** → **Inbound port rules**
- Đảm bảo port 8080 đã được mở cho Source: **Any** hoặc **Internet**

---

## 📊 Kiến Trúc Triển Khai

```
┌─────────────────────────────────────────────────────────┐
│                     GitHub Repository                    │
│  (Push code to main branch)                            │
└──────────────────┬──────────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────────┐
│                   GitHub Actions                        │
│  ┌─────────────────────────────────────────────────┐   │
│  │ 1. Build Docker Image                           │   │
│  │ 2. Push to Docker Hub                           │   │
│  └─────────────────────────────────────────────────┘   │
└──────────────────┬──────────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────────┐
│                    Docker Hub                           │
│  (Store: username/shopping-cart:latest)                 │
└──────────────────┬──────────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────────┐
│                    Azure VM (Ubuntu)                     │
│  ┌───────────────────────────────────────────────────┐  │
│  │              Docker Network (app-network)         │  │
│  │                                                   │  │
│  │  ┌─────────────┐         ┌──────────────────┐   │  │
│  │  │   MySQL     │ ◄─────► │  Shopping App    │   │  │
│  │  │  Container  │         │   (Port 8080)    │   │  │
│  │  │ mysql-db    │         │  shopping-app    │   │  │
│  │  └─────────────┘         └──────────────────┘   │  │
│  │                                                   │  │
│  └───────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
                   │
                   ▼
            👤 End Users
      (Access: http://VM_IP:8080)
```

---

## 🛡️ Bảo Mật

**⚠️ LƯU Ý QUAN TRỌNG:**

1. **KHÔNG BAO GIỜ** commit file `.env`, `.pem`, hoặc bất kỳ credentials nào lên GitHub
2. Luôn sử dụng **GitHub Secrets** cho thông tin nhạy cảm
3. Sử dụng **Access Token** thay vì password Docker Hub
4. Đổi mật khẩu MySQL mặc định trong production
5. Cấu hình **Firewall** trên Azure để chỉ cho phép IP cần thiết

---

## 📝 Ghi Chú

- Mỗi lần push code lên `main`, workflow sẽ tự động build và deploy
- Database MySQL sẽ **tự động tạo** nếu chưa tồn tại
- Dữ liệu MySQL được lưu trong container, nếu xóa container thì mất data
- Để giữ data lâu dài, cần mount Docker volume (liên hệ nếu cần hướng dẫn)

---

## 🆘 Hỗ Trợ

Nếu gặp vấn đề:
1. Kiểm tra log của GitHub Actions (tab Actions)
2. SSH vào VM và kiểm tra `docker logs shopping-app`
3. Kiểm tra cấu hình GitHub Secrets
4. Đảm bảo ports đã được mở trên Azure

---

## ✅ Checklist Triển Khai

- [ ] Đã tạo tài khoản Docker Hub và Access Token
- [ ] Đã tạo Azure VM Ubuntu 22.04
- [ ] Đã cài Docker trên Azure VM
- [ ] Đã mở port 8080 và 3306 trên Azure
- [ ] Đã thêm đầy đủ 6 GitHub Secrets
- [ ] Đã test SSH vào VM thành công
- [ ] Đã push code lên branch main
- [ ] Workflow chạy thành công (màu xanh ✅)
- [ ] Truy cập http://VM_IP:8080 thành công

---

**Chúc bạn triển khai thành công! 🎉**
