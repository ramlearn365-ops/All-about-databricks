-- Databricks notebook source
-- MAGIC %md
-- MAGIC ## Monthly Order Summary
-- MAGIC For each of the customer, produce the following summary per month
-- MAGIC 1. total orders
-- MAGIC 1. total items bought
-- MAGIC 1. total amount spent

-- COMMAND ----------

Select * from gizmobox.silver.orders
where customer_id='5011';

-- COMMAND ----------

Select 
date_format(transaction_timestamp,'yyyy-MM') as order_month,
customer_id,
count(distinct order_id) as total_orders,
sum(quantity) as total_items_bought,
sum(price*quantity) as total_amount
FROM gizmobox.silver.orders 
Group by order_month,customer_id
order by order_month,customer_id

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS gizmobox.gold.orders_monthly_summary
AS
Select 
date_format(transaction_timestamp,'yyyy-MM') as order_month,
customer_id,
count(distinct order_id) as total_orders,
sum(quantity) as total_items_bought,
sum(price*quantity) as total_amount
FROM gizmobox.silver.orders 
Group by order_month,customer_id
order by order_month,customer_id

-- COMMAND ----------

SELECT * FROM gizmobox.gold.orders_monthly_summary;

-- COMMAND ----------

