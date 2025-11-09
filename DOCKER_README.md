# Microservices Architecture - Docker Setup

Hệ thống microservices gồm API Gateway và 3 services: Account, Brand, BlindBox với PostgreSQL database (Supabase).

## Cấu trúc dự án

```
PE_PEA_TEST/
├── APIGateway_QE180006/     # API Gateway (Port 8080)
├── MSAccount_QE180006/       # Account Service (Port 8081)
├── MSBrand_QE180006/         # Brand Service (Port 8082)
├── MSBlindBox_QE180006/      # BlindBox Service (Port 8083)
└── docker-compose.yml        # Orchestration file
```

## Database
Hệ thống sử dụng **PostgreSQL** được host trên **Supabase** (cloud). Không cần chạy database container.

- **Host**: db.cdttwujwmdeeznblpzoi.supabase.co
- **Port**: 5432
- **Database**: postgres
- **User**: postgres
- **Password**: bach@129052004

Mỗi service sử dụng schema riêng trong cùng một database:
- **msaccount** - Account Service tables
- **msbrand** - Brand Service tables  
- **msblindbox** - BlindBox Service tables

## Yêu cầu

- Docker Desktop (Windows)
- Docker Compose
- RAM tối thiểu: 2GB (không cần SQL Server container nữa)
- Disk space: ~2GB
- Internet connection (để kết nối Supabase)

## Build và chạy toàn bộ hệ thống

### 1. Build và chạy tất cả services cùng lúc

```powershell
# Ở thư mục gốc PE_PEA_TEST
docker-compose up --build
```

Lệnh này sẽ:
- Build tất cả Docker images
- Chạy tất cả microservices
- Kết nối đến PostgreSQL trên Supabase
- Tự động tạo schemas và tables (hibernate auto-create)

### 2. Chạy ở background (detached mode)

```powershell
docker-compose up -d --build
```

### 3. Xem logs

```powershell
# Xem tất cả logs
docker-compose logs -f

# Xem log của service cụ thể
docker-compose logs -f apigateway
docker-compose logs -f msaccount
docker-compose logs -f msbrand
docker-compose logs -f msblindbox
docker-compose logs -f sqlserver
```

### 4. Dừng và xóa containers

```powershell
# Dừng containers
docker-compose stop

# Dừng và xóa containers (giữ volumes/data)
docker-compose down

# Dừng và xóa containers (Database trên cloud nên data vẫn giữ nguyên)
docker-compose down -v
```

## Build từng service riêng lẻ

### API Gateway

```powershell
cd APIGateway_QE180006
docker build -t apigateway:latest .
docker run -d --name apigateway -p 8080:8080 apigateway:latest
```

### MS Account

```powershell
cd MSAccount_QE180006
docker build -t msaccount:latest .
docker run -d --name msaccount -p 8081:8081 `
  -e SPRING_DATASOURCE_URL="jdbc:postgresql://db.cdttwujwmdeeznblpzoi.supabase.co:5432/postgres" `
  -e SPRING_DATASOURCE_USERNAME=postgres `
  -e SPRING_DATASOURCE_PASSWORD=bach@129052004 `
  -e SPRING_JPA_PROPERTIES_HIBERNATE_DEFAULT_SCHEMA=msaccount `
  msaccount:latest
```

### MS Brand

```powershell
cd MSBrand_QE180006
docker build -t msbrand:latest .
docker run -d --name msbrand -p 8082:8082 `
  -e SPRING_DATASOURCE_URL="jdbc:postgresql://db.cdttwujwmdeeznblpzoi.supabase.co:5432/postgres" `
  -e SPRING_DATASOURCE_USERNAME=postgres `
  -e SPRING_DATASOURCE_PASSWORD=bach@129052004 `
  -e SPRING_JPA_PROPERTIES_HIBERNATE_DEFAULT_SCHEMA=msbrand `
  msbrand:latest
```

### MS BlindBox

```powershell
cd MSBlindBox_QE180006
docker build -t msblindbox:latest .
docker run -d --name msblindbox -p 8083:8083 `
  -e SPRING_DATASOURCE_URL="jdbc:postgresql://db.cdttwujwmdeeznblpzoi.supabase.co:5432/postgres" `
  -e SPRING_DATASOURCE_USERNAME=postgres `
  -e SPRING_DATASOURCE_PASSWORD=bach@129052004 `
  -e SPRING_JPA_PROPERTIES_HIBERNATE_DEFAULT_SCHEMA=msblindbox `
  msblindbox:latest
```

## Kiểm tra hệ thống

### 1. Kiểm tra containers đang chạy

```powershell
docker ps
```

### 2. Kiểm tra health của services

```powershell
# API Gateway
Invoke-WebRequest http://localhost:8080 -UseBasicParsing

