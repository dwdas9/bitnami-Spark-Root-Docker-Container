# PowerShell script for building the Bitnami root Spark Docker image on Windows

Write-Host "Building Bitnami root Spark Docker image..." -ForegroundColor Green

# Check if we're running on Windows
if ($env:OS -match "Windows") {
    Write-Host "Detected Windows operating system"
}

# Build the Docker image
docker build -t bitnami-root-spark .

# Check if the build was successful
if ($LASTEXITCODE -eq 0) {
    Write-Host "Docker image built successfully!" -ForegroundColor Green
    Write-Host "You can now run 'docker-compose up -d' to start the Spark cluster." -ForegroundColor Green
} else {
    Write-Host "Error building Docker image." -ForegroundColor Red
    exit 1
}
