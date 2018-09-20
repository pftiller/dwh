SELECT date(statistic_dt) as date, account, SUM(impressions) AS total_impressions, SUM(clicks) AS total_clicks, SUM(conversions) AS total_conversions
FROM
 (SELECT statistic_dt, account_nm AS account, SUM(impressions_won_cnt) AS impressions,  SUM(click_cnt) AS clicks, SUM(conversions_cnt) AS conversions
  FROM [epicosity.feeding_sd] group by statistic_dt, account),
 (SELECT statistic_dt, advertiser_nm AS account, SUM(impressions_cnt) AS impressions, SUM(clicks_cnt) AS clicks, SUM(c01_total_click_and_view_conversions_cnt + c01_total_click_and_view_conversions_cnt + c02_total_click_and_view_conversions_cnt + c03_total_click_and_view_conversions_cnt + c04_total_click_and_view_conversions_cnt + c05_total_click_and_view_conversions_cnt) AS conversions
  FROM [epicosity.voyage_fcu] group by statistic_dt, account)
GROUP BY date, account
ORDER BY date DESC;