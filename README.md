# Bitnami Root Spark Docker Image

This project creates a Bitnami Spark Docker image that runs with root permissions. By default, Bitnami images are non-root for security purposes, but in some development and testing scenarios, a root-enabled image may be necessary.

## Table of Contents

1. [Overview](#overview)
2. [Quick Start Guide](#quick-start-guide)
3. [Prerequisites](#prerequisites)
4. [Setup Instructions](#setup-instructions)
   - [Building the Image](#building-the-image)
   - [Running the Cluster](#running-the-cluster)
   - [Accessing the Interfaces](#accessing-the-interfaces)
5. [Using the Cluster](#using-the-cluster)
   - [Running Spark Jobs](#running-spark-jobs)
   - [Running Example Applications](#running-example-applications)
6. [Configuration Options](#configuration-options)
7. [Troubleshooting](#troubleshooting)
8. [Notes and Security Considerations](#notes-and-security-considerations)
9. [Performance Tuning](#performance-tuning)
10. [License](#license)

## Overview

This Docker setup provides:
- A complete Spark cluster with a master and two worker nodes
- Root user access on all containers
- Example Spark applications in Python and Scala
- Shared volume for data persistence

**Project Structure**:
- `Dockerfile`: Creates a Spark image based on Bitnami's Spark image with root permissions
- `docker-compose.yml`: Configures the complete Spark cluster
- `examples/`: Contains sample Spark applications for testing
- `build.sh/build.ps1`: Build scripts for different platforms

## Quick Start Guide

```bash
# Build the image
./build.sh  # On macOS/Linux
# OR
./build.ps1 # On Windows

# Start the cluster
docker-compose up -d

# Access the Spark Web UI
# Open http://localhost:8080 in your browser

# Enter the master container
docker exec -it spark-master bash

# Run the Python example
spark-submit --master spark://spark-master:7077 /opt/bitnami/spark/examples/pyspark_example.py

# Stop the cluster when done
docker-compose down
```

**Access Information**:
- **Spark Web UI**: http://localhost:8080
- **Spark Master**: spark://spark-master:7077
- **Worker UIs**: http://localhost:8081, http://localhost:8082
- **Root Access**: All containers run as root user (no password required)

## Prerequisites

- Docker and Docker Compose installed on your machine
- Git (to clone this repository)

## Setup Instructions

### Building the Image

**Clone the Repository**:
```bash
git clone https://github.com/yourusername/bitnami-root-docker-image.git
cd bitnami-root-docker-image
```

**Build the Image**:
```bash
# On macOS/Linux
chmod +x build.sh
./build.sh

# On Windows
.\build.ps1

# Or build directly with Docker
docker build -t bitnami-root-spark .
```

**Platform-Specific Options**:

| Platform | Considerations | Command |
|----------|----------------|---------|
| Apple Silicon | Use Docker Desktop 4.6.0+<br>Enable Rosetta if needed | `docker build --platform linux/arm64/v8 -t bitnami-root-spark .` |
| Intel Mac | Standard build | `docker build -t bitnami-root-spark .` |
| Windows | Use Docker Desktop with WSL 2 | `docker build -t bitnami-root-spark .` |

### Running the Cluster

Start the Spark cluster with a master and two worker nodes:

```bash
docker-compose up -d
```

This creates:
- A Spark master node on port 8080
- Two Spark worker nodes on ports 8081 and 8082
- Shared volume for data persistence

### Accessing the Interfaces

- **Spark Master Web UI**: http://localhost:8080
- **Worker 1 Web UI**: http://localhost:8081
- **Worker 2 Web UI**: http://localhost:8082

## Using the Cluster

### Running Spark Jobs

1. **Connect to the Master Container**:
   ```bash
   docker exec -it spark-master bash
   ```

2. **Submit a Spark Job**:
   ```bash
   # Run the included Python example
   spark-submit --master spark://spark-master:7077 /opt/bitnami/spark/examples/pyspark_example.py
   
   # Or run your own application
   spark-submit --master spark://spark-master:7077 your-application.jar
   ```

### Running Example Applications

This repository includes example applications in the `examples/` directory:

```bash
# Copy an example to the container
docker cp examples/pyspark_example.py spark-master:/opt/bitnami/spark/examples/

# Run the example
docker exec -it spark-master bash -c "spark-submit --master spark://spark-master:7077 /opt/bitnami/spark/examples/pyspark_example.py"
```

To stop the cluster when finished:
```bash
docker-compose down
```

## Configuration Options

Customize Spark by modifying environment variables in `docker-compose.yml`:

```yaml
environment:
  - SPARK_WORKER_MEMORY=2G  # Memory allocation for workers
  - SPARK_WORKER_CORES=2    # CPU cores for workers
  - SPARK_DAEMON_MEMORY=1G  # Memory for Spark daemons
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| **Port conflicts** | Modify port mappings in `docker-compose.yml` if ports 8080, 7077, or 8081-8082 are in use |
| **Memory issues** | Reduce worker memory in `docker-compose.yml` if containers fail to start |
| **Network issues** | Run `docker-compose down --volumes` and then `docker-compose up -d` |

**Platform-Specific Troubleshooting**:

**Apple Silicon**:
```bash
# For ARM64 native build
docker build --platform linux/arm64/v8 -t bitnami-root-spark .

# For x86 compatibility with emulation
docker build --platform linux/amd64 -t bitnami-root-spark .
```

**Windows Path Issues**:
```powershell
# Use proper path format in PowerShell
docker cp .\examples\pyspark_example.py spark-master:/opt/bitnami/spark/examples/
```

## Notes and Security Considerations

- This image runs Spark as the root user for development/testing convenience
- Not recommended for production use due to security implications
- For production, use standard non-root Bitnami images with proper configuration

## Performance Tuning

**Resource Allocation**:
```yaml
environment:
  - SPARK_WORKER_MEMORY=4G  # Allocate more memory to workers
  - SPARK_WORKER_CORES=2    # Allocate more CPU cores
```

**Volume Mounting for Better Performance**:
```yaml
volumes:
  - ./data:/data:cached  # Improves performance on macOS
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.