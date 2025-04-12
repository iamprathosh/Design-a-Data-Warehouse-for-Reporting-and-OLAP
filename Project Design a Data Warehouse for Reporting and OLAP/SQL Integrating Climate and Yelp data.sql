--SQL queries code to integrate climate and Yelp Data

SELECT pr.date_p AS precip_date,
       pr.precipitation AS precip_amount,
       pr.precipitation_normal AS normal_precip,
       te.date_t AS temp_date,
       te.min_temp AS min_temperature,
       te.max_temp AS max_temperature,
       te.normal_max_temp AS normal_max_temperature,
       te.normal_min_temp AS normal_min_temperature,
       rv.review_id AS review_identifier,
       rv.date AS review_date,
       rv.stars AS review_rating,
       rv.text AS review_text,
       rv.cool AS review_cool,
       rv.useful AS review_useful,
       rv.funny AS review_funny,
       tp.compliment_count AS tip_compliments,
       tp.text AS tip_text,
       tp.date AS tip_date,
       bs.business_id AS business_identifier,
       bs.address AS business_address,
       bs.name AS business_name,
       bs.categories AS business_categories,
       bs.city AS business_city,
       bs.postal_code AS business_postal_code,
       bs.review_count AS business_review_count,
       bs.attributes AS business_attributes,
       bs.is_open AS business_is_open,
       bs.state AS business_state,
       bs.hours AS business_hours,
       bs.latitude AS business_latitude,
       bs.longitude AS business_longitude,
       bs.stars AS business_rating,
       cv.highlights AS covid_highlights,
       cv.delivery_or_takeout AS covid_delivery_or_takeout,
       cv.grubhub_enabled AS covid_grubhub_enabled,
       cv.call_to_action_enabled AS covid_call_to_action_enabled,
       cv.request_a_quote_enabled AS covid_request_a_quote_enabled,
       cv.covid_banner AS covid_banner,
       cv.temporary_closed_until AS covid_temporary_closed_until,
       cv.virtual_services_offered AS covid_virtual_services_offered,
       us.user_id AS user_identifier,
       us.name AS user_name,
       us.review_count AS user_review_count,
       us.yelping_since AS user_yelping_since,
       us.friends AS user_friends,
       us.useful AS user_useful,
       us.funny AS user_funny,
       us.cool AS user_cool,
       us.fans AS user_fans,
       us.elite AS user_elite,
       us.average_stars AS user_average_rating,
       us.compliment_hot AS user_compliment_hot,
       us.compliment_more AS user_compliment_more,
       us.compliment_profile AS user_compliment_profile,
       us.compliment_cute AS user_compliment_cute,
       us.compliment_list AS user_compliment_list,
       us.compliment_plain AS user_compliment_plain,
       us.compliment_funny AS user_compliment_funny,
       us.compliment_cool AS user_compliment_cool,
       us.compliment_writer AS user_compliment_writer,
       us.compliment_photos AS user_compliment_photos
       
FROM precipitations AS pr
JOIN reviews AS rv 
ON rv.date = pr.date_p
JOIN temperatures AS te
ON te.date_t = rv.date
JOIN businesses AS bs
ON bs.business_id = rv.business_id
JOIN covids AS cv
ON bs.business_id = cv.business_id
JOIN checkins AS ch
ON bs.business_id = ch.business_id
JOIN tips AS tp
ON bs.business_id = tp.business_id
JOIN users AS us
ON us.user_id = rv.user_id;
