----------------------------------------------------------------------------------------------------------
--  CSV
----------------------------------------------------------------------------------------------------------

--Creating csv file format
CREATE FILE FORMAT "YELP_DATA_WAREHOUSE"."STAGING".MYCSVFILEFORMAT TYPE = 'CSV' COMPRESSION = 'AUTO' FIELD_DELIMITER = ',' RECORD_DELIMITER = '\n' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = 'NONE' TRIM_SPACE = FALSE ERROR_ON_COLUMN_COUNT_MISMATCH = TRUE ESCAPE = 'NONE' ESCAPE_UNENCLOSED_FIELD = '\134' DATE_FORMAT = 'AUTO' TIMESTAMP_FORMAT = 'AUTO' NULL_IF = ('\\N');

--Creating csv a staging area
create or replace stage my_csv_stage file_format = mycsvfileformat;
--Put the file from local to the staging area
PUT file:///Users/mugwe/Videos/Data_Warehouse/Data/precipitation.csv @my_csv_stage auto_compress = true;
PUT file:///Users/mugwe/Videos/Data_Warehouse/Data/temperature.csv @my_csv_stage auto_compress = true;


-- Creating tempreature and precipitation table 
CREATE TABLE temperature_staging(
   temp_date DATE PRIMARY KEY,
   min_temperature FLOAT,
   max_temperature FLOAT,
   normal_min_temperature FLOAT,
   normal_max_temperature FLOAT
);

CREATE TABLE precipitation_staging(
    precip_date DATE PRIMARY KEY,
    precip_amount VARCHAR(10),
    normal_precip FLOAT
);
-- Copy data from the staging area to the table
copy into temperature_staging @my_csv_stage/temperature.csv.gz file_format = mycsvformat ON_ERROR = 'CONTINUE' PURGE = TRUE;
copy into precipitation_staging @my_csv_stage/precipitation.csv.gz file_format = mycsvformat ON_ERROR = 'CONTINUE' PURGE = TRUE;

----------------------------------------------------------------------------------------------------------
-- JSON
----------------------------------------------------------------------------------------------------------

--Create a simple file format
create or replace file format myjsonformat type = 'JSON' compression = 'auto' field_delimiter = ',' record_delimiter = '\n' skip_header = 1 error_on_column_count_mismatch = true null_if = ('NULL', 'null') empty_field_as_null = true;
-- Creating the Staging Area, which is a temporary holding area for data.
create or replace stage my_json_stage file_format = myjsonformat;

-- Uploading data from local computer to the Staging Area
put file:///Users/mugwe/Videos/Data_Warehouse/Data/tip.json @my_json_stage auto_compress = true;

put file:///Users/mugwe/Videos/Data_Warehouse/Data/review.json @my_json_stage auto_compress = true;

put file:///Users/mugwe/Videos/Data_Warehouse/Data/user.json @my_json_stage auto_compress = true;

put file:///Users/mugwe/Videos/Data_Warehouse/Data/checkin.json @my_json_stage auto_compress = true;

put file:///Users /mugwe/Videos /Data_Warehouse/Data / covid.json @my_json_stage auto_compress = true;

put file:///Users/mugwe/Videos/Data_Warehouse/Data/business.json @my_json_stage auto_compress = true;

-- Finally coping the data from staging area into the table
copy into business_staging
from @my_json_stage/business.json.gz file_format = myjsonformat on_error = 'skip_file';

copy into tip_staging
from
  @my_json_stage/tip.json.gz file_format = myjsonformat on_error = 'skip_file';

copy into covid_staging
from @my_json_stage/covid.json.gz file_format = myjsonformat on_error = 'skip_file';

copy into checkin_staging
from @my_json_stage/checkin.json.gz file_format = myjsonformat on_error = 'skip_file';

copy into review_staging
from @my_json_stage/review.json.gz file_format = myjsonformat on_error = 'skip_file';

copy into user_staging
from @my_json_stage/user.json.gz file_format = myjsonformat on_error = 'skip_file';
