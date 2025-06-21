import org.apache.spark.sql.SparkSession

object SimpleApp {
  def main(args: Array[String]): Unit = {
    val spark = SparkSession.builder()
      .appName("Simple Application")
      .getOrCreate()
    
    import spark.implicits._
    
    // Create some sample data
    val data = Seq(1, 2, 3, 4, 5)
    val df = data.toDF("value")
    
    // Show the data
    println("Sample data:")
    df.show()
    
    // Perform a simple transformation
    val result = df.select($"value", ($"value" * 2).as("doubled"))
    
    println("Transformed data:")
    result.show()
    
    spark.stop()
  }
}
