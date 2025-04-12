---------------------------------------------------
--CREATE USER TABLE IN ODS AREA
---------------------------------------------------
CREATE TABLE DIM_BUSINESS(
   business_key VARCHAR(50) PRIMARY KEY,
   business_name VARCHAR(200),
   business_address VARCHAR(200),
   business_city VARCHAR(100),
   business_state VARCHAR(100),
   business_postal_code VARCHAR(30),
   business_latitude FLOAT,
   business_longitude FLOAT,
   business_stars FLOAT,
   business_review_count DECIMAL(18,3),
   business_is_open INT,
   business_attributes VARIANT,
   business_categories VARCHAR,
   business_hours VARIANT
);

INSERT INTO DIM_BUSINESS(
    business_key,
    business_name, 
    business_address, 
    business_city,
    business_state,
    business_postal_code,
    business_latitude, 
    business_longitude, 
    business_stars,
    business_review_count, 
    business_is_open,
    business_attributes,
    business_categories,
    business_hours)
SELECT business_id,
    name, 
    address, 
    city,
    state,
    postal_code,
    latitude, 
    longitude, 
    stars,
    review_count, 
    is_open,
    attributes,
    categories,
    hours
FROM "YELP_DATA_WAREHOUSE"."ODS".businesses;

---------------------------------------------------
--CREATE REVIEW TABLE  IN ODS AREA
---------------------------------------------------
CREATE TABLE DIM_REVIEW(
    review_key VARCHAR(22) PRIMARY KEY,
    review_stars INT,
    review_date VARCHAR(30),
    review_text VARCHAR,
    review_useful INT,
    review_funny INT,
    review_cool INT 
);

INSERT INTO DIM_REVIEW(
    review_cool,
    review_date,
    review_funny,
    review_key,
    review_stars,
    review_text, 
    review_useful
) 
SELECT 
    cool,
    date,
    funny,
    review_id,
    stars,
    text, 
    useful
FROM "YELP_DATA_WAREHOUSE"."ODS".reviews;

---------------------------------------------------
--CREATE USER TABLE IN ODS AREA
---------------------------------------------------
CREATE TABLE DIM_USER(
    user_key VARCHAR(22) PRIMARY KEY,
    user_name VARCHAR(60),
    user_review_count INT,
    user_yelping_since VARCHAR(30),
    user_friends VARCHAR,
    user_useful INT,
    user_funny INT,
    user_cool INT,
    user_fans INT,
    user_elite VARCHAR,
    user_average_stars DECIMAL(18,3),
    user_compliment_hot INT,
    user_compliment_more INT,
    user_compliment_profile INT,
    user_compliment_cute INT,
    user_compliment_list INT,
    user_compliment_note INT,
    user_compliment_plain INT,
    user_compliment_funny INT,
    user_compliment_cool INT,
    user_compliment_writer INT,
    user_compliment_photos INT
); 

INSERT INTO DIM_USER(
    user_average_stars,
    user_compliment_cool,
    user_compliment_cute,
    user_compliment_funny,
    user_compliment_hot,
    user_compliment_list,
    user_compliment_more,
    user_compliment_note,
    user_compliment_photos,
    user_compliment_plain,
    user_compliment_profile,
    user_compliment_writer,
    user_cool, user_elite, user_fans, user_friends, 
    user_funny, user_name,
    user_review_count, user_useful,
    user_key, user_yelping_since
)
SELECT 
    average_stars,
    compliment_cool,
    compliment_cute,
    compliment_funny,
    compliment_hot,
    compliment_list,
    compliment_more,
    compliment_note, 
    compliment_photos,
    compliment_plain,
    compliment_profile,
    compliment_writer,
    cool, elite, 
    fans, friends,
    funny, name,
    review_count,
    useful, user_id, 
    yelping_since
FROM "YELP_DATA_WAREHOUSE"."ODS".users;

---------------------------------------------------
--CREATE CHECKIN TABLE IN ODS AREA
---------------------------------------------------
CREATE TABLE DIM_CHECKIN(
    checkin_business_id VARCHAR(22),
    checkin_date VARCHAR
);

INSERT INTO DIM_CHECKIN(checkin_business_id, checkin_date)
SELECT business_id, checkin_date
FROM "YELP_DATA_WAREHOUSE"."ODS".checkins;

