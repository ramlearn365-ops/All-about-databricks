# Databricks notebook source
# MAGIC %md
# MAGIC ## Join Customer and Address
# MAGIC Join customer data with address data to create a customer_address table which contains the address of each customer on the same record

# COMMAND ----------

df_customers=spark.read.table('gizmobox.silver.py_customers')
df_customers.display()

# COMMAND ----------

df_addresses=spark.read.table('gizmobox.silver.py_addressess')
df_addresses.display()

# COMMAND ----------

df_customer_addresses = (
    df_customers.alias("c")
    .join(
        df_addresses.alias("a"),
        "customer_id",
        "inner"
    )
    .select(
        "c.customer_id",
        "c.customer_name",
        "c.email",
        "c.date_of_birth",
        "c.member_since",
        "c.telephone",
        "a.shipping_address_line1",
        "a.shipping_city",
        "a.shipping_state",
        "a.shipping_postcode",
        "a.billing_address_line1",
        "a.billing_city",
        "a.billing_state",
        "a.billing_postcode"
    )
)
display(df_customer_addresses)

# COMMAND ----------

df_customer_addresses.writeTo('gizmobox.gold.py_customer_addresses').createOrReplace();

# COMMAND ----------

# MAGIC %sql
# MAGIC Select * from gizmobox.gold.py_customer_addresses;

# COMMAND ----------

