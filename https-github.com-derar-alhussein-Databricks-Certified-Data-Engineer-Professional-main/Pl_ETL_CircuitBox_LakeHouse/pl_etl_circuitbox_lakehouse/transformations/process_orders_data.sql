CREATE OR REFRESH STREAMING TABLE bronze_orders
COMMENT 'Raw orders data ingested'
TBLPROPERTIES(quality='bronze')
AS
SELECT *,
_metadata.file_path AS input_file_path,
current_timestamp() as Ingestion_timestamp
FROM cloud_files('/Volumes/circuitbox/landing/operational_data/orders/','json',
                  map('cloudFiles.inferColumnTypes','true'));

CREATE OR REFRESH STREAMING TABLE silver_orders_clean(
CONSTRAINT valid_customer_id EXPECT(customer_id IS NOT NULL) ON VIOLATION FAIL UPDATE,
CONSTRAINT valid_order_id EXPECT(order_id IS NOT NULL) ON VIOLATION FAIL UPDATE,
CONSTRAINT valid_order_status EXPECT(order_status IN ('pending','shipped','cancelled','completed')),
CONSTRAINT valid_payment_method EXPECT(payment_method IN ('credit_card','bank transfer','paypal'))
)
COMMENT 'Clean orders data'
TBLPROPERTIES(quality='silver')
AS
Select 
order_id,
customer_id,
items,
order_status,
CAST(order_timestamp as TIMESTAMP) as order_timestamp,
payment_method
from STREAM(LIVE.bronze_orders);

CREATE STREAMING TABLE silver_orders
AS
SELECT 
  order_id,
  customer_id,
  order_timestamp,
  order_status,
  payment_method,
  item.item_id,
  item.name,
  item.category,
  item.price,
  item.quantity
FROM 
  (SELECT 
  order_id,
  customer_id,
  order_timestamp,
  order_status,
  payment_method,
  explode(items) AS item
  FROM STREAM(LIVE.silver_orders_clean)
);
