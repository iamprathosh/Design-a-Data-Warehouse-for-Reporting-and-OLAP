---------------------------------------------------
--CREATE USER TABLE IN REVIEW AREA
---------------------------------------------------
CREATE TABLE business_data(
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

INSERT INTO business_data(
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
SELECT parse_json($1):business_id,
       parse_json($1):name,
       parse_json($1):address,
       parse_json($1):city,
       parse_json($1):state,
       parse_json($1):postal_code,
       parse_json($1):latitude,
       parse_json($1):longitude,
       parse_json($1):stars,
       parse_json($1):review_count,
       parse_json($1):is_open,
       parse_json($1):attributes,
       parse_json($1):categories,
       parse_json($1):hours
FROM "YELP_DATA_WAREHOUSE"."STAGING".business;

---------------------------------------------------
--CREATE USER TABLE IN STAGING AREA
---------------------------------------------------
CREATE TABLE user_data(
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

INSERT INTO user_data (user_average_stars,user_compliment_cool,user_compliment_cute,user_compliment_funny,user_compliment_hot,user_compliment_list,user_compliment_more,
user_compliment_note, user_compliment_photos,user_compliment_plain,user_compliment_profile,user_compliment_writer,user_cool,user_elite, user_fans,user_friends, user_funny,user_name, user_review_count, user_useful,user_key,user_yelping_since)
SELECT parse_json($1):average_stars,
	parse_json($1):compliment_cool,
	parse_json($1):compliment_cute,
	parse_json($1):compliment_funny,
	parse_json($1):compliment_hot,
	parse_json($1):compliment_list,
	parse_json($1):compliment_more,
	parse_json($1):compliment_note,
	parse_json($1):compliment_photos,
	parse_json($1):compliment_plain,
	parse_json($1):compliment_profile,
	parse_json($1):compliment_writer,
	parse_json($1):cool,
	parse_json($1):elite, 
	parse_json($1):fans,
	parse_json($1):friends, 
	parse_json($1):funny,
	parse_json($1):name, 
	parse_json($1):review_count, 
	parse_json($1):useful,
	parse_json($1):user_id,
	parse_json($1):yelping_since
	FROM "YELP_DATA_WAREHOUSE"."STAGING".user;

---------------------------------------------------
--CREATE REVIEW TABLE STAGING IN  AREA
---------------------------------------------------
CREATE TABLE review_data(
    review_key VARCHAR(22) PRIMARY KEY,
    user_key VARCHAR(22),
    business_key VARCHAR(22),
    review_stars INT,
    review_date VARCHAR(30),
    review_text VARCHAR,
    review_useful INT,
    review_funny INT,
    review_cool INT 
);

INSERT INTO review_data(
    business_key,
    review_cool,
    review_date,
    review_funny,
    review_key,
    review_stars,
    review_text, 
    review_useful,
    user_key
) 
SELECT 
    parse_json($1):business_id, 
	parse_json($1):cool, 
	parse_json($1):date, 
	parse_json($1):funny, 
	parse_json($1):review_id, 
	parse_json($1):stars, 
	parse_json($1):text, 
	parse_json($1):useful, 
	parse_json($1):user_id 
FROM "YELP_DATA_WAREHOUSE"."STAGING".review;

---------------------------------------------------
--CREATE CHECKIN TABLE IN STAGING AREA
---------------------------------------------------
CREATE TABLE checkin_data(
    checkin_date VARCHAR,
    business_key VARCHAR(50),
    FOREIGN KEY(business_key) REFERENCES business_data(business_key)
);

INSERT INTO checkin_data(business_key, checkin_date)
SELECT parse_json($1):business_id,
		parse_json($1):date 
FROM "YELP_DATA_WAREHOUSE"."STAGING".checkin;

---------------------------------------------------
--CREATE TIP TABLE IN STAGING AREA
---------------------------------------------------
CREATE TABLE tip_data(
   tip_text VARCHAR,
   tip_date VARCHAR(30),
   tip_compliment_count INT,
   business_key VARCHAR(50),
   user_key VARCHAR(22),
   FOREIGN KEY(business_key) REFERENCES business_data(business_key),
   FOREIGN KEY(user_key) REFERENCES user_data(user_key)
);

INSERT INTO tip_data(business_key, tip_compliment_count, tip_date, tip_text, user_key) 
SELECT parse_json($1):business_id,
			parse_json($1):compliment_count,
			parse_json($1):date,
			parse_json($1):text,
			parse_json($1):user_id
	FROM "YELP_DATA_WAREHOUSE"."STAGING".tip;

---------------------------------------------------
--CREATE COVID TABLE IN STAGING AREA
---------------------------------------------------
CREATE TABLE covid_data(
    business_key VARCHAR(50),
    covid_highlights VARCHAR,
    covid_delivery_or_takeout VARIANT,
    covid_grubhub_enabled VARIANT,
    covid_call_to_action_enabled VARIANT,
    covid_request_a_quote_enabled VARIANT,
    covid_covid_banner VARIANT,
    covid_temporary_closed_until VARIANT,
    covid_virtual_services_offered VARIANT,
    FOREIGN KEY (business_key) REFERENCES business_data(business_key)
);

INSERT INTO covid_data(covid_call_to_action_enabled,covid_covid_banner,covid_grubhub_enabled,covid_request_a_quote_enabled, covid_temporary_closed_until,
covid_virtual_services_offered,business_key,covid_delivery_or_takeout,covid_highlights)
SELECT 
	parse_json($1):"Call To Action enabled",
	parse_json($1):"Covid Banner",
	parse_json($1):"Grubhub enabled",
	parse_json($1):"Request a Quote Enabled",
	parse_json($1):"Temporary Closed Until",
	parse_json($1):"Virtual Services Offered",
	parse_json($1):"business_id",
	parse_json($1):"delivery or takeout",
	parse_json($1):"highlights" FROM "YELP_DATA_WAREHOUSE"."STAGING".covid;

---------------------------------------------------
--CREATE TEMPERATURE TABLE IN STAGING AREA
---------------------------------------------------
CREATE TABLE temperature_data(
   temp_date DATE PRIMARY KEY,
   min_temperature FLOAT,
   max_temperature FLOAT,
   normal_min_temperature FLOAT,
   normal_max_temperature FLOAT
);

INSERT INTO temperature_data(temp_date, min_temperature, max_temperature, normal_min_temperature, normal_max_temperature)
SELECT TO_DATE("date", 'YYYYMMDD'),
min,
max,
normal_min,
normal_max 
FROM "YELP_DATA_WAREHOUSE"."STAGING".temperature;

---------------------------------------------------
--CREATE PRECIPITATION TABLE IN STAGING AREA
---------------------------------------------------
CREATE TABLE precipitation_data(
    precip_date DATE PRIMARY KEY,
    precip_amount VARCHAR(10),
    normal_precip FLOAT
);

INSERT INTO precipitation_data(precip_date, precip_amount, normal_precip)
SELECT 
TO_DATE("date",'YYYYMMDD'), 
precipitation, 
precipitation_normal 
FROM "YELP_DATA_WAREHOUSE"."STAGING".precipitation;
