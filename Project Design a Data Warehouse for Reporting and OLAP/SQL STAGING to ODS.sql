---------------------------------------------------
--CREATE USER TABLE IN REVIEW AREA
---------------------------------------------------
CREATE TABLE businesses(
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


INSERT INTO businesses(
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
CREATE TABLE users(
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

INSERT INTO users (average_stars,compliment_cool,compliment_cute,compliment_funny,compliment_hot,compliment_list,compliment_more,
compliment_note, compliment_photos,compliment_plain,compliment_profile,compliment_writer,cool,elite, fans,friends, funny,name, review_count, useful,user_id,yelping_since)
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
CREATE TABLE reviews(
    review_id VARCHAR(22) PRIMARY KEY,
    user_id VARCHAR(22),
    business_id VARCHAR(22),
    stars INT,
    date VARCHAR(30),
    text VARCHAR,
    useful INT,
    funny INT,
    cool INT 
);

INSERT INTO reviews(
    business_id,
    cool,
    date,
    funny,
    review_id,
    stars,
    text, 
    useful,
    user_id
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
CREATE TABLE checkins(
    checkin_date VARCHAR,
    business_id VARCHAR(50),
    FOREIGN KEY(business_id) REFERENCES businesses(business_id)
);

INSERT INTO checkins(business_id, checkin_date)
SELECT parse_json($1):business_id,
		parse_json($1):date 
FROM "YELP_DATA_WAREHOUSE"."STAGING".checkin;

---------------------------------------------------
--CREATE TIP TABLE IN STAGING AREA
---------------------------------------------------
CREATE TABLE tips(
   text VARCHAR,
   tip_date VARCHAR(30),
   compliment_count INT,
   business_id VARCHAR(50),
   user_id VARCHAR(22),
   FOREIGN KEY(business_id) REFERENCES businesses(business_id),
   FOREIGN KEY(user_id) REFERENCES users(user_id)
);

INSERT INTO tips(business_id, compliment_count, tip_date, text, user_id) 
SELECT parse_json($1):business_id,
			parse_json($1):compliment_count,
			parse_json($1):date,
			parse_json($1):text,
			parse_json($1):user_id
	FROM "YELP_DATA_WAREHOUSE"."STAGING".tip;


---------------------------------------------------
--CREATE COVID TABLE IN STAGING AREA
---------------------------------------------------
CREATE TABLE covids(
    business_id VARCHAR(50),
    highlights VARCHAR,
    delivery_or_takeout VARIANT,
    grubhub_enabled VARIANT,
    call_to_action_enabled VARIANT,
    request_a_quote_enabled VARIANT,
    covid_banner VARIANT,
    temporary_closed_until VARIANT,
    virtual_services_offered VARIANT,
    FOREIGN KEY (business_id) REFERENCES businesses(business_id)
);

INSERT INTO covids(Call_To_Action_enabled,Covid_Banner,Grubhub_enabled,Request_a_Quote_Enabled, Temporary_Closed_Until,
Virtual_Services_Offered,business_id,delivery_or_takeout,highlights)
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
CREATE TABLE temperatures(
   date_t DATE PRIMARY KEY,
   min_temp FLOAT,
   max_temp FLOAT,
   normal_min_temp FLOAT,
   normal_max_temp FLOAT
);

INSERT INTO temperatures(date_t, min_temp, max_temp, normal_min_temp, normal_max_temp)
SELECT TO_DATE("date", 'YYYYMMDD'),
min,
max,
normal_min,
normal_max 
FROM "YELP_DATA_WAREHOUSE"."STAGING".temperature;


---------------------------------------------------
--CREATE PRECIPITATION TABLE IN STAGING AREA
---------------------------------------------------
CREATE TABLE precipitations(
    date_p DATE PRIMARY KEY,
    precipitation VARCHAR(10),
    precipitation_normal FLOAT
);

INSERT INTO precipitations(date_p, precipitation, precipitation_normal)
SELECT 
TO_DATE("date",'YYYYMMDD'), 
precipitation, 
precipitation_normal 
FROM "YELP_DATA_WAREHOUSE"."STAGING".precipitation;

    