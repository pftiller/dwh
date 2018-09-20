ALTER TABLE `vw_ttd_performance` ADD INDEX `vw_ttd_performance_idx_id_dt_nm_typ_typ_nm` (`advertiser_id`,`statistic_dt`,`source_system_nm`,`ad_environment_typ`,`creative_typ`,`campaign_nm`);

SELECT
        DISTINCT to_char(to_date(vw_ttd_performance.statistic_dt,
        "YYYY-MM-DD"),
        "YYYYMMDD") AS "Date",
        vw_ttd_performance.source_system_nm AS "Platform",
        vw_ttd_performance.ad_environment_typ AS "TTD_Ad_Environment",
        vw_ttd_performance.creative_typ AS "Media",
        vw_ttd_performance.campaign_nm AS "TTD_Campaign_Name",
        vw_ttd_performance.ad_group_fill_typ AS "TTD_Ad_Group",
        vw_ttd_performance.creative_nm AS "TTD_Ad_Name",
        vw_ttd_performance.ad_format_txt AS "TTD_Ad_Dimensions",
        SUM(vw_ttd_performance.impressions_cnt) AS "TTD_Impressions",
        SUM(vw_ttd_performance.clicks_cnt) AS "TTD_Clicks",
        SUM(vw_ttd_performance.player_starts_cnt) AS "TTD_Player_Starts",
        SUM(vw_ttd_performance.player_views_cnt) AS "TTD_Views",
        SUM(vw_ttd_performance.player_completed_views_cnt) AS "TTD_Completed_Views",
        SUM(vw_ttd_performance.c01_click_conversion_cnt) AS "KPI_1_Click_Conversions",
        SUM(vw_ttd_performance.c01_view_through_conversion_cnt) AS "KPI_1_View_Through_Conversions",
        SUM(vw_ttd_performance.c01_click_conversion_revenue_amt) AS "Click_Revenue",
        SUM(vw_ttd_performance.c01_view_through_conversion_revenue_amt) AS "View_Through_Revenue",
        SUM(vw_ttd_performance.c02_click_conversion_cnt) AS "KPI_2_Click_Conversions",
        SUM(vw_ttd_performance.c02_view_through_conversion_cnt) AS "KPI_2_View_Through_Conversions",
        SUM(vw_ttd_performance.c03_click_conversion_cnt) AS "KPI_3_Click_Conversions",
        SUM(vw_ttd_performance.c03_view_through_conversion_cnt) AS "KPI_3_View_Through_Conversions",
        SUM(vw_ttd_performance.c04_click_conversion_cnt) AS "KPI_4_Click_Conversions",
        SUM(vw_ttd_performance.c04_view_through_conversion_cnt) AS "KPI_4_View_Through_Conversions",
        SUM(vw_ttd_performance.c05_click_conversion_cnt) AS "KPI_5_Click_Conversions",
        SUM(vw_ttd_performance.c05_view_through_conversion_cnt) AS "KPI_5_View_Through_Conversions",
        SUM(vw_ttd_performance.advertiser_cost_usd_amt) AS "TTD_Media_Cost" 
    FROM
        vw_ttd_performance 
    WHERE
        vw_ttd_performance.advertiser_id = "4xgixgw" 
    AND statistic_dt > 2018-06-30    
    GROUP BY
        vw_ttd_performance.statistic_dt,
        vw_ttd_performance.source_system_nm,
        vw_ttd_performance.ad_environment_typ,
        vw_ttd_performance.creative_typ,
        vw_ttd_performance.campaign_nm,
        vw_ttd_performance.ad_group_fill_typ,
        vw_ttd_performance.creative_nm,
        vw_ttd_performance.ad_format_txt 
    ORDER BY
        vw_ttd_performance.statistic_dt