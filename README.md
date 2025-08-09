# File Services API

A .NET Core 6 Web API for file management operations including upload, download, list, and delete functionality.

## Features

- **Upload Files**: Upload files with size validation (100MB limit)
- **Download Files**: Download files by filename
- **List Files**: Get a list of all uploaded files with metadata
- **Delete Files**: Delete files by filename
- **Health Check**: API health monitoring endpoint
- **Docker Support**: Containerized deployment
- **Swagger Documentation**: Interactive API documentation

## API Endpoints

### Base URL
- Local: `http://localhost:5000/api/files` or `https://localhost:5001/api/files`
- Docker: `http://localhost:8080/api/files`

### Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/upload` | Upload a file |
| GET | `/download/{fileName}` | Download a file |
| GET | `/list` | Get list of all files |
| DELETE | `/delete/{fileName}` | Delete a file |
| GET | `/health` | Health check |

### Example Requests

#### Upload File
```bash
curl -X POST "http://localhost:8080/api/files/upload" \
  -H "accept: */*" \
  -H "Content-Type: multipart/form-data" \
  -F "file=@example.pdf"
```

#### List Files
```bash
curl -X GET "http://localhost:8080/api/files/list"
```

#### Download File
```bash
curl -X GET "http://localhost:8080/api/files/download/your-file-name.pdf" \
  --output downloaded-file.pdf
```

#### Delete File
```bash
curl -X DELETE "http://localhost:8080/api/files/delete/your-file-name.pdf"
```

## Development Setup

### Prerequisites
- .NET 6.0 SDK
- Docker (optional, for containerized deployment)

### Running Locally

1. **Clone/Navigate to the project**
   ```bash
   cd FileServices.Api
   ```

2. **Restore packages**
   ```bash
   dotnet restore
   ```

3. **Run the application**
   ```bash
   dotnet run
   ```

4. **Access Swagger UI**
   - Navigate to: `https://localhost:5001/swagger` or `http://localhost:5000/swagger`

## Docker Deployment

### Option 1: Using Docker Compose (Recommended)

1. **Build and run with docker-compose**
   ```bash
   docker-compose up -d --build
   ```

2. **Access the API**
   - API: `http://localhost:8080/api/files`
   - Swagger: `http://localhost:8080/swagger`

3. **Stop the service**
   ```bash
   docker-compose down
   ```

### Option 2: Using Docker Commands

1. **Build the Docker image**
   ```bash
   docker build -t fileservices-api .
   ```

2. **Run the container**
   ```bash
   docker run -d -p 8080:80 -v fileservices_uploads:/app/uploads --name fileservices-api fileservices-api
   ```

3. **Stop and remove the container**
   ```bash
   docker stop fileservices-api
   docker rm fileservices-api
   ```

## Configuration

### File Upload Settings
- **Maximum file size**: 100MB
- **Upload directory**: `uploads/` (created automatically)
- **Supported file types**: PDF, DOC, DOCX, XLS, XLSX, PNG, JPG, JPEG, GIF, TXT, ZIP, RAR

### Environment Variables
- `ASPNETCORE_ENVIRONMENT`: Set to `Development` or `Production`
- `ASPNETCORE_URLS`: Configure listening URLs

## Project Structure

```
FileServices/
├── FileServices.Api/
│   ├── Controllers/
│   │   └── FilesController.cs
│   ├── Models/
│   │   └── FileModels.cs
│   ├── Services/
│   │   └── FileService.cs
│   ├── Program.cs
│   ├── FileServices.Api.csproj
│   ├── appsettings.json
│   └── appsettings.Development.json
├── Dockerfile
├── docker-compose.yml
├── .dockerignore
└── README.md
```

## Response Models

### Upload Response
```json
{
  "success": true,
  "message": "File uploaded successfully",
  "fileName": "unique-filename.pdf",
  "fileSize": 1024
}
```

### File List Response
```json
{
  "success": true,
  "message": "Files retrieved successfully",
  "data": [
    {
      "fileName": "example.pdf",
      "size": 1024,
      "createdDate": "2025-01-01T00:00:00Z",
      "contentType": "application/pdf"
    }
  ]
}
```

### Error Response
```json
{
  "success": false,
  "message": "Error description",
  "data": null
}
```

## Health Check

The API includes a health check endpoint at `/api/files/health` that returns:

```json
{
  "success": true,
  "message": "File Service API is running",
  "data": {
    "timestamp": "2025-01-01T00:00:00Z"
  }
}
```

## Security Considerations

- File uploads are validated for size limits
- Unique filenames are generated to prevent conflicts
- CORS is configured for development (adjust for production)
- Consider implementing authentication for production use

## Troubleshooting

### Common Issues

1. **File upload fails**
   - Check file size (must be under 100MB)
   - Ensure uploads directory exists and is writable

2. **Docker container fails to start**
   - Check if port 8080 is available
   - Verify Docker daemon is running

3. **Files not persisting in Docker**
   - Ensure volume mapping is correct in docker-compose.yml
   - Check container logs: `docker logs fileservices-api`

### Logging

The application uses structured logging. To view logs in Docker:

```bash
docker logs fileservices-api
```

For more detailed logs, set the environment variable:
```bash
ASPNETCORE_ENVIRONMENT=Development
```
