from pyspark.sql import SparkSession

# Initialize Spark session
spark = SparkSession.builder \
    .appName("PySpark Example") \
    .getOrCreate()

# Create some sample data
data = [("Alice", 34), ("Bob", 45), ("Charlie", 29), ("Diana", 37)]
columns = ["Name", "Age"]

# Create a DataFrame
df = spark.createDataFrame(data, columns)

# Show the data
print("Sample data:")
df.show()

# Perform a simple transformation
print("People older than 30:")
df.filter(df.Age > 30).show()

# Calculate some statistics
print("Age statistics:")
df.select("Age").describe().show()

# Stop the Spark session
spark.stop()
