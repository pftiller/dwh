SELECT
  DISTINCT t2.date,
  NVL(t1.advertiser, t2.advertiser) AS advertiser,
  NVL(t1.platform, t2.platform) AS platform,
  NVL(t1.campaign, t2.campaign) AS campaign,
  NVL(t1.ad_group, t2.ad_group) AS ad_group,
  NVL(t1.keyword, t2.keyword) AS keyword,
  t1.impressions + t2.impressions AS impressions,
  t1.clicks + t2.clicks AS clicks,
  t1.media_spend + t2.media_spend AS media_spend,
  t1.total_conversions + t2.total_conversions AS total_conversions
FROM
  (
    (
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
        Bing
      WHERE
        Bing.account_num = ANY ('{F142XLD7}')
      GROUP BY
        Bing.statistic_dt,
        Bing.account_nm,
        Bing.source_system_nm,
        Bing.campaign_nm,
        Bing.ad_group_nm,
        Bing.keyword_txt
    ) as t1
    FULL OUTER JOIN (
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
        AdWords
      WHERE
        AdWords.account_id = ANY ('{8664181409}')
      GROUP BY
        AdWords.statistic_dt,
        AdWords.account_nm,
        AdWords.source_system_nm,
        AdWords.campaign_nm,
        AdWords.ad_group_nm,
        AdWords.keyword_nm
    ) as t2 ON t1.date = t2.date
    AND t1.campaign = t2.campaign
    AND t1.ad_group = t2.ad_group
    AND t1.keyword = t2.keyword
  );
  
  
SELECT 
  NVL(CAST(AdWords.date AS TEXT), CAST(Bing.date AS TEXT)) AS date,
  NVL(AdWords.advertiser, Bing.advertiser) AS advertiser,
  NVL(AdWords.platform, Bing.platform) AS platform,
  NVL(AdWords.campaign, Bing.campaign) AS campaign,
  NVL(AdWords.ad_group, Bing.ad_group) AS ad_group,
  NVL(AdWords.keyword, Bing.keyword) AS keyword,
  NVL(AdWords.impressions +  Bing.impressions, COALESCE(AdWords.impressions, Bing.impressions)) AS impressions,
  NVL(AdWords.clicks +  Bing.clicks, COALESCE(AdWords.clicks, Bing.clicks)) AS clicks,
  NVL(AdWords.media_spend +  Bing.media_spend, COALESCE(AdWords.media_spend, Bing.media_spend)) AS media_spend,
  NVL(AdWords.total_conversions +  Bing.total_conversions, COALESCE(AdWords.total_conversions, Bing.total_conversions)) AS total_conversions
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
          AdWords AdWords
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
          Bing Bing
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
ORDER BY date DESC)