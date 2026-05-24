
-- 2. Create a File Format that supports Schema Detection
-- This tells Snowflake to look inside the files to find column names
CREATE OR REPLACE FILE FORMAT my_json_format
  TYPE = 'JSON'
  STRIP_OUTER_ARRAY = TRUE;

-- 3. Create an Internal Stage
CREATE OR REPLACE STAGE my_internal_stage
  FILE_FORMAT = my_json_format
   URL = 's3://snowpipe-demo-2026/'
     STORAGE_INTEGRATION = s3_snowpipe_int;


-- This query "peeks" inside the file and returns the table structure
SELECT *
FROM TABLE(
  INFER_SCHEMA(
    LOCATION=>'@my_internal_stage',
    FILE_FORMAT=>'my_json_format'
  )
);

-- Now, Create the table automatically using that detection!
CREATE OR REPLACE TABLE raw_data
  USING TEMPLATE (
    SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
    FROM TABLE(
      INFER_SCHEMA(
        LOCATION=>'@my_internal_stage',
        FILE_FORMAT=>'my_json_format'
      )
    )
  );
Select * from raw_data;
  -- This actually moves the data from S3 into your new table
COPY INTO raw_data
FROM @my_internal_stage
MATCH_BY_COLUMN_NAME = CASE_SENSITIVE;

-- NOW you will see the data!
SELECT * FROM raw_data;


ALTER TABLE raw_data SET ENABLE_SCHEMA_EVOLUTION = TRUE;


-- Even though 'location' doesn't exist in the table yet, this will NOT fail.
COPY INTO raw_data
FROM @my_internal_stage/sample_json_1.json
FILE_FORMAT = (FORMAT_NAME = 'my_json_format')
MATCH_BY_COLUMN_NAME = CASE_SENSITIVE;

-- The "Moment of Truth":
SELECT * FROM raw_data;


     