-- Databricks notebook source
-- MAGIC %md
-- MAGIC ## Transform Payments Data
-- MAGIC 1. Extract Date and Time from payment_timestamp and create new columns payment_date and payment_time
-- MAGIC 1. Map payment_status to contain descriptive values  
-- MAGIC    (1-Success, 2-Pending, 3-Cancelled, 4-Failed)
-- MAGIC 1. Write transformed data to the Silver schema 

-- COMMAND ----------

Select 
payment_id,
order_id,
payment_timestamp,
payment_status,
payment_method 
from gizmobox.bronze.payments;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 1. Extract Date and Time from payment_timestamp and create new columns payment_date and payment_time

-- COMMAND ----------

Select 
payment_id,
order_id,
CAST(date_format(payment_timestamp,'yyyy-MM-dd')as date) as payment_date,
date_format(payment_timestamp,'HH:mm:ss') as payment_timyye,
payment_status,
payment_method 
from gizmobox.bronze.payments;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 2.Map payment_status to contain descriptive values  
-- MAGIC   (1-Success, 2-Pending, 3-Cancelled, 4-Failed)

-- COMMAND ----------

Select 
payment_id,
order_id,
CAST(date_format(payment_timestamp,'yyyy-MM-dd')as date) as payment_date,
date_format(payment_timestamp,'HH:mm:ss') as payment_time,
CASE payment_status 
      WHEN 1 THEN 'SUCCESS'
      WHEN 2 THEN 'PENDING'
      WHEN 3 THEN 'CANCELLED'
      WHEN 4 THEN 'FAILED'
      END as payment_status,
payment_method 
from gizmobox.bronze.payments;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 3.Write transformed data to the Silver schema 

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS gizmobox.silver.payments
AS
Select 
payment_id,
order_id,
CAST(date_format(payment_timestamp,'yyyy-MM-dd')as date) as payment_date,
date_format(payment_timestamp,'HH:mm:ss') as payment_time,
CASE payment_status 
      WHEN 1 THEN 'SUCCESS'
      WHEN 2 THEN 'PENDING'
      WHEN 3 THEN 'CANCELLED'
      WHEN 4 THEN 'FAILED'
      END as payment_status,
payment_method 
from gizmobox.bronze.payments;

-- COMMAND ----------

Select * from gizmobox.silver.payments;

-- COMMAND ----------

