create or replace api integration my_api_integration_01
api_provider=aws_api_gateway
api_aws_role_arn='arn:aws:iam::123456789:role/Snowflake_Role'
enabled=true
api_allowed_prefixes=('https://tckimfead0.execute-api.us-east-1.amazonaws.com/test');



describe integration my_api_integration_01;


create or replace external function my_external_function(n integer,v varchar)
returns variant
api_integration = my_api_integration_01
as 'https://tckimfead0.execute-api.us-east-1.amazonaws.com/test';

select my_external_function(id,name) from test_date;