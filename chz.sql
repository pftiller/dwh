SELECT  
to_char(to_date(statistic_dt,
'YYYY-MM-DD'),
'YYYY-MM-DD') AS "date",
source_system_nm AS "platform",
account_nm AS "advertiser",
campaign_nm AS "campaign",
ad_group_nm AS "ad_group",
SUM(bid_cnt) AS "bids",
SUM(impressions_won_cnt) AS "impressions",
SUM(click_cnt) AS "clicks",
SUM(advertiser_cost_amt) AS "media_cost",
SUM(conversions_cnt) AS "conversions"
FROM
vw_chz_ad_group
WHERE
account_id=7048
GROUP BY
statistic_dt,
source_system_nm, 
account_nm,
campaign_nm,
ad_group_nm
ORDER BY statistic_dt;
