SELECT  data.date,
        data.platform,
        SUM(data.impressions) AS total_impressions,
        SUM(data.clicks) AS total_clicks,
        SUM(data.video_views) AS total_video_views,
        SUM(data.retail_cost)*1.65 AS total_retail_cost,
        SUM(data.total_conversions) AS  total_conversions
    FROM
        (SELECT
           date,
           platform,
           SUM(impressions),
           SUM(clicks),
           SUM(video_views),
           SUM(media_cost)*1.20 AS retail_cost,
           SUM(total_conversions)
        FROM
            `tc-data-warehouse.mn_zoo.adwords`
        GROUP BY date,
          		 platform
        UNION
        ALL SELECT
            date,
            platform,
            SUM(impressions),
            SUM(all_clicks),
            SUM('video_played_to_100%') AS video_views,
            SUM(media_cost)*1.25 AS retail_cost,
            SUM(total_conversions)
        FROM
           `tc-data-warehouse.mn_zoo.facebook`
        GROUP BY date,
          		 platform  
        UNION
        ALL SELECT
            date,
            platform,
            SUM(impressions),
            SUM(clicks),
            SUM(video_views),
            SUM(media_cost)*1.65 AS retail_cost,
            SUM(kpi_1_total_conversions + kpi_2_total_conversions + kpi_3_total_conversions + kpi_4_total_conversions + kpi_5_total_conversions) AS total_conversions
        FROM
           `tc-data-warehouse.mn_zoo.trade_desk`
        GROUP BY date,
          		 platform  
    ) data 
GROUP BY
    data.date,
    data.platform
ORDER BY
    data.date