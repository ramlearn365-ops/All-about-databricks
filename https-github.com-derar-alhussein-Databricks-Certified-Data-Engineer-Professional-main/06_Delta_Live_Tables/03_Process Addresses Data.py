# Databricks notebook source
# MAGIC %md
# MAGIC ## Process Addresses Data 
# MAGIC 1. Ingest the data into the data lakehouse - bronze_addresses
# MAGIC 1. Perform data quality checks and transform the data as required - silver_addresses_clean
# MAGIC 1. Apply changes to the Addresses data (SCD Type 2) - silver_addresses

# COMMAND ----------

# MAGIC %sql
# MAGIC Select * from circuitbox.lakehouse.bronze_addresses order by customer_id;

# COMMAND ----------

# MAGIC %sql
# MAGIC Select * from circuitbox.lakehouse.silver_addresses order by customer_id;