
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
CREATE TABLE temperature(
   date_t DATE PRIMARY KEY,
   min_temp FLOAT,
   max_temp FLOAT,
   normal_min_temp FLOAT,
   normal_max_temp FLOAT
);

CREATE TABLE precipitation(
    date_p DATE PRIMARY KEY,
    precipitation VARCHAR(10),
    precipitation_normal FLOAT
);
-- Copy data from the staging area to the table
copy into temperature @my_csv_stage/temperature.csv.gz file_format = mycsvformat ON_ERROR = 'CONTINUE' PURGE = TRUE;
copy into precipitation @my_csv_stage/precipitation.csv.gz file_format = mycsvformat ON_ERROR = 'CONTINUE' PURGE = TRUE;

----------------------------------------------------------------------------------------------------------
-- JSON
----------------------------------------------------------------------------------------------------------

--Create a simple file format
create or replace file format mycsvformat type = 'JSON' compression = 'auto' field_delimiter = ',' record_delimiter = '\n' skip_header = 1 error_on_column_count_mismatch = true null_if = ('NULL', 'null') empty_field_as_null = true;
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
copy into business
from @my_json_stage/business.json.gz file_format = myjsonformat on_error = 'skip_file';

copy into tip
from
  @my_json_stage/tip.json.gz file_format = myjsonformat on_error = 'skip_file';

copy into covid
from @my_json_stage/covid.json.gz file_format = myjsonformat on_error = 'skip_file';

copy into checkin
from @my_json_stage/checkin.json.gz file_format = myjsonformat on_error = 'skip_file';

copy into review
from @my_json_stage/review.json.gz file_format = myjsonformat on_error = 'skip_file';

copy into yelp_user
from @my_json_stage/yelp_user.json.gz file_format = myjsonformat on_error = 'skip_file';