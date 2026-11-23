# Databricks notebook source
# MAGIC %md
# MAGIC ## Transform Refunds Data
# MAGIC 1. Extract specific portion of the string from refund_reason using split function
# MAGIC 1. Extract specific portion of the string from refund_reason using regexp_extract function
# MAGIC 1. Extract date and time from the refund_timestamp
# MAGIC 1. Write transformed data to the Silver schema in hive metastore [Default Location: /user/hive/warehouse]

# COMMAND ----------

df_refunds=spark.read.table('gizmobox.bronze.py_refunds')
df_refunds.display();

# COMMAND ----------

# MAGIC %sql
# MAGIC select
# MAGIC refund_id,
# MAGIC payment_id,
# MAGIC refund_timestamp,
# MAGIC refund_amount,
# MAGIC refund_reason
# MAGIC from hive_metastore.bronze.refunds;

# COMMAND ----------

# MAGIC %md
# MAGIC ### 1. Extract specific portion of the string from refund_reason using split function
# MAGIC > [Documentation for split Function](https://learn.microsoft.com/en-us/azure/databricks/sql/language-manual/functions/split)

# COMMAND ----------

from pyspark.sql import functions as F
df_split_refunds=(
            df_refunds.select("refund_id",
                      "payment_id",
                      F.date_format("refund_timestamp",'yyyy-MM-dd').cast('date').alias('refund_date'),
                      F.date_format("refund_timestamp",'HH:mm:ss').alias('refund_time'),
                      "refund_amount",
                      F.split("refund_reason",":")[0].alias('refund_reason'),
                      F.split("refund_reason",":")[1].alias('refund_soure')
            )
               
)

df_refunds.display();

# COMMAND ----------

# MAGIC %md
# MAGIC ### 2. Extract specific portion of the string from refund_reason using regexp_extract function
# MAGIC > [Documentation for regexp_extract Function](https://learn.microsoft.com/en-us/azure/databricks/sql/language-manual/functions/regexp_extract)  
# MAGIC > [Regex Pattern](https://docs.oracle.com/javase/7/docs/api/java/util/regex/Pattern.html)

# COMMAND ----------

from pyspark.sql import functions as F
df_transformed_refunds=(
            df_refunds.select("refund_id",
                      "payment_id",
                      F.date_format("refund_timestamp",'yyyy-MM-dd').cast('date').alias('refund_date'),
                      F.date_format("refund_timestamp",'HH:mm:ss').alias('refund_time'),
                      "refund_amount",
                      F.regexp_extract('refund_reason', '^([^:]+):', 1).alias('refund_reason'),
                      F.regexp_extract('refund_reason', '^[^:]+:(.*)$', 1).alias('refund_soure')
            )
               
)

df_transformed_refunds.display();

# COMMAND ----------

# MAGIC %md
# MAGIC ### 3. Write transformed data to the Silver schema  

# COMMAND ----------

df_transformed_refunds.writeTo('gizmobox.silver.py_refunds').createOrReplace();

# COMMAND ----------

# MAGIC %sql
# MAGIC Select * from gizmobox.silver.py_refunds;

# COMMAND ----------

# MAGIC %sql
# MAGIC DESC EXTENDED gizmobox.silver.py_refunds;

# COMMAND ----------

