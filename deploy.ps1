# Script Deploy đầy đủ
# Chạy script này để build, push và deploy tất cả

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Full Deployment Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Bước 1: Kiểm tra Docker
Write-Host "[1/7] Checking Docker..." -ForegroundColor Yellow
try {
    docker ps | Out-Null
    Write-Host "✓ Docker is running" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker is not running!" -ForegroundColor Red
    Write-Host "Please start Docker Desktop first!" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Bước 2: Login Docker Hub
Write-Host "[2/7] Docker Hub Login..." -ForegroundColor Yellow
Write-Host "Please login with username: nguyendaobach" -ForegroundColor Cyan
docker login
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Docker login failed" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Logged in successfully" -ForegroundColor Green
Write-Host ""

# Bước 3: Build images
Write-Host "[3/7] Building images..." -ForegroundColor Yellow

Write-Host "  Building API Gateway..." -ForegroundColor White
Set-Location APIGateway_QE180006
docker build -t nguyendaobach/apigateway-qe180006:latest . --quiet
if ($LASTEXITCODE -eq 0) { Write-Host "  ✓ API Gateway built" -ForegroundColor Green }
Set-Location ..

Write-Host "  Building MS Account..." -ForegroundColor White
Set-Location MSAccount_QE180006
docker build -t nguyendaobach/msaccount-qe180006:latest . --quiet
if ($LASTEXITCODE -eq 0) { Write-Host "  ✓ MS Account built" -ForegroundColor Green }
Set-Location ..

Write-Host "  Building MS Brand..." -ForegroundColor White
Set-Location MSBrand_QE180006
docker build -t nguyendaobach/msbrand-qe180006:latest . --quiet
if ($LASTEXITCODE -eq 0) { Write-Host "  ✓ MS Brand built" -ForegroundColor Green }
Set-Location ..

Write-Host "  Building MS BlindBox..." -ForegroundColor White
Set-Location MSBlindBox_QE180006
docker build -t nguyendaobach/msblindbox-qe180006:latest . --quiet
if ($LASTEXITCODE -eq 0) { Write-Host "  ✓ MS BlindBox built" -ForegroundColor Green }
Set-Location ..

Write-Host ""

# Bước 4: Push images
Write-Host "[4/7] Pushing images to Docker Hub..." -ForegroundColor Yellow
docker push nguyendaobach/apigateway-qe180006:latest
docker push nguyendaobach/msaccount-qe180006:latest
docker push nguyendaobach/msbrand-qe180006:latest
docker push nguyendaobach/msblindbox-qe180006:latest
Write-Host "✓ All images pushed" -ForegroundColor Green
Write-Host ""

# Bước 5: Stop old containers
Write-Host "[5/7] Stopping old containers..." -ForegroundColor Yellow
docker-compose -f docker-compose.deploy.yml down 2>$null
Write-Host "✓ Old containers stopped" -ForegroundColor Green
Write-Host ""

# Bước 6: Pull latest images
Write-Host "[6/7] Pulling latest images..." -ForegroundColor Yellow
docker-compose -f docker-compose.deploy.yml pull
Write-Host "✓ Images pulled" -ForegroundColor Green
Write-Host ""

# Bước 7: Start services
Write-Host "[7/7] Starting services..." -ForegroundColor Yellow
docker-compose -f docker-compose.deploy.yml up -d
Write-Host "✓ Services started" -ForegroundColor Green
Write-Host ""

# Summary
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Deployment Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Service URLs:" -ForegroundColor Yellow
Write-Host "  API Gateway:  http://localhost:8080" -ForegroundColor White
Write-Host "  MS Account:   http://localhost:8081" -ForegroundColor White
Write-Host "  MS Brand:     http://localhost:8082" -ForegroundColor White
Write-Host "  MS BlindBox:  http://localhost:8083" -ForegroundColor White
Write-Host ""
Write-Host "View logs:" -ForegroundColor Yellow
Write-Host "  docker-compose -f docker-compose.deploy.yml logs -f" -ForegroundColor White
Write-Host ""
Write-Host "Check status:" -ForegroundColor Yellow
Write-Host "  docker-compose -f docker-compose.deploy.yml ps" -ForegroundColor White
Write-Host ""

# Show running containers
Write-Host "Running containers:" -ForegroundColor Yellow
docker-compose -f docker-compose.deploy.yml ps
