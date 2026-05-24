-- Create a specific folder in your S3 bucket for exports
-- Make sure the 'unloads/' folder exists in your S3 bucket!
CREATE OR REPLACE STAGE my_unload_stage
  URL = 's3://snowpipe-demo-2026/unloads/'
  STORAGE_INTEGRATION = s3_snowpipe_int;

-- This will create a file named exactly 'user_report.csv' in S3
COPY INTO @my_unload_stage/final_test/user_report.csv
FROM raw_data
FILE_FORMAT = (TYPE = 'CSV' COMPRESSION = NONE)
SINGLE = TRUE
OVERWRITE = TRUE;

SELECT SYSTEM$ALLOWLIST();


Select * from ANALYST_DB.PUBLIC.SALES_DATA