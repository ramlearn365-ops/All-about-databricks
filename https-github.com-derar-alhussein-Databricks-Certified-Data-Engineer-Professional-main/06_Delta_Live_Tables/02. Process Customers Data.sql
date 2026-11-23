-- Databricks notebook source
-- MAGIC %md
-- MAGIC ## Process the Customers Data 
-- MAGIC 1. Ingest the data into the data lakehouse - bronze_customers
-- MAGIC 1. Perform data quality checks and transform the data as required - silver_customers_clean
-- MAGIC 1. Apply changes to the Customers data - silver_customers

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 1. Ingest the data into the data lakehouse - bronze_customers

-- COMMAND ----------

CREATE OR REFRESH STREAMING TABLE bronze_customers
COMMENT 'Raw customers data ingested from the source system operational data'
TBLPROPERTIES(quality = 'bronze')
AS
SELECT *,
      _metadata.file_path AS file_path,
      current_timestamp AS ingestion_timestamp
FROM cloud_files('/Volumes/circuitbox/landing/operational_data/customers',
                 'json',
                 'cloudFiles.inferColumnTypes' = true);

-- COMMAND ----------

CREATE OR REFRESH STREAMING TABLE silver_customers_clean(
  CONSTRAINT valid_customer_id EXPECT(customer_id IS NOT NULL) ON VIOLATION FAIL UPDATE,
  CONSTRAINT valid_customer_name EXPECT(customer_name IS NOT NULL) ON VIOLATION DROP ROW,
  CONSTRAINT valid_telephone EXPECT(length(telephone)>10),
  CONSTRAINT valid_email EXPECT(email IS NOT NULL),
  CONSTRAINT valid_date_of_birth EXPECT(date_of_birth>'1920-01-01')
)
COMMENT 'Cleaned customers data'
TBLPROPERTIES('quality'='silver')
AS
SELECT 
customer_id,
customer_name,
CAST(date_of_birth as DATE) as date_of_birth,
telephone,
email,
CAST(created_date as DATE) as created_date
FROM STREAM(LIVE.bronze_customers)



-- COMMAND ----------

Select * from circuitbox.lakehouse.bronze_customers;

-- COMMAND ----------


Select * from circuitbox.lakehouse.silver_customers_clean;

-- COMMAND ----------

CREATE OR REFRESH STREAMING TABLE circuitbox.lakehouse.silver_customers
COMMENT 'SCD TYPE 1 Customers Data'
TBLPROPERTIES('quality'='silver');


APPLY CHANGES INTO LIVE.silver_customers
FROM STREAM(LIVE.silver_customers_clean)
KEYS(customer_id)
SEQUENCE BY created_date
STORED AS SCD TYPE 1;


-- COMMAND ----------

SELECT * from circuitbox.lakehouse.silver_customers ORDER BY customer_id;