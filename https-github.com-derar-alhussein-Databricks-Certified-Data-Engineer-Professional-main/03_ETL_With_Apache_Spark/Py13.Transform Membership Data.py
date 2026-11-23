# Databricks notebook source
# MAGIC %md
# MAGIC ## Transform Memberships Data
# MAGIC 1. Extract customer_id from the file path 
# MAGIC 1. Write transformed data to the Silver schema  

# COMMAND ----------

# MAGIC %md
# MAGIC ### 1. Extract customer_id from the file path
# MAGIC > [Documentation for regexp_extract Function](https://learn.microsoft.com/en-us/azure/databricks/sql/language-manual/functions/regexp_extract)  
# MAGIC > [Documentation for Regex Pattern](https://docs.oracle.com/javase/7/docs/api/java/util/regex/Pattern.html)
# MAGIC

# COMMAND ----------

df_memberships=spark.read.table('gizmobox.bronze.py_memberships')
df_memberships.display()

# COMMAND ----------

from pyspark.sql import functions as F

df_extract_memberships=(
    df_memberships.select(
        F.regexp_extract('path','.*/([0-9]+)\\.png$', 1).alias('customer_id'),
        F.col("content").alias('membership_card')
    )
)
df_extract_memberships.display()

# COMMAND ----------

# MAGIC
# MAGIC %md
# MAGIC ### 2. Write transformed data to the Silver schema 
# MAGIC

# COMMAND ----------

df_extract_memberships.writeTo('gizmobox.silver.py_memberships').createOrReplace();

# COMMAND ----------

# MAGIC %sql
# MAGIC Select * from gizmobox.silver.py_memberships;

# COMMAND ----------

# MAGIC %sql
# MAGIC SELECT * FROM gizmobox.silver.memberships;

# COMMAND ----------

# MAGIC %sql
# MAGIC   