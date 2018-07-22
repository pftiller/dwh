SELECT DISTINCT
   statistic_dt AS date,
   source_system_nm AS platform,
   tracking_tag_1_nm AS kpi_1,
   tracking_tag_2_nm AS kpi_2,
   tracking_tag_3_nm AS kpi_3,
   tracking_tag_4_nm AS kpi_4,
   tracking_tag_5_nm AS kpi_5,
   creative_typ AS media,
   campaign_nm AS campaign,
   ad_group_nm AS ad_group,
   creative_nm AS creative,
   ad_format_txt AS ad_dimensions,
   SUM(impressions_cnt) AS impressions,
   SUM(clicks_cnt) AS impressions,
   SUM(frequency_cnt) AS impressions,
   SUM(player_starts_cnt) AS player_starts,
   SUM(player_views_cnt) AS views,
   SUM(player_completed_views_cnt) AS completed_views,
   SUM(player_complete_quarter_cnt) AS 25_viewed,
   SUM(player_complete_half_cnt) AS 50_viewed,
   SUM(player_complete_three_quarter_cnt) AS 75_viewed,
   SUM(player_expansion_cnt) AS player_expands,
   SUM(player_close_cnt) AS player_closes,
   SUM(c01_click_conversion_cnt) AS kpi_1_pc_conversions,
   SUM(c01_click_conversion_revenue_amt) AS kpi_1_pc_revenue,
   SUM(c01_view_through_conversion_cnt) AS kpi_1_vt_conversions,
   SUM(c01_view_through_conversion_revenue_amt) AS kpi_1_vt_revenue,
   SUM(c01_total_click_and_view_conversions_cnt) AS kpi_1_total_conversions,
   SUM(c02_click_conversion_cnt) AS kpi_2_pc_conversions,
   SUM(c02_click_conversion_revenue_amt) AS kpi_2_pc_revenue,
   SUM(c02_view_through_conversion_cnt) AS kpi_2_vt_conversions,
   SUM(c02_view_through_conversion_revenue_amt) AS kpi_2_vt_revenue,
   SUM(c02_total_click_and_view_conversions_cnt) AS kpi_2_total_conversions,
   SUM(c03_click_conversion_cnt) AS kpi_3_pc_conversions,
   SUM(c03_click_conversion_revenue_amt) AS kpi_3_pc_revenue,
   SUM(c03_view_through_conversion_cnt) AS kpi_3_vt_conversions,
   SUM(c03_view_through_conversion_revenue_amt) AS kpi_3_vt_revenue,
   SUM(c03_total_click_and_view_conversions_cnt) AS kpi_3_total_conversions,
   SUM(c04_click_conversion_cnt) AS kpi_4_pc_conversions,
   SUM(c04_click_conversion_revenue_amt) AS kpi_4_pc_revenue,
   SUM(c04_view_through_conversion_cnt) AS kpi_4_vt_conversions,
   SUM(c04_view_through_conversion_revenue_amt) AS kpi_4_vt_revenue,
   SUM(c04_total_click_and_view_conversions_cnt) AS kpi_4_total_conversions,
   SUM(c05_click_conversion_cnt) AS kpi_5_pc_conversions,
   SUM(c05_click_conversion_revenue_amt) AS kpi_5_pc_revenue,
   SUM(c05_view_through_conversion_cnt) AS kpi_5_vt_conversions,
   SUM(c05_view_through_conversion_revenue_amt) AS kpi_5_vt_revenue,
   SUM(c05_total_click_and_view_conversions_cnt) AS kpi_5_total_conversions,
   SUM(partner_cost_usd_amt) AS cost 
FROM
   `data - warehouse - 210619.vw_ttd_performance.vw_ttd_performance` 
GROUP BY
   statistic_dt,
   source_system_nm,
   tracking_tag_1_nm,
   tracking_tag_2_nm,
   tracking_tag_3_nm,
   tracking_tag_4_nm,
   tracking_tag_5_nm,
   creative_typ,
   campaign_nm,
   ad_group_nm,
   creative_nm,
   ad_format_txt 
ORDER BY
   statistic_dt ASC LIMIT 10000000