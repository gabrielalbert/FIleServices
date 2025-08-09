# File Services API - Docker Management Script
Write-Host "File Services API - Docker Management Script" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""

function Show-Menu {
    Write-Host "Please select an option:" -ForegroundColor Yellow
    Write-Host "1. Build and run with Docker Compose"
    Write-Host "2. Stop Docker Compose services"
    Write-Host "3. Build Docker image only"
    Write-Host "4. Run container from image"
    Write-Host "5. View container logs"
    Write-Host "6. Remove all containers and images"
    Write-Host "7. Exit"
    Write-Host ""
}

function Start-DockerCompose {
    Write-Host "Building and starting services with Docker Compose..." -ForegroundColor Blue
    docker-compose up -d --build
    Write-Host ""
    Write-Host "Services started! Access the API at:" -ForegroundColor Green
    Write-Host "- API: http://localhost:8080/api/files" -ForegroundColor Cyan
    Write-Host "- Swagger: http://localhost:8080/swagger" -ForegroundColor Cyan
    Write-Host ""
}

function Stop-DockerCompose {
    Write-Host "Stopping Docker Compose services..." -ForegroundColor Blue
    docker-compose down
    Write-Host "Services stopped." -ForegroundColor Green
    Write-Host ""
}

function Build-DockerImage {
    Write-Host "Building Docker image..." -ForegroundColor Blue
    docker build -t fileservices-api .
    Write-Host "Image built successfully." -ForegroundColor Green
    Write-Host ""
}

function Start-Container {
    Write-Host "Running container from image..." -ForegroundColor Blue
    docker run -d -p 8080:80 -v fileservices_uploads:/app/uploads --name fileservices-api fileservices-api
    Write-Host "Container started! Access at http://localhost:8080" -ForegroundColor Green
    Write-Host ""
}

function Show-Logs {
    Write-Host "Viewing container logs..." -ForegroundColor Blue
    docker logs fileservices-api
    Write-Host ""
}

function Remove-Everything {
    Write-Host "Stopping and removing containers..." -ForegroundColor Blue
    try { docker stop fileservices-api } catch {}
    try { docker rm fileservices-api } catch {}
    try { docker-compose down } catch {}
    
    Write-Host "Removing images..." -ForegroundColor Blue
    try { docker rmi fileservices-api } catch {}
    docker system prune -f
    
    Write-Host "Cleanup completed." -ForegroundColor Green
    Write-Host ""
}

do {
    Show-Menu
    $choice = Read-Host "Enter your choice (1-7)"
    
    switch ($choice) {
        "1" { Start-DockerCompose; Read-Host "Press Enter to continue" }
        "2" { Stop-DockerCompose; Read-Host "Press Enter to continue" }
        "3" { Build-DockerImage; Read-Host "Press Enter to continue" }
        "4" { Start-Container; Read-Host "Press Enter to continue" }
        "5" { Show-Logs; Read-Host "Press Enter to continue" }
        "6" { Remove-Everything; Read-Host "Press Enter to continue" }
        "7" { Write-Host "Goodbye!" -ForegroundColor Green; exit }
        default { Write-Host "Invalid choice. Please try again." -ForegroundColor Red }
    }
    
    Clear-Host
    Write-Host "File Services API - Docker Management Script" -ForegroundColor Green
    Write-Host "=============================================" -ForegroundColor Green
    Write-Host ""
} while ($true)
