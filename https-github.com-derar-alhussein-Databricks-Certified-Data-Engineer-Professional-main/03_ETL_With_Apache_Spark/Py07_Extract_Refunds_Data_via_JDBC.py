# Databricks notebook source
# MAGIC %md
# MAGIC ## Extract Data From the Returns SQL Table
# MAGIC 1. Read Refunds Data via JDBC
# MAGIC 2. Create Refunds Table in Bronze Schema

# COMMAND ----------

# MAGIC %md
# MAGIC ### 1. Read Refunds Data via JDBC

# COMMAND ----------

df=(spark.read.format('jdbc')
    .option('url','jdbc:sqlserver://gizmoserver21.database.windows.net:1433;database=gizmoboxdb')
    .option('dbtable','refunds')
    .option('user','Rashmiadmin')
    .option('password','Admin@123')
    .load()
)
display(df)

# COMMAND ----------

df=spark.read.table('hive_metastore.bronze.refunds')
display(df)

# COMMAND ----------

# MAGIC %md
# MAGIC ### 2. Create Refunds Table in Bronze Schema

# COMMAND ----------

df.writeTo('gizmobox.bronze.py_refunds').createOrReplace();

# COMMAND ----------

# MAGIC %sql
# MAGIC Select * from gizmobox.bronze.py_refunds;

# COMMAND ----------

# MAGIC %sql
# MAGIC DESCRIBE EXTENDED gizmobox.bronze.py_refunds;

# COMMAND ----------