# Account Service (qua Gateway)
Invoke-WebRequest http://localhost:8080/api/account/... -UseBasicParsing

# Brand Service (qua Gateway)
Invoke-WebRequest http://localhost:8080/api/brand/... -UseBasicParsing

# BlindBox Service (qua Gateway)
Invoke-WebRequest http://localhost:8080/api/blindbox/... -UseBasicParsing
```

### 3. Kết nối SQL Server

```powershell
# Từ host machine
Server: localhost,1433
Username: sa
Password: YourStrong@Passw0rd
```

Tools: Azure Data Studio, SQL Server Management Studio, hoặc DBeaver

## Cấu hình môi trường

### Ports được sử dụng

- **8080**: API Gateway
- **8081**: MS Account Service
- **8082**: MS Brand Service
- **8083**: MS BlindBox Service

Database: PostgreSQL trên Supabase (cloud) - không dùng local port

### Environment Variables (có thể override)

Trong `docker-compose.yml`, bạn có thể thay đổi:

```yaml
environment:
  - SPRING_DATASOURCE_URL=jdbc:postgresql://db.cdttwujwmdeeznblpzoi.supabase.co:5432/postgres
  - SPRING_DATASOURCE_USERNAME=postgres
  - SPRING_DATASOURCE_PASSWORD=bach@129052004
  - SPRING_JPA_PROPERTIES_HIBERNATE_DEFAULT_SCHEMA=msaccount  # hoặc msbrand, msblindbox
  - JWT_SECRET=your-secret-key
  - JWT_EXPIRATION=86400000
```

## Troubleshooting

### Container không start

```powershell
# Xem logs lỗi
docker-compose logs <service-name>

# Restart service
docker-compose restart <service-name>
```

### Port bị chiếm

```powershell
# Tìm process đang dùng port
netstat -ano | findstr :8080

# Kill process (thay PID)
taskkill /PID <PID> /F
```

### SQL Server không kết nối được

**Không còn sử dụng SQL Server nữa!** Hệ thống đã chuyển sang PostgreSQL (Supabase).

Để kết nối database:
```
Host: db.cdttwujwmdeeznblpzoi.supabase.co
Port: 5432
Database: postgres
User: postgres
Password: bach@129052004
```

Tools: pgAdmin, DBeaver, Azure Data Studio (có support PostgreSQL)

### Build lại images (clear cache)

```powershell
docker-compose build --no-cache
docker-compose up -d
```

## Tối ưu hóa

### 1. Sử dụng Docker volumes cho Maven cache

Thêm vào `docker-compose.yml`:

```yaml
services:
  msaccount:
    volumes:
      - maven_cache:/root/.m2
volumes:
  maven_cache:
```

### 2. Build riêng rồi dùng image có sẵn

```powershell
# Build tất cả images
docker-compose build

# Chỉ start (không build lại)
docker-compose up -d
```

### 3. Giới hạn resource

```yaml
services:
  msaccount:
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
```

## Production Considerations

⚠️ **Trước khi deploy production:**

1. **Thay đổi passwords mặc định** trong docker-compose.yml
2. **Sử dụng secrets management** (Docker secrets, Kubernetes secrets)
3. **Không dùng `:latest` tag** - dùng version cụ thể
4. **Enable health checks** cho tất cả services
5. **Setup monitoring** (Prometheus, Grafana)
6. **Configure logging** (ELK stack, Loki)
7. **Setup reverse proxy/load balancer** (nginx, Traefik)

## Push images lên Docker Registry

### Docker Hub

```powershell
# Login
docker login

# Tag images
docker tag apigateway:latest yourusername/apigateway:v1.0
docker tag msaccount:latest yourusername/msaccount:v1.0
docker tag msbrand:latest yourusername/msbrand:v1.0
docker tag msblindbox:latest yourusername/msblindbox:v1.0

# Push
docker push yourusername/apigateway:v1.0
docker push yourusername/msaccount:v1.0
docker push yourusername/msbrand:v1.0
docker push yourusername/msblindbox:v1.0
```

### Azure Container Registry

```powershell
# Login
az acr login --name yourregistry

# Tag
docker tag apigateway:latest yourregistry.azurecr.io/apigateway:v1.0

# Push
docker push yourregistry.azurecr.io/apigateway:v1.0
```

## Tài liệu tham khảo

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Spring Boot Docker Guide](https://spring.io/guides/topicals/spring-boot-docker/)
- [SQL Server Docker Documentation](https://learn.microsoft.com/en-us/sql/linux/sql-server-linux-docker-container-deployment)
