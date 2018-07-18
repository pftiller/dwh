SELECT DISTINCT to_char(to_date(statistic_dt, 'YYYY-MM-DD'),'YYYYMMDD') AS "Date",
source_system_nm AS "Platform",
ad_environment_typ AS "TTD_Ad_Environment",
creative_typ AS "Media",
campaign_nm AS "TTD_Campaign_Name",
ad_group_fill_typ AS "TTD_Ad_Group",
creative_nm AS "TTD_Ad_Name",
ad_format_txt AS "TTD_Ad_Dimensions",
SUM(impressions_cnt) AS "TTD_Impressions",
SUM(clicks_cnt) AS "TTD_Clicks",
SUM(player_starts_cnt) AS "TTD_Player_Starts",
SUM(player_views_cnt) AS "TTD_Views",
SUM(player_completed_views_cnt) AS "TTD_Completed_Views",
SUM(c01_click_conversion_cnt) AS "KPI_1_Click_Conversions",
SUM(c01_view_through_conversion_cnt) AS "KPI_1_View_Through_Conversions",
SUM(c01_click_conversion_revenue_amt) AS "Click_Revenue",
SUM(c01_view_through_conversion_revenue_amt) AS "View_Through_Revenue",
SUM(c02_click_conversion_cnt) AS "KPI_2_Click_Conversions",
SUM(c02_view_through_conversion_cnt) AS "KPI_2_View_Through_Conversions",
SUM(c03_click_conversion_cnt) AS "KPI_3_Click_Conversions",
SUM(c03_view_through_conversion_cnt) AS "KPI_3_View_Through_Conversions",
SUM(c04_click_conversion_cnt) AS "KPI_4_Click_Conversions",
SUM(c04_view_through_conversion_cnt) AS "KPI_4_View_Through_Conversions",
SUM(c05_click_conversion_cnt) AS "KPI_5_Click_Conversions",
SUM(c05_view_through_conversion_cnt) AS "KPI_5_View_Through_Conversions",
SUM(advertiser_cost_usd_amt) AS "TTD_Media_Cost" 
FROM
vw_ttd_performance 
WHERE
advertiser_id = '4xgixgw'
GROUP BY
statistic_dt,
source_system_nm,
ad_environment_typ,
creative_typ,
campaign_nm,
ad_group_fill_typ,
creative_nm,
ad_format_txt 
ORDER BY statistic_dt;