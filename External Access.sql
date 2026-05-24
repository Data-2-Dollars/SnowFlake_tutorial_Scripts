USE ROLE ACCOUNTADMIN;

-- Step 1: Create the security integration (required before creating the secret)
CREATE OR REPLACE SECURITY INTEGRATION google_translate_oauth
  TYPE = API_AUTHENTICATION
  AUTH_TYPE = OAUTH2
  OAUTH_CLIENT_ID = 'my-client-id'
  OAUTH_CLIENT_SECRET = 'my-client-secret'
  OAUTH_TOKEN_ENDPOINT = 'https://oauth2.googleapis.com/token'
  OAUTH_AUTHORIZATION_ENDPOINT = 'https://accounts.google.com/o/oauth2/auth'
  OAUTH_ALLOWED_SCOPES = ('https://www.googleapis.com/auth/cloud-platform')
  ENABLED = TRUE;



-- Step 2: Create the secret referencing the security integration
CREATE OR REPLACE SECRET oauth_token
  TYPE = OAUTH2
  API_AUTHENTICATION = google_translate_oauth
  OAUTH_REFRESH_TOKEN = 'my-refresh-token';




USE ROLE USERADMIN;
CREATE OR REPLACE ROLE developer;





USE ROLE SECURITYADMIN;
GRANT READ ON SECRET oauth_token TO ROLE developer;





USE ROLE ACCOUNTADMIN;
CREATE OR REPLACE NETWORK RULE google_apis_network_rule
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = ('translation.googleapis.com');





CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION google_apis_access_integration
  ALLOWED_NETWORK_RULES = (google_apis_network_rule)
  ALLOWED_AUTHENTICATION_SECRETS = (oauth_token)
  ENABLED = true;






  GRANT USAGE ON INTEGRATION google_apis_access_integration TO ROLE developer;

  USE ROLE developer;




CREATE OR REPLACE FUNCTION google_translate_python(sentence STRING, language STRING)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = 3.10
HANDLER = 'get_translation'
EXTERNAL_ACCESS_INTEGRATIONS = (google_apis_access_integration)
PACKAGES = ('snowflake-snowpark-python','requests')
SECRETS = ('cred' = oauth_token )
AS
$$
import _snowflake
import requests
import json
session = requests.Session()
def get_translation(sentence, language):
  token = _snowflake.get_oauth_access_token('cred')
  url = "https://translation.googleapis.com/language/translate/v2"
  data = {'q': sentence,'target': language}
  response = session.post(url, json = data, headers = {"Authorization": "Bearer " + token})
  return response.json()['data']['translations'][0]['translatedText']
$$;

GRANT USAGE ON FUNCTION google_translate_python(string, string) TO ROLE user;





USE ROLE user;
SELECT google_translate_python('Happy Thursday!', 'zh-CN');


/*
| GOOGLE_TRANSLATE_PYTHON('HAPPY THURSDAY!', 'ZH-CN') |
-------------------------------------------------------
| 快乐星期四！                                          |
-------------------------------------------------------
*/