---------------------------------------------------
--CREATE TIP TABLE IN ODS AREA
---------------------------------------------------
CREATE TABLE DIM_TIP(
   tip_text VARCHAR,
   tip_date VARCHAR(30) PRIMARY KEY,
   tip_compliment_count INT,
   tip_business_id VARCHAR(22),
   tip_user_id VARCHAR(22)
);

INSERT INTO DIM_TIP(tip_business_id, tip_compliment_count, tip_date, tip_text, tip_user_id) 
SELECT business_id, compliment_count, tip_date, text, user_id
FROM "YELP_DATA_WAREHOUSE"."ODS".tips;

---------------------------------------------------
--CREATE COVID TABLE IN ODS AREA
---------------------------------------------------
CREATE TABLE DIM_COVID(
    covid_business_id VARCHAR(22),
    covid_highlights VARCHAR,
    covid_delivery_or_takeout VARIANT,
    covid_grubhub_enabled VARIANT,
    covid_call_to_action_enabled VARIANT,
    covid_request_a_quote_enabled VARIANT,
    covid_covid_banner VARIANT,
    covid_temporary_closed_until VARIANT,
    covid_virtual_services_offered VARIANT
);

INSERT INTO DIM_COVID(covid_call_to_action_enabled,
    covid_covid_banner,
    covid_grubhub_enabled,
    covid_request_a_quote_enabled, 
    covid_temporary_closed_until,
    covid_virtual_services_offered,
    covid_business_id,
    covid_delivery_or_takeout,
    covid_highlights)

SELECT 
      Call_To_Action_enabled,
      Covid_Banner,
      Grubhub_enabled,
      Request_a_Quote_Enabled, 
      Temporary_Closed_Until,
      Virtual_Services_Offered,
      business_id,
      delivery_or_takeout,
      highlights 
FROM "YELP_DATA_WAREHOUSE"."ODS".covids;

---------------------------------------------------
--CREATE TEMPERATURE TABLE IN ODS AREA
---------------------------------------------------
CREATE TABLE DIM_CLIMATE(
   climate_date DATE PRIMARY KEY,
   climate_min_temp FLOAT,
   climate_max_temp FLOAT,
   climate_normal_min_temp FLOAT,
   climate_normal_max_temp FLOAT,
   climate_precipitation VARCHAR(10),
   climate_precipitation_normal FLOAT
);

INSERT INTO DIM_CLIMATE (
         climate_date, 
         climate_min_temp, 
         climate_max_temp, 
         climate_normal_min_temp,
         climate_normal_max_temp,
         climate_precipitation,
         climate_precipitation_normal
         )
SELECT 
         temp.date_t, 
         temp.min_temp, 
         temp.max_temp, 
         temp.normal_min_temp,
         temp.normal_max_temp,
         prep.precipitation,
         prep.precipitation_normal
FROM "YELP_DATA_WAREHOUSE"."ODS".temperatures AS temp
JOIN "YELP_DATA_WAREHOUSE"."ODS".precipitations AS prep
ON temp.date_t = prep.date_p;

---------------------------------------------------
--CREATE FACT TABLE TABLE IN DWH AREA
---------------------------------------------------
create table FACT_TABLE(
   fact_business_id VARCHAR(50),
   fact_review_id VARCHAR(22),
   fact_user_id VARCHAR(22),
   fact_climate_date DATE,
   FOREIGN KEY (fact_business_id) REFERENCES dim_business(business_key),
   FOREIGN KEY (fact_review_id) REFERENCES dim_review(review_key),
   FOREIGN KEY (fact_user_id) REFERENCES dim_user(user_key),
   FOREIGN KEY (fact_climate_date) REFERENCES dim_climate(climate_date)
);

INSERT INTO FACT_TABLE(
    fact_business_id,
    fact_user_id,
    fact_review_id,
    fact_climate_date  
)
SELECT 
    rev.review_id,
    usr.user_id, 
    bus.business_id, 
    rev.date
FROM "YELP_DATA_WAREHOUSE"."ODS".reviews AS rev
JOIN "YELP_DATA_WAREHOUSE"."ODS".businesses AS bus
ON bus.business_id  = rev.business_id
JOIN "YELP_DATA_WAREHOUSE"."ODS".users AS usr
ON rev.user_id = usr.user_id;
