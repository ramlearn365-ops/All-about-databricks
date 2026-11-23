# Databricks notebook source
# MAGIC %md
# MAGIC ## Transform Payments Data
# MAGIC 1. Extract Date and Time from payment_timestamp and create new columns payment_date and payment_time
# MAGIC 1. Map payment_status to contain descriptive values  
# MAGIC    (1-Success, 2-Pending, 3-Cancelled, 4-Failed)
# MAGIC 1. Write transformed data to the Silver schema 

# COMMAND ----------


df=spark.read.table('gizmobox.bronze.py_payments')
df.display();

# COMMAND ----------

# MAGIC %md
# MAGIC ### 1. Extract Date and Time from payment_timestamp and create new columns payment_date and payment_time

# COMMAND ----------

from pyspark.sql import  functions as F

df_extract_payments=(
    df.select("payment_id",
              "order_id",
              F.date_format("payment_timestamp",'yyyy-MM-dd').cast('date').alias('payemnt_date'),
              F.date_format('payment_timestamp','HH-mm-ss').alias('payment_time'),
              "payment_status",
              "payment_method")
)
df_extract_payments.display();

# COMMAND ----------

# MAGIC %md
# MAGIC ### 2.Map payment_status to contain descriptive values  
# MAGIC   (1-Success, 2-Pending, 3-Cancelled, 4-Failed)

# COMMAND ----------

df_mapped_payments=(
    df_extract_payments.select("payment_id",
                              "order_id",
                              "payemnt_date",
                              "payemnt_time",
                              F.when (df_extract_payments.payment_status==1,'SUCESS' )
                              .when (df_extract_payments.payment_status==2,'PENDING' )
                              .when (df_extract_payments.payment_status==3,'CANCELLED' )
                              .when (df_extract_payments.payment_status==4,'FAILED')
                              .otherwise('UNKNOWN')
                              .alias('payment_status'),
                              "payment_method")
)
df_mapped_payments.display();

# COMMAND ----------

# MAGIC %md
# MAGIC ### 3.Write transformed data to the Silver schema 

# COMMAND ----------

df_mapped_payments.writeTo('gizmobox.silver.py_payments').createOrReplace();

# COMMAND ----------

# MAGIC %sql
# MAGIC Select * from gizmobox.silver.py_payments;

# COMMAND ----------

