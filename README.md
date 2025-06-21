# Bitnami Root Spark Docker Image

This project creates a Bitnami Spark Docker image that runs with root permissions. By default, Bitnami images are non-root for security purposes, but in some development and testing scenarios, a root-enabled image may be necessary.

## Contents

- `Dockerfile`: Creates a Spark image based on Bitnami's Spark image, but with root user permissions
- `docker-compose.yml`: Sets up a complete Spark cluster with a master and two worker nodes
- `examples/`: Contains sample Spark applications for testing

## Prerequisites

- Docker and Docker Compose installed on your machine
- Git (to clone this repository)

## Getting Started

### Clone the Repository

```bash
git clone https://github.com/yourusername/bitnami-root-docker-image.git
cd bitnami-root-docker-image
```

### Platform-Specific Considerations

#### macOS (Intel and Apple Silicon)

For Apple Silicon (M1/M2/M3) Macs:
- Make sure you're running Docker Desktop 4.6.0 or later
- In Docker Desktop settings, ensure "Use Rosetta for x86/amd64 emulation on Apple Silicon" is enabled if you need x86 compatibility

```bash
# For Apple Silicon, you may want to specify the platform:
docker build --platform linux/arm64/v8 -t bitnami-root-spark .
```

For Intel Macs:
```bash
docker build -t bitnami-root-spark .
```

#### Windows

On Windows, make sure you have:
- Docker Desktop with WSL 2 backend installed
- Git Bash, PowerShell, or Windows Command Prompt

Using PowerShell:
```powershell
docker build -t bitnami-root-spark .
```

Using Command Prompt:
```cmd
docker build -t bitnami-root-spark .
```

Using Git Bash:
```bash
docker build -t bitnami-root-spark .
```

## Usage

### Building the Image

To build the Docker image:

```bash
# Using the provided build script (macOS/Linux)
chmod +x build.sh
./build.sh

# Or build directly using Docker
docker build -t bitnami-root-spark .
```

For Windows using PowerShell:
```powershell
docker build -t bitnami-root-spark .
```

### Running a Spark Cluster

To start a complete Spark cluster with a master and two worker nodes:

```bash
# For all platforms
docker-compose up -d
```

This will create:
- A Spark master node accessible on port 8080
- Two Spark worker nodes
- Shared volume for data persistence

### Accessing the Spark Web UI

Once the cluster is running, you can access the Spark Web UI at:

```
http://localhost:8080
```

### Running Spark Jobs

To run a Spark job on the cluster, you can exec into the master container:

```bash
# For macOS/Linux
docker exec -it spark-master bash

# For Windows PowerShell
docker exec -it spark-master bash
```

Then use spark-submit to run your application:

```bash
# Run the included Python example
spark-submit --master spark://spark-master:7077 /opt/bitnami/spark/examples/pyspark_example.py

# Or run your own application
spark-submit --master spark://spark-master:7077 your-application.jar
```

### Running the Example Applications

This repository includes example applications in the `examples/` directory:

```bash
# Copy the example to the container
docker cp examples/pyspark_example.py spark-master:/opt/bitnami/spark/examples/

# Execute into the container and run the example
docker exec -it spark-master bash
spark-submit --master spark://spark-master:7077 /opt/bitnami/spark/examples/pyspark_example.py
```

### Stopping the Cluster

To stop the cluster:

```bash
# For all platforms
docker-compose down
```

## Configuration

You can customize the Spark configuration by modifying the environment variables in the `docker-compose.yml` file. Common configurations include:

```yaml
environment:
  - SPARK_WORKER_MEMORY=2G  # Increase worker memory
  - SPARK_WORKER_CORES=2    # Increase worker cores
  - SPARK_DAEMON_MEMORY=1G  # Memory for Spark daemons
```

## Troubleshooting

### Platform-Specific Issues

#### Apple Silicon (M1/M2/M3)

If you encounter architecture compatibility issues:
```bash
# Explicitly specify the platform
docker build --platform linux/arm64/v8 -t bitnami-root-spark .
```

Or use Rosetta emulation:
```bash
# Build for x86 architecture using emulation
docker build --platform linux/amd64 -t bitnami-root-spark .
```

#### Windows Path Issues

If you encounter path-related issues on Windows, make sure to use proper path formats in PowerShell:
```powershell
docker cp .\examples\pyspark_example.py spark-master:/opt/bitnami/spark/examples/
```

### Common Issues

- **Port conflicts**: If ports 8080, 7077, or 8081-8082 are already in use, modify the port mappings in the `docker-compose.yml` file.
- **Memory issues**: If containers fail to start due to memory constraints, reduce the worker memory in `docker-compose.yml`.
- **Network issues**: If containers can't communicate, try recreating the network with `docker-compose down --volumes` and then `docker-compose up -d`.

## Notes

- This image runs Spark as the root user, which may introduce security concerns in production environments
- For production deployments, consider using the standard non-root Bitnami images with proper configuration

## Performance Tuning

### Resource Allocation

Modify `docker-compose.yml` to allocate appropriate resources based on your host machine:

```yaml
environment:
  - SPARK_WORKER_MEMORY=4G
  - SPARK_WORKER_CORES=2
```

### Volume Mounting

For better performance, especially with large datasets:

```yaml
volumes:
  - ./data:/data:cached  # Improves performance on macOS
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.