
SELECT 
  date,
  advertiser,
  platform,
  campaign,
  ad_group,
  keyword,
  impressions,
  clicks,
  media_spend,
  total_conversions
FROM (
  SELECT
          DISTINCT to_char(
            AdWords.statistic_dt,
            'YYYYMMDD'
          ) AS date,
          AdWords.account_nm AS advertiser,
          AdWords.source_system_nm AS platform,
          AdWords.campaign_nm AS campaign,
          AdWords.ad_group_nm AS ad_group,
          AdWords.keyword_nm AS keyword,
          SUM(AdWords.impression_cnt) AS impressions,
          SUM(AdWords.click_cnt) AS clicks,
          SUM(AdWords.cost_amt) AS media_spend,
          SUM(AdWords.all_conversion_cnt) AS total_conversions
        FROM
          vw_search_keyword_performance AdWords
        WHERE
          AdWords.account_id = ANY ('{8664181409}')
        GROUP BY
          AdWords.statistic_dt,
          AdWords.account_nm,
          AdWords.source_system_nm,
          AdWords.campaign_nm,
          AdWords.ad_group_nm,
          AdWords.keyword_nm

UNION ALL (
  SELECT
          DISTINCT to_char(
            Bing.statistic_dt,
            'YYYYMMDD'
          ) AS date,
          Bing.account_nm AS advertiser,
          Bing.source_system_nm AS platform,
          Bing.campaign_nm AS campaign,
          Bing.ad_group_nm AS ad_group,
          Bing.keyword_txt AS keyword,
          SUM(Bing.impression_cnt) AS impressions,
          SUM(Bing.click_cnt) AS clicks,
          SUM(Bing.spend_amt) AS media_spend,
          SUM(Bing.conversion_cnt) AS total_conversions
        FROM
          vw_bing_keyword Bing
        WHERE
          Bing.account_num = ANY ('{F142XLD7}')
        GROUP BY
          Bing.statistic_dt,
          Bing.account_nm,
          Bing.source_system_nm,
          Bing.campaign_nm,
          Bing.ad_group_nm,
          Bing.keyword_txt
)
ORDER BY date DESC);

SELECT
          DISTINCT AdWords.statistic_dt,
          AdWords.account_nm AS advertiser,
          AdWords.source_system_nm AS platform,
          SUM(AdWords.impression_cnt) AS impressions
        FROM
          vw_search_keyword_performance AdWords
        WHERE
          AdWords.account_id = ANY ('{8664181409}')
        GROUP BY
          AdWords.statistic_dt,
          AdWords.account_nm,
          AdWords.source_system_nm
		ORDER BY AdWords.statistic_dt DESC;