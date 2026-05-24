-- STEP-01
USE ROLE ACCOUNTADMIN;
SELECT CURRENT_REGION();

-- STEP-02
-- aws sts get-caller-identity --query Account --output text

-- aws sts get-federation-token --name SnowflakeHandshake

-- STEP-03

-- Replace 123456789012 with your 12-digit AWS ID
-- Replace the 'JSON_HERE' with the full block you copied from AWS
SELECT SYSTEM$AUTHORIZE_PRIVATELINK('AKIAZK337AAUMPO2HSRF', '{
    "Credentials": {
        "AccessKeyId": "",
        "SecretAccessKey": "",
        "SessionToken": "",
        "Expiration": ""
    },
    "FederatedUser": {
        "FederatedUserId": "",
        "Arn": ""
    },
    "PackedPolicySize": 0
}
');


SELECT SYSTEM$GET_PRIVATELINK_CONFIG();


-- The Output: You will see a list of URLs. Look for privatelink-vpce-id. It will look like:
-- com.amazonaws.vpce.us-east-1.vpce-svc-0123456789abcdef


-- Step-04

-- Create the AWS Gateway


--Step-05

-- # Replace with YOUR Endpoint DNS name
-- nslookup vpce-xxx-xxx.vpce-svc-xxx.us-east-1.vpce.amazonaws.com

-- If it returns a Private IP (like 172.31.x.x or 10.x.x.x), the bridge is built!