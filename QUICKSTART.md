# ⚡ Quick Start - CI/CD Deployment

## ✅ Những gì đã được chuẩn bị sẵn:

1. ✅ **Dockerfile** - Đã tối ưu hóa cho production
2. ✅ **GitHub Actions Workflow** (`.github/workflows/deploy.yml`) - Sẵn sàng deploy
3. ✅ **Application Config** (`application.yaml`) - Đã cấu hình environment variables

## 🚀 3 Bước Để Deploy:

### Bước 1: Tạo Azure VM & Cài Docker
```bash
# SSH vào VM rồi chạy:
sudo apt update && sudo apt install docker.io -y
sudo usermod -aG docker $USER
exit  # Thoát và SSH lại
```

### Bước 2: Thêm GitHub Secrets
Vào GitHub repo → Settings → Secrets and variables → Actions

Thêm **6 secrets** này (xem file `GITHUB_SECRETS.md` để biết chi tiết):
- `DOCKER_USERNAME` - Tên Docker Hub của bạn
- `DOCKER_PASSWORD` - Access Token từ Docker Hub
- `AZURE_VM_IP` - IP public của VM
- `AZURE_VM_USER` - Thường là `azureuser`
- `AZURE_SSH_KEY` - Nội dung file `.pem` (toàn bộ)
- `DB_PASSWORD` - Mật khẩu MySQL (tự đặt)

### Bước 3: Push Code
```bash
git add .
git commit -m "Setup CI/CD deployment"
git push origin main
```

## 📋 Sau khi push:

1. Vào tab **Actions** trên GitHub để xem tiến trình
2. Đợi workflow chạy xong (màu xanh ✅)
3. Truy cập: `http://<AZURE_VM_IP>:8080`

## 🔍 Kiểm tra nếu có lỗi:

```bash
# SSH vào VM và chạy:
docker ps                      # Xem containers đang chạy
docker logs shopping-app -f    # Xem log ứng dụng
docker logs mysql-db -f        # Xem log MySQL
```

## 📚 Tài liệu chi tiết:

- **DEPLOYMENT.md** - Hướng dẫn đầy đủ (Vietnamese)
- **GITHUB_SECRETS.md** - Checklist để setup secrets

---

**That's it! Happy deploying! 🎉**
