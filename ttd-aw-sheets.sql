SELECT
        to_char(to_date(data.statistic_dt,
        'YYYY-MM-DD'),
        'YYYYMMDD') AS "date",
        CASE 
            WHEN data.creative_typ IS NULL THEN data.source_system_nm 
            WHEN data.source_system_nm IS NULL THEN data.creative_typ 
        END AS "media_type",
        CASE 
            WHEN Sum(data.impressions_cnt) = 0 THEN Sum(data.impression_cnt) 
            WHEN Sum(data.impression_cnt) = 0 THEN Sum(data.impressions_cnt) 
        END AS "impressions",
        CASE 
            WHEN Sum(data.clicks_cnt) = 0 THEN Sum(data.click_cnt) 
            WHEN Sum(data.click_cnt) = 0 THEN Sum(data.clicks_cnt) 
        END AS "clicks",
        CASE 
            WHEN Sum(data.media_cost_usd_amt) = 0 THEN Sum(data.cost_amt) 
            WHEN Sum(data.cost_amt) = 0 THEN Sum(data.media_cost_usd_amt) 
        END AS "cost",
        CASE 
            WHEN Sum(data.player_views_cnt) = 0 THEN Sum(data.video_view_cnt) 
            WHEN Sum(data.video_view_cnt) = 0 THEN Sum(data.player_views_cnt) 
        END AS "views"
    FROM
        (SELECT DISTINCT vw_ttd_performance.statistic_dt,
            creative_typ,
            NULL AS source_system_nm,
            0 AS video_view_cnt,
            player_views_cnt,
            impressions_cnt,
            0 AS impression_cnt,
            clicks_cnt,
            0 AS click_cnt,
            media_cost_usd_amt,
            0 AS cost_amt 
        FROM
            vw_ttd_performance 
        WHERE
            vw_ttd_performance.advertiser_id = '4xgixgw' 
        AND statistic_dt > current_date - 2 
        UNION
        ALL SELECT DISTINCT vw_search_account_performance.statistic_dt,
            NULL AS creative_typ,
            source_system_nm,
            video_view_cnt,
            0 AS player_views_cnt,
            0 AS impressions_cnt,
            impression_cnt,
            0 AS clicks_cnt,
            click_cnt,
            0 AS media_cost_usd_amt,
            cost_amt 
        FROM
            vw_search_account_performance 
        WHERE
            vw_search_account_performance.account_id = 7550652164
        AND statistic_dt > current_date - 2 
    ) data 
GROUP BY
    data.statistic_dt,
    data.creative_typ,
    data.source_system_nm 
ORDER BY
    statistic_dt