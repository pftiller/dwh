
ALTER TABLE `vw_search_ad_performance` ADD INDEX `vw_search_ad_perform_idx_id_dt_nm_nm_nm_nm` (`account_id`,`statistic_dt`,`account_nm`,`source_system_nm`,`device_nm`,`ad_group_nm`);

SELECT
        DISTINCT to_char(to_date(vw_search_ad_performance.statistic_dt,
        'YYYY-MM-DD'),
        'YYYYMMDD') AS 'Date',
        vw_search_ad_performance.account_nm AS 'AdWords_Account_Name',
        vw_search_ad_performance.source_system_nm AS 'Media',
        vw_search_ad_performance.device_nm AS 'Device_Type',
        vw_search_ad_performance.ad_group_nm AS 'AdWords_Ad_Group',
        vw_search_ad_performance.campaign_nm AS 'AdWords Campaign',
        vw_search_ad_performance.ad_headline_txt AS 'Headline_Text',
        vw_search_ad_performance.ad_description_txt AS 'Ad_Description_Text',
        vw_search_ad_performance.ad_description_one_txt AS 'Ad_Description_1_Text',
        vw_search_ad_performance.ad_description_two_txt AS 'Ad_Description_2_Text',
        SUM(vw_search_ad_performance.impression_cnt) AS 'AdWords_Impressions',
        SUM(vw_search_ad_performance.click_cnt) AS 'AdWords_Clicks',
        SUM(vw_search_ad_performance.video_view_cnt) AS 'AdWords_Video_Views',
        SUM(vw_search_ad_performance.all_conversion_cnt) AS 'AdWords_Conversions',
        SUM(vw_search_ad_performance.all_conversion_value_num) AS 'AdWords_Conversion_Value',
        SUM(vw_search_ad_performance.cost_amt) AS 'AdWords_Media_Cost' 
    FROM
        vw_search_ad_performance 
    WHERE
        vw_search_ad_performance.account_id = 7550652164 
    GROUP BY
        vw_search_ad_performance.statistic_dt,
        vw_search_ad_performance.account_nm,
        vw_search_ad_performance.source_system_nm,
        vw_search_ad_performance.device_nm,
        vw_search_ad_performance.ad_group_nm,
        vw_search_ad_performance.campaign_nm,
        vw_search_ad_performance.ad_headline_txt,
        vw_search_ad_performance.ad_description_txt,
        vw_search_ad_performance.ad_description_one_txt,
        vw_search_ad_performance.ad_description_two_txt 
    ORDER BY
        NULL