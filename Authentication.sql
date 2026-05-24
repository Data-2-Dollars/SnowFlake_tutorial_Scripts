use role securityadmin;

create or replace role auth_test_role;

create or REPLACE user tutorial_user
PASSWORD='123'
DEFAULT_ROLE=auth_test_role;



grant role auth_test_role to user tutorial_user;

use role ACCOUNTADMIN;

create or replace authentication policy tutorial_limit_policy
AUTHENTICATION_METHODS = ('PASSWORD')
CLIENT_TYPES=('SNOWFLAKE_UI')
COMMENT='POLICYABC';

ALTER USER TUTORIAL_USER SET AUTHENTICATION POLICY tutorial_limit_policy;


DESC USER TUTORIAL_USER;

SHOW AUTHENTICATION policies;


