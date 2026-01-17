# 🧪 Hướng Dẫn Test Local

## Cách 1: Sử dụng MySQL Local

### Bước 1: Cài MySQL
Nếu chưa có MySQL, tải tại: https://dev.mysql.com/downloads/installer/

Hoặc dùng Docker (khuyến nghị):
```bash
docker run -d --name mysql-local \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD= \
  -e MYSQL_ALLOW_EMPTY_PASSWORD=yes \
  mysql:8.0
```

### Bước 2: Tạo Database (optional)
MySQL sẽ tự động tạo database nếu chưa tồn tại, nhưng bạn cũng có thể tạo thủ công:
```sql
CREATE DATABASE shopping_cart;
```

### Bước 3: Chạy Ứng Dụng
File `.env.local` đã được cấu hình sẵn để kết nối với MySQL local.

**Windows (PowerShell):**
```powershell
./gradlew bootRun
```

**Linux/Mac:**
```bash
./gradlew bootRun
```

### Bước 4: Truy Cập
Mở trình duyệt: http://localhost:8080

---

## Cách 2: Sử dụng Docker Compose (Toàn Bộ Stack)

### Tạo file `docker-compose.yml`:
```yaml
version: '3.8'

services:
  mysql:
    image: mysql:8.0
    container_name: shopping-cart-mysql
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: shopping_cart
    ports:
      - "3306:3306"
    volumes:
      - mysql-data:/var/lib/mysql

  app:
    build: .
    container_name: shopping-cart-app
    depends_on:
      - mysql
    environment:
      SPRING_DATASOURCE_URL: jdbc:mysql://mysql:3306/shopping_cart
      SPRING_DATASOURCE_USERNAME: root
      SPRING_DATASOURCE_PASSWORD: root
      SPRING_JPA_HIBERNATE_DDL_AUTO: update
    ports:
      - "8080:8080"

volumes:
  mysql-data:
```

### Chạy:
```bash
docker-compose up --build
```

### Truy cập:
http://localhost:8080

### Dừng:
```bash
docker-compose down
```

---

## Cách 3: Chỉ Build Docker Image Để Test

### Build Image:
```bash
docker build -t shopping-cart:test .
```

### Chạy MySQL Container:
```bash
docker network create test-network
docker run -d --name test-mysql \
  --network test-network \
  -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_DATABASE=shopping_cart \
  -p 3306:3306 \
  mysql:8.0
```

### Chạy Application Container:
```bash
docker run -d --name test-app \
  --network test-network \
  -p 8080:8080 \
  -e SPRING_DATASOURCE_URL=jdbc:mysql://test-mysql:3306/shopping_cart \
  -e SPRING_DATASOURCE_USERNAME=root \
  -e SPRING_DATASOURCE_PASSWORD=root \
  -e SPRING_JPA_HIBERNATE_DDL_AUTO=update \
  shopping-cart:test
```

### Xem logs:
```bash
docker logs test-app -f
```

### Dọn dẹp:
```bash
docker stop test-app test-mysql
docker rm test-app test-mysql
docker network rm test-network
```

---

## 🔍 Kiểm Tra Kết Nối Database

### Kiểm tra MySQL đang chạy:
```bash
# Nếu dùng Docker:
docker ps | grep mysql

# Nếu dùng MySQL local:
mysql -u root -p
```

### Test kết nối từ ứng dụng:
Khi chạy ứng dụng, xem log:
```
Hikari - Starting...
Hikari - Start completed.
```

Nếu thấy lỗi connection, kiểm tra:
1. MySQL có đang chạy không?
2. Username/password đúng chưa?
3. Port 3306 có bị chiếm không?

---

## 📊 Test API Endpoints

### 1. Trang chủ:
```
GET http://localhost:8080
```

### 2. Danh sách sản phẩm:
```
GET http://localhost:8080/products
```

### 3. Giỏ hàng:
```
GET http://localhost:8080/cart
```

---

## 🛠️ Troubleshooting

### Lỗi: "Port 8080 already in use"
```bash
# Windows:
netstat -ano | findstr :8080
taskkill /PID <PID> /F

# Linux/Mac:
lsof -i :8080
kill -9 <PID>
```

### Lỗi: "Access denied for user 'root'"
Kiểm tra password trong `.env.local`:
```properties
SPRING_DATASOURCE_PASSWORD=
# Hoặc nếu bạn set password cho MySQL:
SPRING_DATASOURCE_PASSWORD=your_password
```

### Lỗi: "Communications link failure"
MySQL chưa khởi động hoặc port sai. Kiểm tra:
```bash
docker ps
# Hoặc
netstat -an | findstr 3306
```

---

## 📝 Development Tips

### Hot Reload (Spring DevTools)
Thêm vào `build.gradle`:
```gradle
dependencies {
    developmentOnly 'org.springframework.boot:spring-boot-devtools'
}
```

### Xem SQL Queries
Trong `.env.local`, set:
```properties
SPRING_JPA_SHOW_SQL=true
```

### Import Sample Data
Tạo file `src/main/resources/data.sql`:
```sql
INSERT INTO products (name, price, description) VALUES
('Product 1', 100000, 'Description 1'),
('Product 2', 200000, 'Description 2');
```

---

**Happy Testing! 🚀**
