--FORECAST
CREATE OR REPLACE VIEW v1 AS SELECT date, sales
  FROM sales_data WHERE store_id=1 AND item='jacket';
SELECT * FROM v1;


CREATE or replace SNOWFLAKE.ML.FORECAST model1(
  INPUT_DATA => TABLE(v1),
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales'
);

call model1!FORECAST(FORECASTING_PERIODS => 3);




--Anomaly Detection

CREATE OR REPLACE VIEW v_train AS SELECT date, sales
  FROM sales_data WHERE store_id=1 AND item='jacket' AND date < '2020-01-10';

CREATE OR REPLACE VIEW v_test AS SELECT date, sales
  FROM sales_data WHERE store_id=1 AND item='jacket' AND date >= '2020-01-10';

CREATE OR REPLACE SNOWFLAKE.ML.ANOMALY_DETECTION basic_model(
  INPUT_DATA => TABLE(v_train),
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales',
  LABEL_COLNAME => '');

CALL basic_model!DETECT_ANOMALIES(
  INPUT_DATA => TABLE(v_test),
  TIMESTAMP_COLNAME =>'date',
  TARGET_COLNAME => 'sales'
);




--Classification

CREATE OR REPLACE TABLE training_purchase_data AS (
    SELECT
        CAST(UNIFORM(0, 4, RANDOM()) AS VARCHAR) AS user_interest_score,
        UNIFORM(0, 3, RANDOM()) AS user_rating,
        FALSE AS label,
        'not_interested' AS class
    FROM TABLE(GENERATOR(rowCount => 100))
    UNION ALL
    SELECT
        CAST(UNIFORM(4, 7, RANDOM()) AS VARCHAR) AS user_interest_score,
        UNIFORM(3, 7, RANDOM()) AS user_rating,
        FALSE AS label,
        'add_to_wishlist' AS class
    FROM TABLE(GENERATOR(rowCount => 100))
    UNION ALL
    SELECT
        CAST(UNIFORM(7, 10, RANDOM()) AS VARCHAR) AS user_interest_score,
        UNIFORM(7, 10, RANDOM()) AS user_rating,
        TRUE AS label,
        'purchase' AS class
    FROM TABLE(GENERATOR(rowCount => 100))
);

CREATE OR REPLACE table prediction_purchase_data AS (
    SELECT
        CAST(UNIFORM(0, 4, RANDOM()) AS VARCHAR) AS user_interest_score,
        UNIFORM(0, 3, RANDOM()) AS user_rating
    FROM TABLE(GENERATOR(rowCount => 100))
    UNION ALL
    SELECT
        CAST(UNIFORM(4, 7, RANDOM()) AS VARCHAR) AS user_interest_score,
        UNIFORM(3, 7, RANDOM()) AS user_rating
    FROM TABLE(GENERATOR(rowCount => 100))
    UNION ALL
    SELECT
        CAST(UNIFORM(7, 10, RANDOM()) AS VARCHAR) AS user_interest_score,
        UNIFORM(7, 10, RANDOM()) AS user_rating
    FROM TABLE(GENERATOR(rowCount => 100))
);

CREATE OR REPLACE view binary_classification_view AS
    SELECT user_interest_score, user_rating, label
FROM training_purchase_data;
SELECT * FROM binary_classification_view ORDER BY RANDOM(42) LIMIT 5;

CREATE OR REPLACE SNOWFLAKE.ML.CLASSIFICATION model_binary(
    INPUT_DATA => SYSTEM$REFERENCE('view', 'binary_classification_view'),
    TARGET_COLNAME => 'label'
);

SELECT model_binary!PREDICT(INPUT_DATA => {*})
    AS prediction FROM prediction_purchase_data;





  --Top Insights

  CREATE OR REPLACE TABLE vertical_input_table(
  region VARCHAR, industry VARCHAR, num_employee NUMBER, credits FLOAT);

INSERT INTO vertical_input_table
  SELECT
    'USA' as region,
    ['technology', 'finance', 'healthcare', 'consumer'][MOD(ABS(RANDOM()), 4)] as industry,
    UNIFORM(100, 10000, RANDOM()) as num_employee,
    UNIFORM(1000, 3000, RANDOM()) AS credits,
  FROM TABLE(GENERATOR(ROWCOUNT => 450));

INSERT INTO vertical_input_table
  SELECT
    'EMEA' as region,
    ['technology', 'finance', 'healthcare', 'consumer'][MOD(ABS(RANDOM()), 4)] as industry,
    UNIFORM(100, 10000, RANDOM()) as num_employee,
    UNIFORM(100, 5000, RANDOM()) AS credits,
  FROM TABLE(GENERATOR(ROWCOUNT => 350));

  CREATE OR REPLACE VIEW vertical_input_view AS (
    SELECT
        credits,
        industry,
        num_employee,
        region = 'EMEA' AS label
    FROM vertical_input_table
);


CREATE OR REPLACE SNOWFLAKE.ML.TOP_INSIGHTS my_insights_model();

CALL my_insights_model!get_drivers(
  INPUT_DATA => TABLE(vertical_input_view),
  LABEL_COLNAME => 'label',
  METRIC_COLNAME => 'credits'
);