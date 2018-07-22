SELECT
   data.statistic_dt AS date,
   CASE
      WHEN
         data.creative_typ IS NULL 
      THEN
         data.source_system_nm 
      WHEN
         data.source_system_nm IS NULL 
      THEN
         data.creative_typ 
   END
   AS platform, 
   CASE
      WHEN
         Sum(data.impressions_cnt) = 0 
      THEN
         Sum(data.impression_cnt) 
      WHEN
         Sum(data.impression_cnt) = 0 
      THEN
         Sum(data.impressions_cnt) 
   END
   AS total_impressions, 
   CASE
      WHEN
         Sum(data.clicks_cnt) = 0 
      THEN
         Sum(data.click_cnt) 
      WHEN
         Sum(data.click_cnt) = 0 
      THEN
         Sum(data.clicks_cnt) 
   END
   AS total_clicks, 
   CASE
      WHEN
         Sum(data.partner_cost_usd_amt) = 0 
      THEN
         Sum(data.cost_amt) 
      WHEN
         Sum(data.cost_amt) = 0 
      THEN
         Sum(data.partner_cost_usd_amt) 
   END
   AS total_cost, 
   CASE
      WHEN
         Sum(data.player_views_cnt) = 0 
      THEN
         Sum(data.video_view_cnt) 
      WHEN
         Sum(data.video_view_cnt) = 0 
      THEN
         Sum(data.player_views_cnt) 
   END
   AS total_video_views 
FROM
   (
      SELECT DISTINCT
     	statistic_dt,
         creative_typ,
         '' AS source_system_nm,
         0 AS video_view_cnt,
         player_views_cnt,
         impressions_cnt,
         0 AS impression_cnt,
         clicks_cnt,
         0 AS click_cnt,
         partner_cost_usd_amt,
         0 AS cost_amt 
      FROM
         `data-warehouse-210619.vw_ttd_performance.vw_ttd_performance` 
      UNION ALL
      SELECT DISTINCT
         statistic_dt,
         '' AS creative_typ,
         source_system_nm,
         video_view_cnt,
         0 AS player_views_cnt,
         0 AS impressions_cnt,
         impression_cnt,
         0 AS clicks_cnt,
         click_cnt,
         0 AS partner_cost_usd_amt,
         cost_amt 
      FROM
         `data-warehouse-210619.vw_search_ad_performance.vw_search_ad_performance` 
   )
   data 
GROUP BY
   data.statistic_dt,
   data.creative_typ,
   data.source_system_nm 
ORDER BY
   statistic_dt