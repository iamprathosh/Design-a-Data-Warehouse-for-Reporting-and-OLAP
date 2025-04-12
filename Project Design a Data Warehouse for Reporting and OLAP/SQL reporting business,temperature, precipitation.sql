-- SQL to report business_name, temperature, precipitation, and rating
SELECT 
    DISTINCT b.name AS business_name,
    c.max_temp AS max_temperature,
    c.min_temp AS min_temperature,
    c.precipitation AS precipitation_amount,
    b.stars AS business_rating
FROM FACT_TABLE AS f
JOIN DIM_BUSINESS AS b
    ON f.fact_business_id = b.business_key
JOIN DIM_CLIMATE AS c
    ON f.fact_climate_date = c.climate_date;
