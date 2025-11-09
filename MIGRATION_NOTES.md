# Migration từ SQL Server sang PostgreSQL (Supabase)

## Tổng quan
Hệ thống đã được migrate từ SQL Server local sang PostgreSQL trên Supabase cloud.

## Thay đổi chính

### 1. Database
- ❌ **Trước**: SQL Server 2022 (local container)
- ✅ **Sau**: PostgreSQL 14+ (Supabase cloud)

### 2. Connection String
**SQL Server (cũ)**:
```
jdbc:sqlserver://localhost:1433;databaseName=MSS301Summer25DBAccount;encrypt=true;trustServerCertificate=true
```

**PostgreSQL (mới)**:
```
jdbc:postgresql://db.cdttwujwmdeeznblpzoi.supabase.co:5432/postgres
```

### 3. Database Driver

**Maven Dependencies (pom.xml)**:
```xml
<!-- CŨ - SQL Server -->
<dependency>
    <groupId>com.microsoft.sqlserver</groupId>
    <artifactId>mssql-jdbc</artifactId>
</dependency>

<!-- MỚI - PostgreSQL -->
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
</dependency>
```

### 4. Hibernate Dialect

**application.properties**:
```properties
# Thêm mới
spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect
```

### 5. Database Schema Strategy

**Trước**: Mỗi service có database riêng
- MSS301Summer25DBAccount
- MSS301Summer25DBBrand
- MSS301Summer25DBBlindBox

**Sau**: Tất cả dùng chung database `postgres`, mỗi service có schema riêng
- msaccount
- msbrand
- msblindbox

**Configuration**:
```properties
spring.jpa.properties.hibernate.default_schema=msaccount
```

### 6. Docker Compose

**Xóa**:
- SQL Server container
- sqlserver volume
- Health check dependencies

**Thêm**:
- Environment variables cho PostgreSQL connection
- Schema configuration

## Chi tiết thay đổi từng file

### MSAccount_QE180006

#### pom.xml
```diff
- <dependency>
-     <groupId>com.microsoft.sqlserver</groupId>
-     <artifactId>mssql-jdbc</artifactId>
- </dependency>
+ <dependency>
+     <groupId>org.postgresql</groupId>
+     <artifactId>postgresql</artifactId>
+ </dependency>
```

#### application.properties
```diff
- spring.datasource.url=jdbc:sqlserver://localhost:1433;databaseName=MSS301Summer25DBAccount;...
- spring.datasource.username=sa2
- spring.datasource.password=12345
- spring.datasource.driver-class-name=com.microsoft.sqlserver.jdbc.SQLServerDriver

+ spring.datasource.url=jdbc:postgresql://db.cdttwujwmdeeznblpzoi.supabase.co:5432/postgres
+ spring.datasource.username=postgres
+ spring.datasource.password=bach@129052004
+ spring.datasource.driver-class-name=org.postgresql.Driver
+ spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect
+ spring.jpa.properties.hibernate.default_schema=msaccount
```

### MSBrand_QE180006
Tương tự MSAccount, với schema: `msbrand`

### MSBlindBox_QE180006
Tương tự MSAccount, với schema: `msblindbox`

### docker-compose.yml

**Xóa SQL Server service**:
```diff
- sqlserver:
-   image: mcr.microsoft.com/mssql/server:2022-latest
-   ...
```

**Cập nhật environment variables**:
```diff
  msaccount:
    environment:
-     - SPRING_DATASOURCE_URL=jdbc:sqlserver://sqlserver:1433;...
-     - SPRING_DATASOURCE_USERNAME=sa
-     - SPRING_DATASOURCE_PASSWORD=YourStrong@Passw0rd
+     - SPRING_DATASOURCE_URL=jdbc:postgresql://db.cdttwujwmdeeznblpzoi.supabase.co:5432/postgres
+     - SPRING_DATASOURCE_USERNAME=postgres
+     - SPRING_DATASOURCE_PASSWORD=bach@129052004
+     - SPRING_JPA_PROPERTIES_HIBERNATE_DEFAULT_SCHEMA=msaccount
```

**Xóa dependencies**:
```diff
- depends_on:
-   sqlserver:
-     condition: service_healthy
```

**Xóa volumes**:
```diff
- volumes:
-   sqlserver_data:
```

## Ưu điểm của PostgreSQL/Supabase

### 1. Cloud-based
- ✅ Không cần chạy database container local
- ✅ Giảm resource usage (RAM, CPU, Disk)
- ✅ Database luôn available

### 2. Managed Service
- ✅ Automatic backups
- ✅ High availability
- ✅ Monitoring & logging built-in
- ✅ SSL/TLS encryption

### 3. Development
- ✅ Dễ share database giữa các developers
- ✅ Consistent data across environments
- ✅ Faster Docker builds (không cần wait SQL Server container)

### 4. PostgreSQL Features
- ✅ Better standards compliance
- ✅ Rich JSON support
- ✅ Full-text search
- ✅ Extensible với plugins

## Testing Migration

### Kiểm tra connection
```powershell
# Test PostgreSQL connection với psql client
psql "postgresql://postgres:bach@129052004@db.cdttwujwmdeeznblpzoi.supabase.co:5432/postgres"

# Hoặc dùng pgAdmin, DBeaver, Azure Data Studio
```

### Verify schemas
```sql
-- List all schemas
SELECT schema_name FROM information_schema.schemata;

-- Should see: msaccount, msbrand, msblindbox

-- List tables in each schema
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'msaccount';
```

## Rollback (nếu cần)

Nếu cần quay lại SQL Server, restore từ git:
```powershell
git checkout HEAD -- pom.xml
git checkout HEAD -- src/main/resources/application.properties
git checkout HEAD -- docker-compose.yml
```

Hoặc tham khảo commit trước thay đổi này.

## Lưu ý Production

### Security
⚠️ **Password đang hardcoded** trong config files và docker-compose.yml

**Khuyến nghị**:
1. Sử dụng `.env` file (không commit vào git)
2. Hoặc dùng Docker secrets
3. Hoặc external secret management (AWS Secrets Manager, Azure Key Vault)

### Connection Pooling
Thêm vào application.properties:
```properties
spring.datasource.hikari.maximum-pool-size=5
spring.datasource.hikari.minimum-idle=2
spring.datasource.hikari.connection-timeout=30000
```

### SSL/TLS
Supabase đã enable SSL mặc định. Có thể enforce:
```properties
spring.datasource.url=jdbc:postgresql://...?ssl=true&sslmode=require
```

## Support

- PostgreSQL docs: https://www.postgresql.org/docs/
- Supabase docs: https://supabase.com/docs
- Spring Data JPA + PostgreSQL: https://spring.io/guides/gs/accessing-data-jpa/
