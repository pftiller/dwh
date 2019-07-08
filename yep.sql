SELECT
  DISTINCT to_char(
    vw_search_keyword_performance.statistic_dt,
    'YYYYMMDD'
  ),
  vw_search_keyword_performance.account_nm,
  vw_search_keyword_performance.source_system_nm,
  vw_search_keyword_performance.campaign_nm,
  vw_search_keyword_performance.ad_group_nm,
  vw_search_keyword_performance.ad_title_txt,
    vw_search_keyword_performance.ad_description_txt,
    vw_search_keyword_performance.keyword_nm,
  SUM(vw_search_keyword_performance.impression_cnt),
  SUM(vw_search_keyword_performance.click_cnt),
 (SUM(vw_search_keyword_performance.click_cnt))/(CASE SUM(vw_search_keyword_performance.impression_cnt) WHEN 0 THEN 1 ELSE SUM(vw_search_keyword_performance.impression_cnt) END),
 SUM(vw_search_keyword_performance.cost_amt),
(SUM(vw_search_keyword_performance.cost_amt))/(CASE SUM(vw_search_keyword_performance.click_cnt) WHEN 0 THEN 1 ELSE SUM(vw_search_keyword_performance.click_cnt) END),
SUM(all_conversion_cnt)
FROM
  vw_search_keyword_performance
JOIN 
WHERE)
  AND vw_search_keyword_performance.account_id = ANY ({8664181409})
GROUP BY
  vw_search_keyword_performance.statistic_dt,
  vw_search_keyword_performance.account_nm,
vw_search_keyword_performance.source_system_nm,
vw_search_keyword_performance.campaign_nm,
vw_search_keyword_performance.ad_group_nm,
vw_search_keyword_performance.ad_title_txt,
vw_search_keyword_performance.ad_description,
 vw_search_keyword_performance.keyword_txt 
ORDER BY
  vw_search_keyword_performance.statistic_dt


