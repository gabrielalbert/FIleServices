@echo off
echo File Services API - Docker Management Script
echo =============================================
echo.

:menu
echo Please select an option:
echo 1. Build and run with Docker Compose
echo 2. Stop Docker Compose services
echo 3. Build Docker image only
echo 4. Run container from image
echo 5. View container logs
echo 6. Remove all containers and images
echo 7. Exit
echo.

set /p choice="Enter your choice (1-7): "

if "%choice%"=="1" goto compose_up
if "%choice%"=="2" goto compose_down
if "%choice%"=="3" goto build_image
if "%choice%"=="4" goto run_container
if "%choice%"=="5" goto view_logs
if "%choice%"=="6" goto cleanup
if "%choice%"=="7" goto exit
goto menu

:compose_up
echo Building and starting services with Docker Compose...
docker-compose up -d --build
echo.
echo Services started! Access the API at:
echo - API: http://localhost:8080/api/files
echo - Swagger: http://localhost:8080/swagger
echo.
pause
goto menu

:compose_down
echo Stopping Docker Compose services...
docker-compose down
echo Services stopped.
echo.
pause
goto menu

:build_image
echo Building Docker image...
docker build -t fileservices-api .
echo Image built successfully.
echo.
pause
goto menu

:run_container
echo Running container from image...
docker run -d -p 8080:80 -v fileservices_uploads:/app/uploads --name fileservices-api fileservices-api
echo Container started! Access at http://localhost:8080
echo.
pause
goto menu

:view_logs
echo Viewing container logs...
docker logs fileservices-api
echo.
pause
goto menu

:cleanup
echo Stopping and removing containers...
docker stop fileservices-api 2>nul
docker rm fileservices-api 2>nul
docker-compose down 2>nul
echo Removing images...
docker rmi fileservices-api 2>nul
docker system prune -f
echo Cleanup completed.
echo.
pause
goto menu

:exit
echo Goodbye!
exit /b 0
