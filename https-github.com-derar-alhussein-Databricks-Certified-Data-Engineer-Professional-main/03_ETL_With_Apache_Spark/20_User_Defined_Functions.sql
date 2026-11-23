-- Databricks notebook source
-- MAGIC %md
-- MAGIC ## User Defined Functions (UDF)
-- MAGIC
-- MAGIC   > - User Defined Functions (UDF) in Spark are custom functions created by users to extend the capabilities of Spark SQL and PySpark. 
-- MAGIC   > - UDFs allow us to perform calculations or transformations to apply business logic that are not possible with built-in functions
-- MAGIC   > - You define the function once and use it accross multiple queries.
-- MAGIC   > - SQL UDFs are recommended over Python UDFs due to better optimization

-- COMMAND ----------

CREATE OR REPLACE FUNCTION gizmobox.default.get_fullname(firstname STRING,surname STRING)
RETURNS STRING
RETURN concat(initcap(firstname),' ',initcap(surname));

-- COMMAND ----------

Select gizmobox.default.get_fullname('Rashmi','Banakar');

-- COMMAND ----------

DESC FUNCTION EXTENDED gizmobox.default.get_fullname;

-- COMMAND ----------

CREATE OR REPLACE FUNCTION gizmobox.default.get_payment_status(payment_status INT)
RETURNS STRING
RETURN CASE payment_status 
      WHEN 1 THEN 'SUCCESS'
      WHEN 2 THEN 'PENDING'
      WHEN 3 THEN 'CANCELLED'
      WHEN 4 THEN 'FAILED'
      END ;

-- COMMAND ----------

Select 
payment_id,
order_id,
CAST(date_format(payment_timestamp,'yyyy-MM-dd')as date) as payment_date,
date_format(payment_timestamp,'HH:mm:ss') as payment_time,
gizmobox.default.get_payment_status(payment_status) as payment_status,
payment_method 
from gizmobox.bronze.payments;