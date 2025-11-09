# Build và Push Docker Images
# Script để build và push tất cả images lên Docker Hub

param(
    [Parameter(Mandatory=$true)]
    [string]$DockerUsername
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Build & Push Docker Images" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Kiểm tra Docker đang chạy
Write-Host "Checking Docker..." -ForegroundColor Yellow
try {
    docker ps | Out-Null
    Write-Host "✓ Docker is running" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker is not running!" -ForegroundColor Red
    Write-Host "Please start Docker Desktop first!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Docker Hub Username: $DockerUsername" -ForegroundColor Cyan
Write-Host ""

# Login to Docker Hub
Write-Host "Logging in to Docker Hub..." -ForegroundColor Yellow
docker login
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Docker login failed" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Build và Push API Gateway
Write-Host "Building API Gateway..." -ForegroundColor Yellow
Set-Location APIGateway_QE180006
docker build -t apigateway-qe180006:latest .
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Built successfully" -ForegroundColor Green
    docker tag apigateway-qe180006:latest ${DockerUsername}/apigateway-qe180006:latest
    Write-Host "Pushing to Docker Hub..." -ForegroundColor Yellow
    docker push ${DockerUsername}/apigateway-qe180006:latest
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Pushed successfully" -ForegroundColor Green
    }
}
Set-Location ..
Write-Host ""

# Build và Push MS Account
Write-Host "Building MS Account..." -ForegroundColor Yellow
Set-Location MSAccount_QE180006
docker build -t msaccount-qe180006:latest .
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Built successfully" -ForegroundColor Green
    docker tag msaccount-qe180006:latest ${DockerUsername}/msaccount-qe180006:latest
    Write-Host "Pushing to Docker Hub..." -ForegroundColor Yellow
    docker push ${DockerUsername}/msaccount-qe180006:latest
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Pushed successfully" -ForegroundColor Green
    }
}
Set-Location ..
Write-Host ""

# Build và Push MS Brand
Write-Host "Building MS Brand..." -ForegroundColor Yellow
Set-Location MSBrand_QE180006
docker build -t msbrand-qe180006:latest .
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Built successfully" -ForegroundColor Green
    docker tag msbrand-qe180006:latest ${DockerUsername}/msbrand-qe180006:latest
    Write-Host "Pushing to Docker Hub..." -ForegroundColor Yellow
    docker push ${DockerUsername}/msbrand-qe180006:latest
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Pushed successfully" -ForegroundColor Green
    }
}
Set-Location ..
Write-Host ""

# Build và Push MS BlindBox
Write-Host "Building MS BlindBox..." -ForegroundColor Yellow
Set-Location MSBlindBox_QE180006
docker build -t msblindbox-qe180006:latest .
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Built successfully" -ForegroundColor Green
    docker tag msblindbox-qe180006:latest ${DockerUsername}/msblindbox-qe180006:latest
    Write-Host "Pushing to Docker Hub..." -ForegroundColor Yellow
    docker push ${DockerUsername}/msblindbox-qe180006:latest
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Pushed successfully" -ForegroundColor Green
    }
}
Set-Location ..
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Images on Docker Hub" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "${DockerUsername}/apigateway-qe180006:latest" -ForegroundColor White
Write-Host "${DockerUsername}/msaccount-qe180006:latest" -ForegroundColor White
Write-Host "${DockerUsername}/msbrand-qe180006:latest" -ForegroundColor White
Write-Host "${DockerUsername}/msblindbox-qe180006:latest" -ForegroundColor White
Write-Host ""
Write-Host "To deploy, update docker-compose.yml with these image names" -ForegroundColor Yellow
