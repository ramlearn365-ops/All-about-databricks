-- Databricks notebook source
-- MAGIC %md
-- MAGIC ### Data profiling in Databricks
-- MAGIC 1. Profile Data using UI
-- MAGIC 1. Profile Data using DBUTILS Package (dbutils.data.summarize method)
-- MAGIC 1. Profile Data Manually 
-- MAGIC    - COUNT
-- MAGIC    - COUNT_IF
-- MAGIC    - MIN
-- MAGIC    - MAX
-- MAGIC    - WHERE Clause

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 1. Profile Data using User Interface

-- COMMAND ----------

Select * from gizmobox.bronze.v_customers;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 2. Profile Data using DBUTILS Package (dbutils.data.summarize method)

-- COMMAND ----------

-- MAGIC %python 
-- MAGIC df = spark.table('gizmobox.bronze.v_customers')
-- MAGIC display(df)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 3. Profile Data Manually 

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 3.1 COUNT Function

-- COMMAND ----------

Select Count(*)  ----total records in the tables
,Count(customer_id)  ----total customer ids in the tables
,count(email)
,count(telephone)
from gizmobox.bronze.v_customers;




-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 3.1 COUNT_IF Function

-- COMMAND ----------

Select Count(*)  ----total records in the tables
,count_if(customer_id IS NULL)  ----total customer ids in the tables
,count_if(email IS NULL)
,count_if(telephone IS NULL)
from gizmobox.bronze.v_customers;


-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 3.2 WHERE Clause

-- COMMAND ----------

Select Count(customer_id)
From gizmobox.bronze.v_customers
WHere customer_id IS NULL;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 3.4 DISTINCT Keyword

-- COMMAND ----------

Select count(*) as total_records,count(Distinct customer_id) as unique_records
From gizmobox.bronze.v_customers
Where customer_id is not null;

-- COMMAND ----------

