# Quick Start Script - Build và chạy tất cả services
# Script này sẽ build và start tất cả microservices cùng SQL Server

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Microservices Quick Start" -ForegroundColor Cyan
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
Write-Host "This will:" -ForegroundColor Yellow
Write-Host "  1. Build all microservices" -ForegroundColor White
Write-Host "  2. Start all microservices" -ForegroundColor White
Write-Host "  3. Connect to PostgreSQL (Supabase)" -ForegroundColor White
Write-Host "  4. Configure network and connections" -ForegroundColor White
Write-Host ""

$confirm = Read-Host "Continue? (Y/N)"
if ($confirm -ne "Y" -and $confirm -ne "y") {
    Write-Host "Cancelled." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "Building and starting services..." -ForegroundColor Yellow
docker-compose up --build -d

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✓ All services started successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Service URLs" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "API Gateway:      http://localhost:8080" -ForegroundColor White
    Write-Host "MS Account:       http://localhost:8081" -ForegroundColor White
    Write-Host "MS Brand:         http://localhost:8082" -ForegroundColor White
    Write-Host "MS BlindBox:      http://localhost:8083" -ForegroundColor White
    Write-Host "PostgreSQL:       db.cdttwujwmdeeznblpzoi.supabase.co:5432" -ForegroundColor White
    Write-Host ""
    Write-Host "PostgreSQL Credentials (Supabase):" -ForegroundColor Yellow
    Write-Host "  Host:     db.cdttwujwmdeeznblpzoi.supabase.co" -ForegroundColor White
    Write-Host "  Port:     5432" -ForegroundColor White
    Write-Host "  Database: postgres" -ForegroundColor White
    Write-Host "  Username: postgres" -ForegroundColor White
    Write-Host "  Password: bach@129052004" -ForegroundColor White
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Useful Commands" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "View logs:        docker-compose logs -f" -ForegroundColor White
    Write-Host "View specific:    docker-compose logs -f apigateway" -ForegroundColor White
    Write-Host "Stop all:         docker-compose stop" -ForegroundColor White
    Write-Host "Remove all:       docker-compose down" -ForegroundColor White
    Write-Host "Remove + data:    docker-compose down -v" -ForegroundColor White
    Write-Host ""
    
    # Show running containers
    Write-Host "Running containers:" -ForegroundColor Yellow
    docker-compose ps
} else {
    Write-Host ""
    Write-Host "✗ Failed to start services" -ForegroundColor Red
    Write-Host "Check logs with: docker-compose logs" -ForegroundColor Yellow
}
