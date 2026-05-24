-- 1. Setup context
USE ROLE ACCOUNTADMIN;
CREATE OR REPLACE WAREHOUSE sharing_wh WITH WAREHOUSE_SIZE = 'XSMALL' AUTO_SUSPEND = 60;

-- 2. Create the data objects to be shared
CREATE OR REPLACE DATABASE source_db;
CREATE OR REPLACE SCHEMA source_db.internal_data;

CREATE OR REPLACE TABLE source_db.internal_data.shared_metrics (
    id INT,
    metric_name STRING,
    value FLOAT,
    ts TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

INSERT INTO source_db.internal_data.shared_metrics (id, metric_name, value)
VALUES (1, 'Active Users', 450.5), (2, 'Revenue', 12000.75);

-- 3. Create the Share object
CREATE OR REPLACE SHARE finance_share;

-- 4. Grant permissions to the Share
-- Note: You must grant usage on Database, Schema, and specific Tables/Views
GRANT USAGE ON DATABASE source_db TO SHARE finance_share;
GRANT USAGE ON SCHEMA source_db.internal_data TO SHARE finance_share;
GRANT SELECT ON TABLE source_db.internal_data.shared_metrics TO SHARE finance_share;

-- 5. Add the consumer account to the share
-- Replace 'ORGNAME' and 'ACCTNAME' with the target account's identifiers
ALTER SHARE finance_share ADD ACCOUNTS = ORGNAME.ACCTNAME;



/*=============================================
===============================================
=============================================*/


-- 1. Setup context
USE ROLE ACCOUNTADMIN;

-- 2. List available shares to confirm visibility
SHOW SHARES;

-- 3. Create a local database from the share
-- Replace 'ORGNAME.PROVIDER_ACCT' with the provider's actual account path
CREATE OR REPLACE DATABASE shared_finance_db FROM SHARE ORGNAME.PROVIDER_ACCT.finance_share;

-- 4. Grant access to local roles (e.g., ANALYST)
CREATE ROLE IF NOT EXISTS analyst_role;
GRANT USAGE ON DATABASE shared_finance_db TO ROLE analyst_role;
GRANT USAGE ON SCHEMA shared_finance_db.internal_data TO ROLE analyst_role;
GRANT SELECT ON ALL TABLES IN SCHEMA shared_finance_db.internal_data TO ROLE analyst_role;

-- 5. Query the live data
USE ROLE analyst_role;
SELECT * FROM shared_finance_db.internal_data.shared_metrics;