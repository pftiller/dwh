SELECT  
to_char(to_date(statistic_dt,
'YYYY-MM-DD'),
'YYYY-MM-DD') AS "date",
source_system_nm AS "platform",
account_nm AS "advertiser",
device_nm AS "device",
campaign_nm AS "campaign",
ad_group_nm AS "ad_group",
ad_group_typ AS "ad_type",
ad_description_txt AS "ad_description",
ad_description_one_txt AS "ad_description_1",
ad_description_two_txt AS "ad_description_2",
ad_headline_txt AS "ad_headline",
ad_headline_part_one_txt AS "ad_headline_1", 
ad_headline_part_two_txt AS "ad_headline_2",
SUM(impression_cnt) AS "impressions",
SUM(click_cnt) AS "clicks",
SUM(video_view_cnt) AS "video_views",
SUM(interaction_cnt) AS "interactions",
SUM(engagement_cnt) AS "engagements",
SUM(conversion_cnt) AS "conversions",
SUM(all_conversion_cnt) AS "total_conversions",
SUM(all_conversion_value_num) AS "conversion_value",
SUM(cost_amt) AS "media_cost"
FROM
vw_search_ad_performance 
WHERE
account_id = 4128563281
GROUP BY
statistic_dt,
source_system_nm,
account_nm,
device_nm,
campaign_nm,
ad_group_nm,
ad_group_typ,
ad_description_txt,
ad_description_one_txt,
ad_description_two_txt,
ad_headline_txt,
ad_headline_part_one_txt,
ad_headline_part_two_txt
ORDER BY statistic_dt;






