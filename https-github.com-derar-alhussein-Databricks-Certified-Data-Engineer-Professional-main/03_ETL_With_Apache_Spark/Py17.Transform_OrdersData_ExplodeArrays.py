# Databricks notebook source
# MAGIC %md
# MAGIC ## Transform Orders Data - Explode Arrays
# MAGIC 1. Access elements from the JSON object
# MAGIC 1. Deduplicate Array Elements
# MAGIC 1. Explode Arrays
# MAGIC 1. Write the Transformed Data to Silver Schema

# COMMAND ----------

df_orders_json=spark.table('gizmobox.silver.py_orders_json')
df_orders_json.display()

# COMMAND ----------

# MAGIC %md
# MAGIC ### 1. Access elements from the JSON object
# MAGIC `<column_name.object>`

# COMMAND ----------


df_orders_normalized=(
    df_orders_json.select(
        "json_value.customer_id",
        "json_value.order_date",
        "json_value.order_id",
        "json_value.order_status",
        "json_value.payment_method",
        "json_value.total_amount",
        "json_value.total_amount",
        "json_value.transaction_timestamp",
        "json_value.items"
    )
)
df_orders_normalized.display()

# COMMAND ----------

# MAGIC %md
# MAGIC ### 2. Deduplicate Array Elements
# MAGIC Function [array_distinct](https://learn.microsoft.com/en-us/azure/databricks/sql/language-manual/functions/array_distinct)

# COMMAND ----------

import pyspark.sql.functions as F

df_orders_normalized=(
    df_orders_json.select(
        "json_value.customer_id",
        "json_value.order_date",
        "json_value.order_id",
        "json_value.order_status",
        "json_value.payment_method",
        "json_value.total_amount",
        "json_value.transaction_timestamp",
        F.array_distinct("json_value.items").alias('items')
    )
)
df_orders_normalized.display()


# COMMAND ----------

# MAGIC %md 
# MAGIC ### 3. Explode Arrays
# MAGIC Function [explode](https://learn.microsoft.com/en-us/azure/databricks/sql/language-manual/functions/explode)

# COMMAND ----------

df_orders_exploded=(
    df_orders_normalized.select(
        "customer_id",
        "order_id",
        "order_date",
        "order_status",
        "payment_method",
        "total_amount",
        "transaction_timestamp",
        F.explode("items").alias('item')
    )
)
df_orders_exploded.display()

# COMMAND ----------

df_orderd_items=(
    df_orders_exploded.select(
        "customer_id",
        "order_id",
        "order_date",
        "order_status",
        "payment_method",
        "total_amount",
        "transaction_timestamp",
        "item.item_id",
        "item.price",
        "item.quantity",
        "item.category",
        "item.details.brand",
        "item.details.color"

    )
)
df_orderd_items.display()

# COMMAND ----------



# COMMAND ----------

# MAGIC %md
# MAGIC ### 4. Write the Transformed Data to Silver Schema

# COMMAND ----------

df_orderd_items.writeTo('gizmobox.silver.py_orders').createOrReplace();

# COMMAND ----------

# MAGIC %sql
# MAGIC Select * from gizmobox.silver.py_orders
# MAGIC order by order_id
# MAGIC ;

# COMMAND ----------

