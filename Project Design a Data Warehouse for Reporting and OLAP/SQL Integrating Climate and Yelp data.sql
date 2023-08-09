--SQL queries code to integrate climate and Yelp Data


SELECT prep.date_p AS precipitation_date,
       prep.precipitation,
       prep.precipitation_normal,
       temp.date_t AS date_temperature,
       temp.min_temp,
       temp.max_temp,
       temp.normal_max_temp,
       temp.normal_min_temp,
       rev.review_id,
       rev.date AS review_date,
       rev.stars AS review_stars,
       rev.text AS review_text,
       rev.cool AS reveiw_cool,
       rev.useful AS review_useful,
       rev.funny AS review_funny,
       tip.compliment_count,
       tip.text AS tip_text,
       tip.date AS tip_date,
       bus.business_id,
       bus.address,
       bus.name AS business_name,
       bus.categories,
       bus.city,
       bus.postal_code,
       bus.review_count AS business_review_count,
       bus.attributes,
       bus.is_open,
       bus.state,
       bus.hours,
       bus.latitude,
       bus.longitude,
       bus.stars AS business_stars ,
       cov.highlights,
       cov.delivery_or_takeout,
       cov.grubhub_enabled,
       cov.call_to_action_enabled,
       cov.request_a_quote_enabled,
       cov.covid_banner,
       cov.temporary_closed_until,
       cov.virtual_services_offered,
       u.user_id,
       u.name AS user_name,
       u.review_count AS user_review_count,
       u.yelping_since,
       u.friends,
       u.useful AS user_useful,
       u.funny AS user_funny,
       u.cool AS user_cool,
       u.fans,
       u.elite,
       u.average_stars AS user_average_stars,
       u.compliment_hot,
       u.compliment_more,
       u.compliment_profile,
       u.compliment_cute,
       u.compliment_list,
       u.average_stars,
       u.compliment_plain,
       u.compliment_funny,
       u.compliment_cool,
       u.compliment_writer,
       u.compliment_photos
       
	FROM precipitations AS prep
	JOIN reviews AS rev 
	ON rev.date = prep.date_p
	JOIN temperatures AS temp
	ON temp.date_t = rev.date
	JOIN businesses AS bus
	ON bus.business_id = rev.business_id
    JOIN covids AS cov
	ON bus.business_id = cov.business_id
	JOIN checkins AS ch
	ON bus.business_id = ch.business_id
	JOIN tips AS tip
	ON bus.business_id = tip.business_id
    JOIN users AS u
    ON u.user_id = rev.user_id;

	