-- Databricks notebook source
-- MAGIC %md
-- MAGIC ## Transform Customer Data
-- MAGIC 1. Remove records with NULL customer_id 
-- MAGIC 1. Remove exact duplicate records
-- MAGIC 1. Remove duplicate records based on created_timestamp
-- MAGIC 1. CAST the columns to the correct Data Type
-- MAGIC 1. Write transformed data to the Silver schema

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 1.Remove records with NULL customer_id 

-- COMMAND ----------

SELECT * FROM gizmobox.bronze.v_customers
WHERE customer_id IS NOT NULL;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 2.Remove exact duplicate records

-- COMMAND ----------

SELECT * FROM gizmobox.bronze.v_customers
WHERE customer_id IS NOT NULL
ORDER BY customer_id;

-- COMMAND ----------

CREATE OR REPLACE TEMP VIEW v_customers_distinct
AS
SELECT DISTINCT * FROM gizmobox.bronze.v_customers
WHERE customer_id IS NOT NULL
ORDER BY customer_id;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 3. Remove duplicate records based on created_timestamp
-- MAGIC

-- COMMAND ----------

Select customer_id,MAX(created_timestamp)
from v_customers_distinct
Group by customer_id

-- COMMAND ----------

WITh CTE_max AS
(
  Select customer_id,MAX(created_timestamp) as created_timestamp
  from v_customers_distinct
  Group by customer_id
) 
SELECT t.* 
FROM v_customers_distinct t
JOIN CTE_max m 
ON t.customer_id=t.customer_id
AND t.created_timestamp=m.created_timestamp
order by t.customer_id;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 4. CAST the column values to the correct data type
-- MAGIC

-- COMMAND ----------

WITh CTE_max AS
(
  Select customer_id,MAX(created_timestamp) as created_timestamp
  from v_customers_distinct
  Group by customer_id
) 
SELECT 
CAST(t.created_timestamp as timestamp) as created_timestamp,
t.customer_id,
t.customer_name,
CAST(t.date_of_birth as date) as date_of_birth,
t.email,
CAST(t.member_since as date) as member_since,
t.telephone
FROM v_customers_distinct t
JOIN CTE_max m 
ON t.customer_id=t.customer_id
AND t.created_timestamp=m.created_timestamp
order by t.customer_id;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 5. Write Data to a Delta Table (CTAS)

-- COMMAND ----------

DROP TABLE IF EXISTS gizmobox.silver.customers;
CREATE TABLE gizmobox.silver.customers
AS
WITh CTE_max AS
(
  Select customer_id,MAX(created_timestamp) as created_timestamp
  from v_customers_distinct
  Group by customer_id
) 
SELECT 
CAST(t.created_timestamp as timestamp) as created_timestamp,
t.customer_id,
t.customer_name,
CAST(t.date_of_birth as date) as date_of_birth,
t.email,
CAST(t.member_since as date) as member_since,
t.telephone
FROM v_customers_distinct t
JOIN CTE_max m 
ON t.customer_id=t.customer_id
AND t.created_timestamp=m.created_timestamp
order by t.customer_id;

-- COMMAND ----------

Select * from gizmobox.silver.customers;

-- COMMAND ----------

DESCRIBE EXTENDED gizmobox.silver.customers

-- COMMAND ----------

