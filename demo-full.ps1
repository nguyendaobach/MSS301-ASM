# DEMO SCRIPT - CHẠY TỰ ĐỘNG
# Dùng cho backup hoặc practice

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "MICROSERVICES DEPLOYMENT DEMO" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Student: [YOUR_NAME]" -ForegroundColor Yellow
Write-Host "MSSV: QE180006" -ForegroundColor Yellow
Write-Host ""

Start-Sleep -Seconds 2

# 1. Docker Version
Write-Host "[STEP 1] Docker Version" -ForegroundColor Green
Write-Host "----------------------------------------" -ForegroundColor Gray
docker --version
docker-compose --version
Write-Host ""
Start-Sleep -Seconds 3

# 2. Project Structure
Write-Host "[STEP 2] Project Structure" -ForegroundColor Green
Write-Host "----------------------------------------" -ForegroundColor Gray
Get-ChildItem -Directory | Select-Object Name
Write-Host ""
Start-Sleep -Seconds 3

# 3. Show Dockerfile
Write-Host "[STEP 3] Dockerfile Example (API Gateway)" -ForegroundColor Green
Write-Host "----------------------------------------" -ForegroundColor Gray
Get-Content APIGateway_QE180006\Dockerfile | Select-Object -First 15
Write-Host "..."
Write-Host ""
Start-Sleep -Seconds 3

# 4. List Images
Write-Host "[STEP 4] Docker Images" -ForegroundColor Green
Write-Host "----------------------------------------" -ForegroundColor Gray
docker images | Select-String "qe180006"
Write-Host ""
Start-Sleep -Seconds 3

# 5. Pull Images
Write-Host "[STEP 5] Pull Images from Docker Hub" -ForegroundColor Green
Write-Host "----------------------------------------" -ForegroundColor Gray
docker-compose -f docker-compose.deploy.yml pull
Write-Host ""
Start-Sleep -Seconds 3

# 6. Start Services
Write-Host "[STEP 6] Starting All Services" -ForegroundColor Green
Write-Host "----------------------------------------" -ForegroundColor Gray
docker-compose -f docker-compose.deploy.yml up -d
Write-Host ""
Start-Sleep -Seconds 5

# 7. Check Status
Write-Host "[STEP 7] Services Status" -ForegroundColor Green
Write-Host "----------------------------------------" -ForegroundColor Gray
docker-compose -f docker-compose.deploy.yml ps
Write-Host ""
Start-Sleep -Seconds 3

# 8. Show Logs
Write-Host "[STEP 8] Services Logs (Last 20 lines)" -ForegroundColor Green
Write-Host "----------------------------------------" -ForegroundColor Gray
docker-compose -f docker-compose.deploy.yml logs --tail=20
Write-Host ""
Start-Sleep -Seconds 3

# 9. Test API
Write-Host "[STEP 9] Testing API Gateway" -ForegroundColor Green
Write-Host "----------------------------------------" -ForegroundColor Gray
Start-Sleep -Seconds 3
try {
    $response = Invoke-WebRequest http://localhost:8080 -UseBasicParsing -TimeoutSec 5
    Write-Host "✓ API Gateway is responding!" -ForegroundColor Green
    Write-Host "Status Code: $($response.StatusCode)" -ForegroundColor White
} catch {
    Write-Host "⚠ API Gateway starting... (This is normal for first request)" -ForegroundColor Yellow
}
Write-Host ""
Start-Sleep -Seconds 3

# 10. Summary
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "DEPLOYMENT SUMMARY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "✅ Architecture: Microservices" -ForegroundColor Green
Write-Host "✅ Services: 4 (API Gateway + 3 Microservices)" -ForegroundColor Green
Write-Host "✅ Database: PostgreSQL (Cloud)" -ForegroundColor Green
Write-Host "✅ Container Platform: Docker" -ForegroundColor Green
Write-Host "✅ Image Registry: Docker Hub" -ForegroundColor Green
Write-Host ""
Write-Host "Service URLs:" -ForegroundColor Yellow
Write-Host "  API Gateway:  http://localhost:8080" -ForegroundColor White
Write-Host "  MS Account:   http://localhost:8081" -ForegroundColor White
Write-Host "  MS Brand:     http://localhost:8082" -ForegroundColor White
Write-Host "  MS BlindBox:  http://localhost:8083" -ForegroundColor White
Write-Host ""
Write-Host "Docker Hub Images:" -ForegroundColor Yellow
Write-Host "  nguyendaobach/apigateway-qe180006:latest" -ForegroundColor White
Write-Host "  nguyendaobach/msaccount-qe180006:latest" -ForegroundColor White
Write-Host "  nguyendaobach/msbrand-qe180006:latest" -ForegroundColor White
Write-Host "  nguyendaobach/msblindbox-qe180006:latest" -ForegroundColor White
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "DEMO COMPLETE!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
