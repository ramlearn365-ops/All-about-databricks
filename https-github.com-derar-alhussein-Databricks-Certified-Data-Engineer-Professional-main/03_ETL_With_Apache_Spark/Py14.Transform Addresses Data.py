# Databricks notebook source
# MAGIC %md
# MAGIC ## Transform Addresses Data
# MAGIC 1. Create one record for each customer with 2 sets of address columns, 1 for shipping and 1 for billing address 
# MAGIC 1. Write transformed data to the Silver schema  

# COMMAND ----------

df_address=spark.read.table('gizmobox.bronze.py_addresses');
df_address.display();

# COMMAND ----------

# MAGIC %md
# MAGIC ### 1. Create one record for each customer with both addresses, one for each address_type
# MAGIC > [Documentation for PIVOT clause](https://learn.microsoft.com/en-us/azure/databricks/sql/language-manual/sql-ref-syntax-qry-select-pivot)
# MAGIC

# COMMAND ----------

from pyspark.sql import functions as F

df_pivot_address=(
    df_address.groupBy('customer_id')
    .pivot('address_type',['shipping','billing'])
    .agg(F.max("address_line_1").alias('address_line1'),
         F.max("city").alias('city'),
         F.max("state").alias('state'),
         F.max("postcode").alias('postcode')    
         )
)

df_pivot_address.display()

# COMMAND ----------

# MAGIC %md
# MAGIC ### 2. Write transformed data to the Silver schema 

# COMMAND ----------

df_pivot_address.writeTo('gizmobox.silver.py_addresses').createOrReplace()

# COMMAND ----------

# MAGIC %sql
# MAGIC SELECT * from gizmobox.silver.py_addressess;