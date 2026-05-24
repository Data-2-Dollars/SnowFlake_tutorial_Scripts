-- 1. Create a table to hold your data
CREATE OR REPLACE TABLE streaming_demo (
    id INT,
    username STRING,
    status STRING,
    event_time TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- 2. Switch to ACCOUNTADMIN for the next part
USE ROLE ACCOUNTADMIN;

-- 3. Get your Public Key Ready (We will paste this in Step 2)
-- Leave this window open!

ALTER USER KUNAL SET RSA_PUBLIC_KEY='kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk';

SELECT CURRENT_ORGANIZATION_NAME() || '-' || CURRENT_ACCOUNT_NAME();

SELECT CURRENT_USER();

