-- Databricks notebook source
-- MAGIC %md
-- MAGIC ## Extract Data From the Returns SQL Table
-- MAGIC 1. Create Bronze Schema in Hive Metastore
-- MAGIC 1. Create External Table

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 1. Create Bronze Schema in Hive Metastore

-- COMMAND ----------

CREATE SCHEMA IF NOT EXISTS hive_metastore.bronze;


-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 2.Create External Table

-- COMMAND ----------

CREATE EXTERNAL TABLE IF NOT EXISTS hive_metastore.bronze.refunds
USING JDBC
OPTIONS (
  url 'jdbc:sqlserver://gizmoserver21.database.windows.net:1433;database=gizmoboxdb',
  dbtable 'refunds',
  user 'Rashmiadmin',
  password 'Admin@123'
);  


-- COMMAND ----------

COPY INTO hive_metastore.bronze.refunds
FROM 'jdbc:sqlserver://gizmoserver21.database.windows.net:1433;database=gizmoboxdb'
WITH (
  dbtable = 'refunds',
  user = 'Rashmiadmin',
  password = 'Admin@123'
)
FILEFORMAT = PARQUET

-- COMMAND ----------

-- MAGIC %python
-- MAGIC df = spark.read.format("jdbc").options(
-- MAGIC     url="jdbc:sqlserver://gizmoserver21.database.windows.net:1433;database=gizmoboxdb",
-- MAGIC     dbtable="refunds",
-- MAGIC     user="Rashmiadmin",
-- MAGIC     password="Admin@123"
-- MAGIC ).load()
-- MAGIC
-- MAGIC # Write to Delta table in the hive_metastore.bronze.refunds location
-- MAGIC df.write.format("delta").mode("overwrite").saveAsTable("hive_metastore.bronze.refunds")

-- COMMAND ----------

Select * from hive_metastore.bronze.refunds;

-- COMMAND ----------

DESCRIBE EXTENDED hive_metastore.bronze.refunds;

-- COMMAND ----------

