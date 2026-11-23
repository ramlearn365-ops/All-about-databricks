from pyspark import pipelines as dp
from pyspark.sql import functions as F

@dp.table(name='bronze_addresses',
          table_properties={'quality' : 'bronze'},
          comment='Raw addresses data ingested from source'
          )

def bronze_addresses():
    df=(
        spark.readStream.format('cloudFiles')
            .option('cloudFiles.format','csv')
            .option('cloudFiles.inferColumnTypes','true')
            .load('/Volumes/circuitbox/landing/operational_data/addresses')
            .select('*',F.col('_metadata.file_path').alias('input_file_path'),F.current_timestamp().alias('ingestion_timestamp'))
    )
    return df


@dp.table(name='silver_addresses_clean',
          comment='Cleaned addresses data',
          table_properties={'quality' : 'silver'}
          )
@dp.expect_or_fail('valid_customer_id','customer_id IS NOT NULL')
@dp.expect_or_drop('valid_address','address_line_1 IS NOT NULL') 
@dp.expect('valid_postcode','length(postcode)=5')          
def create_silver_addresses_clean():
    return (
        spark.readStream.table("LIVE.bronze_addresses")
            .select(
                "customer_id",
                "address_line_1",
                "city",
                "state",
                "postcode",
                F.col("created_date").cast("date")
            )
    )

dp.create_streaming_table(name='silver_addresses',
                           table_properties={'quality' : 'silver'},
                           comment='SCD Type  addresses data')

dp.apply_changes(
    target='silver_addresses',
    source='silver_addresses_clean',
    keys=['customer_id'],
    sequence_by='created_date',
    stored_as_scd_type=2
)

