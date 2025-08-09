# Quick Start Guide

## Option 1: Run with Docker (Recommended)

1. **Start the API with Docker Compose:**
   ```bash
   docker-compose up -d --build
   ```

2. **Access the API:**
   - API Base URL: http://localhost:8080/api/files
   - Swagger Documentation: http://localhost:8080/swagger

3. **Test the API:**
   ```bash
   # Run the PowerShell test script
   .\test-api.ps1
   ```

4. **Stop the service:**
   ```bash
   docker-compose down
   ```

## Option 2: Run Locally

1. **Navigate to the API project:**
   ```bash
   cd FileServices.Api
   ```

2. **Run the application:**
   ```bash
   dotnet run
   ```

3. **Access the API:**
   - API Base URL: http://localhost:5000/api/files
   - Swagger Documentation: http://localhost:5000/swagger

## Quick Test with cURL

```bash
# Health check
curl http://localhost:8080/api/files/health

# Upload a file
curl -X POST http://localhost:8080/api/files/upload \
  -F "file=@your-file.txt"

# List files
curl http://localhost:8080/api/files/list

# Download a file
curl http://localhost:8080/api/files/download/filename.txt \
  --output downloaded-file.txt

# Delete a file
curl -X DELETE http://localhost:8080/api/files/delete/filename.txt
```

## Management Scripts

Use the provided management scripts for easy Docker operations:

- **Windows Batch:** `docker-manager.bat`
- **PowerShell:** `docker-manager.ps1`

These scripts provide an interactive menu for:
- Building and running with Docker Compose
- Stopping services
- Building Docker images
- Viewing logs
- Cleanup operations
