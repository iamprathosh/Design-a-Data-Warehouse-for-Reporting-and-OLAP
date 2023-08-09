-- SQL to report  business_name, temperature, precipitation, and rating
SELECT 
    DISTINCT bus.name AS business_name,
    clim.max_temp,
    clim.min_temp,
    clim.precipitation,
    bus.stars as rating_stars
FROM FACT_TABLE AS fact
JOIN DIM_BUSINESS AS bus
    ON fact.business_id = bus.business_id
JOIN DIM_CLIMATE AS clim
    ON fact.climate_date  = clim.climate_date;;