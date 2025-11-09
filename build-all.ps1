# Build Script cho từng microservice
# Chạy script này sau khi đã start Docker Desktop

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Docker Build Script - Microservices" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Kiểm tra Docker đang chạy
Write-Host "Checking Docker status..." -ForegroundColor Yellow
try {
    docker ps | Out-Null
    Write-Host "✓ Docker is running" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker is not running!" -ForegroundColor Red
    Write-Host "Please start Docker Desktop first!" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Build API Gateway
Write-Host "Building API Gateway..." -ForegroundColor Yellow
Set-Location APIGateway_QE180006
docker build -t apigateway-qe180006:latest .
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ API Gateway built successfully" -ForegroundColor Green
} else {
    Write-Host "✗ API Gateway build failed" -ForegroundColor Red
}
Set-Location ..

Write-Host ""

# Build MS Account
Write-Host "Building MS Account..." -ForegroundColor Yellow
Set-Location MSAccount_QE180006
docker build -t msaccount-qe180006:latest .
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ MS Account built successfully" -ForegroundColor Green
} else {
    Write-Host "✗ MS Account build failed" -ForegroundColor Red
}
Set-Location ..

Write-Host ""

# Build MS Brand
Write-Host "Building MS Brand..." -ForegroundColor Yellow
Set-Location MSBrand_QE180006
docker build -t msbrand-qe180006:latest .
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ MS Brand built successfully" -ForegroundColor Green
} else {
    Write-Host "✗ MS Brand build failed" -ForegroundColor Red
}
Set-Location ..

Write-Host ""

# Build MS BlindBox
Write-Host "Building MS BlindBox..." -ForegroundColor Yellow
Set-Location MSBlindBox_QE180006
docker build -t msblindbox-qe180006:latest .
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ MS BlindBox built successfully" -ForegroundColor Green
} else {
    Write-Host "✗ MS BlindBox build failed" -ForegroundColor Red
}
Set-Location ..

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Build Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
docker images | Select-String "qe180006"

Write-Host ""
Write-Host "To run all services with Docker Compose:" -ForegroundColor Yellow
Write-Host "  docker-compose up -d" -ForegroundColor White
Write-Host ""
Write-Host "To view logs:" -ForegroundColor Yellow
Write-Host "  docker-compose logs -f" -ForegroundColor White
