# Databricks notebook source
# MAGIC %md
# MAGIC ## Transform Orders Data - String to JSON
# MAGIC 1. Pre-process the JSON String to fix the Data Quality Issues
# MAGIC 1. Transform JSON String to JSON Object
# MAGIC 1. Write transformed data to the silver schema

# COMMAND ----------


df_orders=spark.table('gizmobox.bronze.py_orders')
df_orders.display()

# COMMAND ----------

# MAGIC %md
# MAGIC ### 1. Pre-process the JSON String to fix the Data Quality Issues
# MAGIC [regexp_replace function](https://learn.microsoft.com/en-us/azure/databricks/sql/language-manual/functions/regexp_replace)

# COMMAND ----------

from pyspark.sql import functions as F

df_fixed_orders=(
    df_orders.select(
        F.regexp_replace("value",'"order_date": (\\d{4}-\\d{2}-\\d{2})','"order_date": "$1"').alias('fixed_value')
    )
)
df_fixed_orders.display();

# COMMAND ----------

# MAGIC %md
# MAGIC ### 2. Transform JSON String to JSON Object
# MAGIC - Function [schema_of_json](https://learn.microsoft.com/en-us/azure/databricks/sql/language-manual/functions/schema_of_json)
# MAGIC - Function [from_json](https://learn.microsoft.com/en-us/azure/databricks/sql/language-manual/functions/from_json)

# COMMAND ----------

#get the schema

df_with_schema=(
    df_fixed_orders.select(
        F.schema_of_json(F.col('Fixed_value')).alias('schema')
        )
)
display(df_with_schema.limit(1));

# COMMAND ----------

orders_schema='''STRUCT<customer_id: BIGINT, items: ARRAY<STRUCT<category: STRING, details: STRUCT<brand: STRING, color: STRING>, item_id: BIGINT, name: STRING, price: BIGINT, quantity: BIGINT>>, order_date: STRING, order_id: BIGINT, order_status: STRING, payment_method: STRING, total_amount: BIGINT, transaction_timestamp: STRING>'''

# COMMAND ----------

df_json_orders=(
    df_fixed_orders.select(
        F.from_json(F.col('fixed_value'),orders_schema).alias('json_value')
    )
)
df_json_orders.display()

# COMMAND ----------

# MAGIC %sql
# MAGIC Select  
# MAGIC schema_of_json(fixed_value) as schema,
# MAGIC fixed_value
# MAGIC from tv_orders_fixed
# MAGIC LIMIT 1;

# COMMAND ----------

# MAGIC %md
# MAGIC ### 3. Write transformed data to the silver schema

# COMMAND ----------

df_json_orders.writeTo('gizmobox.silver.py_orders_json').createOrReplace()

# COMMAND ----------

# MAGIC %sql
# MAGIC Select * from gizmobox.silver.py_orders_json;

# COMMAND ----------

