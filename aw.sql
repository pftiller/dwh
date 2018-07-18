SELECT DISTINCT
to_char(
to_date(statistic_dt, 'YYYY-MM-DD'),'YYYYMMDD') AS "Date",
account_nm AS "AdWords_Account_Name",
source_system_nm AS "Media",
device_nm AS "Device_Type",
ad_group_nm AS "AdWords_Ad_Group",
campaign_nm AS "AdWords Campaign",
ad_headline_txt AS "Headline_Text",
ad_description_txt AS "Ad_Description_Text",
ad_description_one_txt  AS "Ad_Description_1_Text",
ad_description_two_txt AS "Ad_Description_2_Text",
SUM(impression_cnt) AS "AdWords_Impressions",
SUM(click_cnt) AS "AdWords_Clicks",
SUM(video_view_cnt) AS "AdWords_Video_Views",
SUM(all_conversion_cnt) AS "AdWords_Conversions",
SUM(all_conversion_value_num) AS "AdWords_Conversion_Value",
SUM(cost_amt) AS "AdWords_Media_Cost"
FROM vw_search_ad_performance
WHERE vw_search_ad_performance.account_id = 7550652164
GROUP BY statistic_dt,
account_nm,
source_system_nm,
device_nm,
ad_group_nm,
campaign_nm,
ad_headline_txt,
ad_description_txt,
ad_description_one_txt,
ad_description_two_txt;