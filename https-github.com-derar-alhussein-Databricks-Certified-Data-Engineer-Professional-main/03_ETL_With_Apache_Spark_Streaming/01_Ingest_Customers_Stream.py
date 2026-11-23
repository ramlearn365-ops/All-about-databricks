# Databricks notebook source
# MAGIC %md
# MAGIC ## Stream Customers Data From Cloud Files to Delta Lake
# MAGIC 1. Read files from cloud storage using DataStreamReader API
# MAGIC 1. Transform the dataframe to add the following columns
# MAGIC     -   file path: Cloud file path
# MAGIC     -   ingestion date: Current Timestamp
# MAGIC 1. Write the transformed data stream to Delta Lake Table

# COMMAND ----------

# MAGIC %md
# MAGIC ### 1. Read files from cloud storage using DataStreamReader API

# COMMAND ----------

from pyspark.sql.types import *

customer_schema = StructType([
  StructField('customer_id', LongType(), True),
  StructField('customer_name',StringType(), True),
  StructField('date_of_birth', DateType(), True),
  StructField('telephone', StringType(), True),
  StructField('email', StringType(), True),
  StructField('member_since', DateType(), True),
  StructField('created_timestamp', TimestampType(), True)])

  

# COMMAND ----------

df_customers=(spark.readStream.format('json')
                .schema(customer_schema)
                .load('/Volumes/gizmobox/landing/operational_data/customers_stream/')
)
df_customers.display()

# COMMAND ----------

# MAGIC %md
# MAGIC ### 2. Transform the dataframe to add the following columns
# MAGIC     -   file path: Cloud file path
# MAGIC     -   ingestion date: Current Timestamp

# COMMAND ----------

from pyspark.sql.functions import *
df_trasform_customers=(df_customers.withColumn('file_path',col('_metadata.file_path'))
                                  .withColumn('ingestion_date',current_timestamp())
                                  )
df_trasform_customers.display()                                 

# COMMAND ----------

streaming_query=(
    df_trasform_customers.writeStream.format('delta')
                            .option('checkpointLocation','/Volumes/gizmobox/landing/operational_data/customers_stream/_checkpoint_stream')
                            # .trigger(once=True)
                            .trigger(availableNow=True)
                            .toTable('gizmobox.bronze.customers_stream')
                            
)


# COMMAND ----------

# MAGIC %sql
# MAGIC Select * from gizmobox.bronze.customers_stream;