# Databricks notebook source
# MAGIC %md
# MAGIC ## Extract Data From the Payments Files
# MAGIC 1. Read Payments File
# MAGIC 1. Create Payments Table in Bronze Schema

# COMMAND ----------

# MAGIC %md
# MAGIC ### 1.List the files from Payment folder

# COMMAND ----------

# MAGIC %fs ls 'abfss://gizmobox@storageacctdatabricks21.dfs.core.windows.net/landing/external_data/payments'

# COMMAND ----------

df=spark.read.format('csv').load('abfss://gizmobox@storageacctdatabricks21.dfs.core.windows.net/landing/external_data/payments')
display(df)

# COMMAND ----------

payments_schema='payment_id INTEGER,order_id INTEGER,payment_timestamp TIMESTAMP,payment_status INTEGER,payment_method STRING'

# COMMAND ----------

from pyspark.sql.types import StructType,StructField,StringType,IntegerType,TimestampType

payments_schema=StructType([
    StructField('payment_id',IntegerType(),True),
    StructField('order_id',IntegerType(),True),
    StructField('payment_timestamp',TimestampType(),True),
    StructField('payment_status',IntegerType(),True),
    StructField('payment_method',StringType(),True)
])


# COMMAND ----------

# MAGIC %md
# MAGIC ### 1. Read Payments File

# COMMAND ----------

df=(spark.read.format('csv')
            .schema(payments_schema)
            .option('delimiter',',')
            .load('abfss://gizmobox@storageacctdatabricks21.dfs.core.windows.net/landing/external_data/payments')
)
display(df)

# COMMAND ----------

# MAGIC %md
# MAGIC ### 2. Create Payments Table in Bronze Schema

# COMMAND ----------

df.writeTo('gizmobox.bronze.py_payments').createOrReplace();

# COMMAND ----------

# MAGIC %sql
# MAGIC Select * from gizmobox.bronze.py_payments;

# COMMAND ----------

# MAGIC %sql
# MAGIC DESC EXTENDED gizmobox.bronze.py_payments;

# COMMAND ----------

