FROM bitnami/spark:latest

USER root

# Allow running as root user
ENV ALLOW_DAEMON_USER_ROOT=true

# Set environment variables
ENV SPARK_HOME=/opt/bitnami/spark
ENV PATH=$SPARK_HOME/bin:$PATH

# Additional configuration to ensure root can run everything
RUN chmod -R g+rwX /opt/bitnami

# Expose Spark Web UI port
EXPOSE 8080

# Expose Spark master port
EXPOSE 7077

# Expose Spark driver port
EXPOSE 4040

# Expose worker ports
EXPOSE 8081 8082

# Set the working directory
WORKDIR $SPARK_HOME

# Command to run when the container starts
CMD ["bash", "-c", "spark-class org.apache.spark.deploy.master.Master"]
