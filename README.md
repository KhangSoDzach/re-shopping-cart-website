# 🛒 Shopping Cart Website

Spring Boot-based e-commerce shopping cart application with MySQL database.

## 📚 Documentation

- **[QUICKSTART.md](QUICKSTART.md)** - 3 bước nhanh để deploy lên Azure
- **[DEPLOYMENT.md](DEPLOYMENT.md)** - Hướng dẫn đầy đủ về CI/CD và Azure deployment
- **[GITHUB_SECRETS.md](GITHUB_SECRETS.md)** - Checklist setup GitHub Secrets
- **[LOCAL_TESTING.md](LOCAL_TESTING.md)** - Hướng dẫn test local trên máy

## 🚀 Quick Start - Test Local

### Option 1: Docker Compose (Khuyến Nghị)
```bash
docker-compose up --build
```
Truy cập: http://localhost:8080

### Option 2: Gradle với MySQL Local
```bash
# Cài MySQL hoặc chạy MySQL trong Docker:
docker run -d --name mysql-local -p 3306:3306 -e MYSQL_ALLOW_EMPTY_PASSWORD=yes mysql:8.0

# Chạy ứng dụng:
./gradlew bootRun
```
Truy cập: http://localhost:8080

## ⚙️ Tech Stack

- **Backend**: Spring Boot 3.x, Java 21
- **Database**: MySQL 8.0
- **Template Engine**: Thymeleaf
- **Build Tool**: Gradle 8.5
- **Containerization**: Docker
- **CI/CD**: GitHub Actions
- **Cloud**: Azure VM

## 📁 Project Structure

```
.
├── src/
│   ├── main/
│   │   ├── java/          # Java source code
│   │   └── resources/
│   │       ├── application.yaml  # App configuration
│   │       ├── templates/        # Thymeleaf templates
│   │       └── static/           # CSS, JS, images
│   └── test/              # Unit tests
├── .github/
│   └── workflows/
│       └── deploy.yml     # CI/CD pipeline
├── Dockerfile             # Docker image definition
├── docker-compose.yml     # Local development stack
├── .env.example           # Environment variables template
├── .env.local             # Local development config (gitignored)
└── .env.prod              # Production reference (gitignored)
```

## 🔧 Environment Variables

### Local Development (`.env.local`):
```properties
SPRING_DATASOURCE_URL=jdbc:mysql://localhost:3306/shopping_cart
SPRING_DATASOURCE_USERNAME=root
SPRING_DATASOURCE_PASSWORD=
SPRING_JPA_HIBERNATE_DDL_AUTO=update
```

### Production (Azure VM):
Environment variables are injected via Docker:
```bash
-e DB_HOST=mysql-db
-e DB_NAME=shopping_cart
-e DB_USER=root
-e DB_PASSWORD=${DB_PASSWORD}
```

## 🚢 Deployment

### Automatic Deployment (CI/CD)
1. Setup GitHub Secrets (see [GITHUB_SECRETS.md](GITHUB_SECRETS.md))
2. Push to `main` branch
3. GitHub Actions automatically builds and deploys to Azure

### Manual Deployment
See full guide in [DEPLOYMENT.md](DEPLOYMENT.md)

## 🧪 Testing

### Run Tests
```bash
./gradlew test
```

### Build JAR
```bash
./gradlew build
```

### Build Docker Image
```bash
docker build -t shopping-cart:latest .
```

## 📊 Database Schema

The application uses JPA/Hibernate with auto DDL. Schema is automatically generated based on entity classes.

Default configuration:
- **Development**: `ddl-auto: update` (auto-create/update tables)
- **Production**: `ddl-auto: update` (can change to `validate` after initial setup)

## 🔐 Security Notes

- **NEVER** commit `.env`, `.env.local`, `.env.prod`, or `.pem` files
- Use GitHub Secrets for sensitive data
- Use Docker Hub Access Tokens instead of passwords
- Configure Azure VM firewall properly

## 🛠️ Development

### Prerequisites
- Java 21+
- Gradle 8.5+
- MySQL 8.0+ (or Docker)
- Docker (optional, for containerized development)

### Setup
1. Clone the repository
2. Copy `.env.example` to `.env.local`
3. Update database credentials in `.env.local`
4. Run MySQL (or use Docker)
5. Run the application: `./gradlew bootRun`

### Hot Reload
Add Spring DevTools to `build.gradle`:
```gradle
developmentOnly 'org.springframework.boot:spring-boot-devtools'
```

## 📝 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | Home page |
| GET | `/products` | Product listing |
| GET | `/cart` | Shopping cart |
| POST | `/cart/add` | Add to cart |
| POST | `/cart/remove` | Remove from cart |
| GET | `/checkout` | Checkout page |

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📄 License

This project is for educational purposes.

---

## 🆘 Troubleshooting

### Common Issues

**Port 8080 already in use:**
```bash
# Windows
netstat -ano | findstr :8080
taskkill /PID <PID> /F

# Linux/Mac
lsof -i :8080
kill -9 <PID>
```

**Database connection failed:**
- Check if MySQL is running
- Verify credentials in `.env.local`
- Check port 3306 is not blocked

**Docker build fails:**
- Clear Docker cache: `docker system prune -a`
- Rebuild: `docker-compose up --build --force-recreate`

For more help, see [LOCAL_TESTING.md](LOCAL_TESTING.md)

---

**Made with ❤️ using Spring Boot**
