# Stop Script - Dừng tất cả services

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Stop Microservices" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Choose an option:" -ForegroundColor Yellow
Write-Host "  1. Stop services (keep data)" -ForegroundColor White
Write-Host "  2. Stop and remove containers (keep data)" -ForegroundColor White
Write-Host "  3. Stop and remove everything (including database data)" -ForegroundColor Red
Write-Host ""

$choice = Read-Host "Enter your choice (1-3)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "Stopping services..." -ForegroundColor Yellow
        docker-compose stop
        Write-Host "✓ Services stopped" -ForegroundColor Green
        Write-Host "To restart: docker-compose start" -ForegroundColor Yellow
    }
    "2" {
        Write-Host ""
        Write-Host "Stopping and removing containers..." -ForegroundColor Yellow
        docker-compose down
        Write-Host "✓ Containers removed (volumes/data preserved)" -ForegroundColor Green
        Write-Host "To rebuild: docker-compose up --build -d" -ForegroundColor Yellow
    }
    "3" {
        Write-Host ""
        $confirm = Read-Host "This will delete all database data. Are you sure? (Y/N)"
        if ($confirm -eq "Y" -or $confirm -eq "y") {
            Write-Host "Stopping and removing everything..." -ForegroundColor Red
            docker-compose down -v
            Write-Host "✓ Everything removed (including data)" -ForegroundColor Green
            Write-Host "To rebuild: docker-compose up --build -d" -ForegroundColor Yellow
        } else {
            Write-Host "Cancelled." -ForegroundColor Yellow
        }
    }
    default {
        Write-Host "Invalid choice" -ForegroundColor Red
    }
}

Write-Host ""
