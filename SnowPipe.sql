create or replace storage integration s3_snowpipe_int
TYPE=EXTERNAL_STAGE
STORAGE_PROVIDER='S3'
ENABLED=TRUE
STORAGE_AWS_ROLE_ARN='arn:aws:iam::0123456789:role/Snowflake_S3_Role'
STORAGE_ALLOWED_LOCATIONS=('s3://snowpipe-demo-2026/');

desc integration s3_snowpipe_int;


CREATE OR REPLACE FILE FORMAT my_csv_format
  TYPE = 'CSV'
  FIELD_DELIMITER = ','
  SKIP_HEADER = 1
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  NULL_IF = ('NULL', 'null')
  EMPTY_FIELD_AS_NULL = TRUE;

  CREATE OR REPLACE TABLE emp_data (
    emp_id INT,
    first_name STRING,
    last_name STRING,
    department STRING,
    salary FLOAT
);


CREATE OR REPLACE STAGE my_s3_stage
  URL = 's3://snowpipe-demo-2026/'
  STORAGE_INTEGRATION = s3_snowpipe_int;


  CREATE OR REPLACE PIPE MY_CSV_SNOWPIPE
  AUTO_INGEST=TRUE
  AS
  COPY INTO EMP_DATA
  FROM @MY_S3_STAGE 
  FILE_FORMAT =(FORMAT_NAME='MY_CSV_FORMAT');


  SHOW PIPES;

  select * from emp_data;