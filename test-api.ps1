# FileServices API Test Script
# This script demonstrates how to use the FileServices API

# Base URL (adjust as needed)
$baseUrl = "http://localhost:8080/api/files"
# For local development, use: http://localhost:5000/api/files

Write-Host "File Services API Test Script" -ForegroundColor Green
Write-Host "==============================" -ForegroundColor Green
Write-Host ""

# Test 1: Health Check
Write-Host "1. Testing Health Check..." -ForegroundColor Yellow
try {
    $healthResponse = Invoke-RestMethod -Uri "$baseUrl/health" -Method GET
    Write-Host "✓ Health Check Passed" -ForegroundColor Green
    Write-Host "Response: $($healthResponse.message)" -ForegroundColor Cyan
} catch {
    Write-Host "✗ Health Check Failed: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

# Test 2: List Files (should be empty initially)
Write-Host "2. Testing List Files..." -ForegroundColor Yellow
try {
    $listResponse = Invoke-RestMethod -Uri "$baseUrl/list" -Method GET
    Write-Host "✓ List Files Passed" -ForegroundColor Green
    Write-Host "Files count: $($listResponse.data.Count)" -ForegroundColor Cyan
} catch {
    Write-Host "✗ List Files Failed: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

# Test 3: Upload a test file
Write-Host "3. Testing File Upload..." -ForegroundColor Yellow
try {
    # Create a test file
    $testFilePath = "$env:TEMP\test-file.txt"
    "This is a test file for the FileServices API" | Out-File -FilePath $testFilePath -Encoding UTF8
    
    # Upload the file
    $form = @{
        file = Get-Item -Path $testFilePath
    }
    
    $uploadResponse = Invoke-RestMethod -Uri "$baseUrl/upload" -Method POST -Form $form
    Write-Host "✓ File Upload Passed" -ForegroundColor Green
    Write-Host "Uploaded file: $($uploadResponse.fileName)" -ForegroundColor Cyan
    $uploadedFileName = $uploadResponse.fileName
    
    # Clean up test file
    Remove-Item $testFilePath -Force
} catch {
    Write-Host "✗ File Upload Failed: $($_.Exception.Message)" -ForegroundColor Red
    $uploadedFileName = $null
}
Write-Host ""

# Test 4: List Files (should show uploaded file)
if ($uploadedFileName) {
    Write-Host "4. Testing List Files (after upload)..." -ForegroundColor Yellow
    try {
        $listResponse = Invoke-RestMethod -Uri "$baseUrl/list" -Method GET
        Write-Host "✓ List Files Passed" -ForegroundColor Green
        Write-Host "Files count: $($listResponse.data.Count)" -ForegroundColor Cyan
        
        foreach ($file in $listResponse.data) {
            Write-Host "  - $($file.fileName) ($($file.size) bytes)" -ForegroundColor White
        }
    } catch {
        Write-Host "✗ List Files Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    Write-Host ""

    # Test 5: Download the uploaded file
    Write-Host "5. Testing File Download..." -ForegroundColor Yellow
    try {
        $downloadPath = "$env:TEMP\downloaded-$uploadedFileName"
        Invoke-WebRequest -Uri "$baseUrl/download/$uploadedFileName" -OutFile $downloadPath
        
        if (Test-Path $downloadPath) {
            $downloadedContent = Get-Content $downloadPath -Raw
            Write-Host "✓ File Download Passed" -ForegroundColor Green
            Write-Host "Downloaded content preview: $($downloadedContent.Substring(0, [Math]::Min(50, $downloadedContent.Length)))..." -ForegroundColor Cyan
            Remove-Item $downloadPath -Force
        } else {
            Write-Host "✗ Downloaded file not found" -ForegroundColor Red
        }
    } catch {
        Write-Host "✗ File Download Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    Write-Host ""

    # Test 6: Delete the uploaded file
    Write-Host "6. Testing File Delete..." -ForegroundColor Yellow
    try {
        $deleteResponse = Invoke-RestMethod -Uri "$baseUrl/delete/$uploadedFileName" -Method DELETE
        Write-Host "✓ File Delete Passed" -ForegroundColor Green
        Write-Host "Response: $($deleteResponse.message)" -ForegroundColor Cyan
    } catch {
        Write-Host "✗ File Delete Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    Write-Host ""

    # Test 7: Verify file is deleted
    Write-Host "7. Testing List Files (after delete)..." -ForegroundColor Yellow
    try {
        $listResponse = Invoke-RestMethod -Uri "$baseUrl/list" -Method GET
        Write-Host "✓ List Files Passed" -ForegroundColor Green
        Write-Host "Files count: $($listResponse.data.Count)" -ForegroundColor Cyan
    } catch {
        Write-Host "✗ List Files Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Test completed!" -ForegroundColor Green
Write-Host ""
Write-Host "To run the API:" -ForegroundColor Yellow
Write-Host "1. For local development: cd FileServices.Api && dotnet run" -ForegroundColor White
Write-Host "2. For Docker: docker-compose up -d --build" -ForegroundColor White
Write-Host ""
Write-Host "API Endpoints:" -ForegroundColor Yellow
Write-Host "- Health: GET $baseUrl/health" -ForegroundColor White
Write-Host "- Upload: POST $baseUrl/upload" -ForegroundColor White
Write-Host "- List: GET $baseUrl/list" -ForegroundColor White
Write-Host "- Download: GET $baseUrl/download/{fileName}" -ForegroundColor White
Write-Host "- Delete: DELETE $baseUrl/delete/{fileName}" -ForegroundColor White
