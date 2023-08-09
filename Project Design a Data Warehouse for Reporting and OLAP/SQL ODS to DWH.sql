---------------------------------------------------
--CREATE USER TABLE IN ODS AREA
---------------------------------------------------
CREATE TABLE DIM_BUSINESS(
   business_id VARCHAR(50) PRIMARY KEY,
   name VARCHAR(200),
   address VARCHAR(200),
   city VARCHAR(100),
   state VARCHAR(100),
   postal_code VARCHAR(30),
   latitude FLOAT,
   longitude FLOAT,
   stars FLOAT,
   review_count DECIMAL(18,3),
   is_open INT,
   attributes VARIANT,
   categories VARCHAR,
   hours VARIANT
);


INSERT INTO DIM_BUSINESS(
    business_id,
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
    hours)
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
    review_id VARCHAR(22) PRIMARY KEY,
    stars INT,
    date VARCHAR(30),
    text VARCHAR,
    useful INT,
    funny INT,
    cool INT 
);

INSERT INTO DIM_REVIEW(
    cool,
    date,
    funny,
    review_id,
    stars,
    text, 
    useful
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
    user_id VARCHAR(22) PRIMARY KEY,
    name VARCHAR(60),
    review_count INT,
    yelping_since VARCHAR(30),
    friends VARCHAR,
    useful INT,
    funny INT,
    cool INT,
    fans INT,
    elite VARCHAR,
    average_stars DECIMAL(18,3),
    compliment_hot INT,
    compliment_more INT,
    compliment_profile INT,
    compliment_cute INT,
    compliment_list INT,
    compliment_note INT,
    compliment_plain INT,
    compliment_funny INT,
    compliment_cool INT,
    compliment_writer INT,
    compliment_photos INT
); 

INSERT INTO DIM_USER(
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
    cool,elite, fans,friends, 
    funny,name,
    review_count, useful,
    user_id,yelping_since
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
    cool,elite, 
    fans,friends,
    funny,name,
    review_count,
    useful,user_id, 
    yelping_since
FROM "YELP_DATA_WAREHOUSE"."ODS".users;

---------------------------------------------------
--CREATE CHECKIN TABLE IN ODS AREA
---------------------------------------------------
CREATE TABLE DIM_CHECKIN(
    business_id VARCHAR(22),
    date VARCHAR
);

INSERT INTO DIM_CHECKIN(business_id, date)
SELECT business_id, checkin_date
FROM "YELP_DATA_WAREHOUSE"."ODS".checkins;
---------------------------------------------------
--CREATE TIP TABLE IN ODS AREA
---------------------------------------------------
CREATE TABLE DIM_TIP(
   text VARCHAR,
   date VARCHAR(30) PRIMARY KEY,
   compliment_count INT,
   business_id VARCHAR(22),
   user_id VARCHAR(22)
);

INSERT INTO DIM_TIP(business_id, compliment_count, date, text, user_id) 
SELECT business_id, compliment_count, tip_date, text, user_id
FROM "YELP_DATA_WAREHOUSE"."ODS".tips;
---------------------------------------------------
--CREATE COVID TABLE IN ODS AREA
---------------------------------------------------
CREATE TABLE DIM_COVID(
    business_id VARCHAR(22),
    highlights VARCHAR,
    delivery_or_takeout VARIANT,
    grubhub_enabled VARIANT,
    call_to_action_enabled VARIANT,
    request_a_quote_enabled VARIANT,
    covid_banner VARIANT,
    temporary_closed_until VARIANT,
    virtual_services_offered VARIANT
);

INSERT INTO DIM_COVID(Call_To_Action_enabled,
    Covid_Banner,
    Grubhub_enabled,
    Request_a_Quote_Enabled, 
    Temporary_Closed_Until,
    Virtual_Services_Offered,
    business_id,
    delivery_or_takeout,
    highlights)

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
   min_temp FLOAT,
   max_temp FLOAT,
   normal_min_temp FLOAT,
   normal_max_temp FLOAT,
   precipitation VARCHAR(10),
   precipitation_normal FLOAT
);

INSERT INTO DIM_CLIMATE (
         climate_date, 
         min_temp, 
         max_temp, 
         normal_min_temp,
         normal_max_temp,
         precipitation,
         precipitation_normal
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
   business_id VARCHAR(50),
   review_id VARCHAR(22),
   user_id VARCHAR(22),
   climate_date DATE,
   FOREIGN KEY (business_id) REFERENCES dim_business(business_id),
   FOREIGN KEY (review_id) REFERENCES dim_review(review_id),
   FOREIGN KEY (user_id) REFERENCES dim_user(user_id),
   FOREIGN KEY (climate_date) REFERENCES dim_climate(climate_date)
);
INSERT INTO fact_table(
    business_id,
    user_id,
    review_id,
    climate_date  
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






   