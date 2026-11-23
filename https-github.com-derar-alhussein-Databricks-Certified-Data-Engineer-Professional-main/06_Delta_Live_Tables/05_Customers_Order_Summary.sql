-- Databricks notebook source
-- MAGIC %md
-- MAGIC ## Create Customer Order Summary
-- MAGIC 1. Join the tables Silver_Customers, Silver_addresses and Silver_Orders
-- MAGIC 1. Retrieve the latest Address of the Customer 
-- MAGIC 1. Calculate the following values
-- MAGIC     - total_orders
-- MAGIC     - total_items_ordered
-- MAGIC     - total_order_amount

-- COMMAND ----------

Select * from circuitbox.lakehouse.gold_customers_order_summary order by customer_id;