SELECT DISTINCT
    statistic_dt as date,
    source_system_nm as platform,
    device_nm as device,
    campaign_nm as campaign,
    ad_group_nm as ad_group,
    ad_headline_txt as ad_headline,
    ad_headline_part_one_txt as ad_headline_1,
    ad_headline_part_two_txt as ad_headline_2,
    ad_description_txt as ad_description,
	SUM(impression_cnt) AS impressions,
    SUM(interaction_cnt) AS interactions,
    SUM(click_cnt) AS clicks,
    SUM(video_view_cnt) AS views,
    SUM(conversion_cnt) AS conversions,
    SUM(all_conversion_value_num) AS conversion_value,
    SUM(cost_amt) AS media_cost
FROM
   `data-warehouse-210619.vw_search_ad_performance.vw_search_ad_performance` 
GROUP BY
    statistic_dt,
    source_system_nm,
    device_nm,
    campaign_nm,
    ad_group_nm,
    ad_headline_txt,
    ad_headline_part_one_txt,
    ad_headline_part_two_txt,
    ad_description_txt
ORDER BY
   statistic_dt ASC LIMIT 10000000;