# Databricks notebook source
# MAGIC %md
# MAGIC ## Monthly Order Summary
# MAGIC For each of the customer, produce the following summary per month
# MAGIC 1. total orders
# MAGIC 1. total items bought
# MAGIC 1. total amount spent

# COMMAND ----------

df_orders=spark.table('gizmobox.silver.py_orders')
df_orders.display();

# COMMAND ----------

df_mothly_orders_summary=(
    df_orders.withColumn('order_month',F.date_format(F.col('transaction_timestamp'),'yyyy-MM'))
    .groupBy('order_month','customer_id')
    .agg(
        F.countDistinct('customer_id').alias('total_orders'),
        F.sum('quantity').alias('total_items_bought'),
        F.sum(F.col('price')*F.col('quantity')).alias('total_amount')
    )   
)

df_mothly_orders_summary.display()

# COMMAND ----------

df_mothly_orders_summary.writeTo('gizmobox.gold.py_orders_summary_monthly').createOrReplace();

# COMMAND ----------

# MAGIC %sql
# MAGIC SELECT * FROM gizmobox.gold.py_orders_summary_monthly;

# COMMAND ----------

