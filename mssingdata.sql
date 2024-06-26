CREATE OR REPLACE PROCEDURE `mssingdata.null_count_analysis`(IN table_id STRING)
BEGIN
  DECLARE query STRING;

  -- Construct the dynamic SQL query
  SET query = CONCAT(
    'SELECT col_name, ',
    'COUNT(1) AS nulls_count, ',
    'ROUND(100 * (COUNT(1) / (SELECT COUNT(*) FROM `', table_id, '`)), 2) AS percent_nulls ',
    'FROM `', table_id, '` t, ',
    'UNNEST(REGEXP_EXTRACT_ALL(TO_JSON_STRING(t), r"\\"(\\w+)\\":null")) col_name ',
    'GROUP BY col_name ',
    'ORDER BY nulls_count DESC'
  );

  -- Execute the dynamic SQL query
  EXECUTE IMMEDIATE query;
END;

-- Call the Function:

CALL `mssingdata.null_count_analysis`('data-to-insights.ecommerce.web_analytics');

