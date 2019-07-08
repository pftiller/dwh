WITH t1 AS (SELECT
        suid,
        value_txt 
    FROM
        (SELECT
            suid,
            key_txt,
            value_txt 
        FROM
            (SELECT
                combined.suid AS suid,
                mtch.key_txt AS key_txt,
                mtch.value_txt AS value_txt 
            FROM
                (SELECT
                    DISTINCT stage.signal_merge_history.master_suid AS suid 
                FROM
                    stage.signal_merge_history 
                UNION
                SELECT
                    DISTINCT stage.signal_merge_history.other_suid AS suid 
                FROM
                    stage.signal_merge_history) combined FULL 
            OUTER JOIN
                stage.signal_match_table mtch 
                    ON mtch.suid = combined.suid 
            WHERE
                mtch.suid IN (SELECT
                    suid 
                FROM
                    stage.signal_match_table 
                GROUP BY
                    suid 
                HAVING
                    COUNT(suid) > 1 
)) 
            WHERE
                key_txt = 'cust_id' 
            UNION
            ALL SELECT
                suid,
                key_txt,
                value_txt 
            FROM
                (SELECT
                    combined.suid AS suid,
                    mtch.key_txt AS key_txt,
                    mtch.value_txt AS value_txt 
                FROM
                    (SELECT
                        DISTINCT stage.signal_merge_history.master_suid AS suid 
                    FROM
                        stage.signal_merge_history 
                    UNION
                    SELECT
                        DISTINCT stage.signal_merge_history.other_suid AS suid 
                    FROM
                        stage.signal_merge_history) combined FULL 
                OUTER JOIN
                    stage.signal_match_table mtch 
                        ON mtch.suid = combined.suid 
                WHERE
                    mtch.suid IN (SELECT
                        suid 
                    FROM
                        stage.signal_match_table 
                    GROUP BY
                        suid 
                    HAVING
                        COUNT(suid) = 1 
))) 
            GROUP BY
                suid,
                value_txt) SELECT
                    DISTINCT t1.suid AS master_suid,
                    t1.value_txt AS cust_id,
                    crm.order_dt AS last_order_dt,
                    crm.order_id AS order_id,
                    crm.sold_by_store_id AS store_id,
                    SUM(line_amt::NUMERIC (8,
                    2)) AS last_order_amount,
                    crm.major_desc AS last_order_major_desc,
                    a.lifetime_transactions,
                    b.transactions_in_period,
                    a.lifetime_order_amt,
                    b.order_amount_in_period,
                    CASE 
                        WHEN c.online_orders_in_period IS NULL THEN 0 
                        WHEN c.online_orders_in_period IS NOT NULL THEN c.online_orders_in_period 
                    END AS online_orders_in_period,
                    CASE 
                        WHEN d.total_impressions IS NULL THEN 0 
                        WHEN d.total_impressions IS NOT NULL THEN d.total_impressions 
                    END AS total_impressions,
                    CASE 
                        WHEN c.online_order_amount_in_period IS NULL THEN 0.00 
                        WHEN c.online_order_amount_in_period IS NOT NULL THEN c.online_order_amount_in_period 
                    END AS online_order_amount_in_period,
                    d.first_ad_impression AS first_ad_impression,
                    d.last_ad_impression AS last_ad_impression,
                    CASE 
                        WHEN e.total_page_views IS NULL THEN 0::text 
                        WHEN e.total_page_views IS NOT NULL THEN e.total_page_views 
                    END AS total_page_views,
                    e.first_page_view AS first_page_view,
                    e.last_page_view AS last_page_view,
                    f.count_of_email_clicks,
                    g.first_email_touch,
                    g.last_email_touch,
                    h.count_of_google_clicks,
                    i.first_google_touch,
                    i.last_google_touch,
                    j.count_of_bing_clicks,
                    k.first_bing_touch,
                    k.last_bing_touch,
                    l.count_of_preroll_clicks,
                    m.first_preroll_touch,
                    m.last_preroll_touch,
                    n.count_of_display_clicks,
                    o.first_display_touch,
                    o.last_display_touch,
                    p.count_of_social_clicks,
                    q.first_social_touch,
                    q.last_social_touch 
                FROM
                    t1 FULL 
                OUTER JOIN
                    stage.signal_slumberland_crm crm 
                        ON t1.value_txt = crm.cust_id FULL 
                OUTER JOIN
                    (
                        SELECT
                            DISTINCT crm.cust_id AS cust_id,
                            COUNT(DISTINCT crm.order_id) AS lifetime_transactions,
                            SUM(crm.line_amt::NUMERIC (8,
                            2)) AS lifetime_order_amt 
                        FROM
                            stage.signal_slumberland_crm crm 
                        GROUP BY
                            crm.cust_id 
                    ) AS a 
                        ON t1.value_txt = a.cust_id FULL 
                OUTER JOIN
                    (
                        SELECT
                            DISTINCT crm.cust_id,
                            COUNT(DISTINCT crm.order_id) AS transactions_in_period,
                            SUM(crm.line_amt::NUMERIC (8,
                            2)) AS order_amount_in_period 
                        FROM
                            stage.signal_slumberland_crm crm 
                        WHERE
                            crm.order_dt BETWEEN '2018-10-15' AND '2018-10-20' 
                        GROUP BY
                            crm.cust_id 
                    ) AS b 
                        ON t1.value_txt = b.cust_id FULL 
                OUTER JOIN
                    (
                        SELECT
                            DISTINCT crm.cust_id,
                            crm.order_id,
                            COUNT(DISTINCT crm.sfcc_order_id) AS online_orders_in_period,
                            SUM(cart_total_amt::NUMERIC (8,
                            2)) AS online_order_amount_in_period 
                        FROM
                            stage.signal_slumberland_crm crm 
                        JOIN
                            stage.signal_page_view pgvw 
                                ON pgvw.order_id = crm.sfcc_order_id 
                        WHERE
                            regexp_count(cart_total_amt, '\\.') <= 1 
                            AND signal_ts BETWEEN ('2018-10-20'::date - '120 days'::interval) AND '2018-10-20' 
                        GROUP BY
                            crm.cust_id,
                            crm.order_id,
                            crm.sfcc_order_id 
                    ) AS c 
                        ON t1.value_txt = c.cust_id 
                        AND crm.order_id = c.order_id FULL 
                OUTER JOIN
                    (
                        SELECT
                            pgvw.signal_id AS suid,
                            MAX(pgvw.page_view_cnt) AS total_page_views,
                            MIN(pgvw.signal_ts) AS first_page_view,
                            MAX(pgvw.signal_ts) AS last_page_view 
                        FROM
                            stage.signal_page_view pgvw 
                        WHERE
                            pgvw.page_view_cnt > 0 
                            AND pgvw.signal_ts BETWEEN ('2018-10-20'::date - '120 days'::interval) AND '2018-10-20' 
                        GROUP BY
                            pgvw.signal_id 
                    ) AS e 
                        ON t1.suid = e.suid FULL 
                OUTER JOIN
                    (
                        SELECT
                            DISTINCT ttd.signal_id,
                            COUNT(DISTINCT ttd.signal_ts) AS total_impressions,
                            MIN(ttd.signal_ts) AS first_ad_impression,
                            MAX(ttd.signal_ts) AS last_ad_impression 
                        FROM
                            stage.signal_ttd_display ttd 
                        WHERE
                            ttd.signal_ts BETWEEN ('2018-10-20'::date - '120 days'::interval) AND '2018-10-20' 
                        GROUP BY
                            ttd.signal_id 
                    ) AS d 
                        ON t1.suid = d.signal_id FULL 
                OUTER JOIN
                    (
                        SELECT
                            DISTINCT pgvw.signal_id AS suid,
                            COUNT(DISTINCT pgvw.signal_ts) AS count_of_email_clicks 
                        FROM
                            stage.signal_page_view pgvw 
                        WHERE
                            pgvw.utm_source_txt LIKE '%adtaxi%' 
                            AND pgvw.utm_medium_txt LIKE '%email%' 
                            AND pgvw.signal_ts BETWEEN ('2018-10-20'::date - '120 days'::interval) AND '2018-10-20' 
                        GROUP BY
                            pgvw.signal_id 
                    ) AS f 
                        ON t1.suid = f.suid FULL 
                OUTER JOIN
                    (
                        SELECT
                            DISTINCT pgvw.signal_id AS suid,
                            MIN(pgvw.signal_ts) AS first_email_touch,
                            MAX(pgvw.signal_ts) AS last_email_touch 
                        FROM
                            stage.signal_page_view pgvw 
                        WHERE
                            pgvw.utm_source_txt LIKE '%adtaxi%' 
                            AND pgvw.utm_medium_txt LIKE '%email%' 
                            AND pgvw.signal_ts BETWEEN ('2018-10-20'::date - '120 days'::interval) AND '2018-10-20' 
                        GROUP BY
                            pgvw.signal_id 
                    ) AS g 
                        ON t1.suid = g.suid FULL 
                OUTER JOIN
                    (
                        SELECT
                            DISTINCT pgvw.signal_id AS suid,
                            COUNT(DISTINCT pgvw.signal_ts) AS count_of_google_clicks 
                        FROM
                            stage.signal_page_view pgvw 
                        WHERE
                            pgvw.utm_source_txt LIKE '%google%' 
                            AND pgvw.utm_medium_txt LIKE '%cpc%' 
                            AND pgvw.signal_ts BETWEEN ('2018-10-20'::date - '120 days'::interval) AND '2018-10-20' 
                        GROUP BY
                            pgvw.signal_id 
                    ) AS h 
                        ON t1.suid = h.suid FULL 
                OUTER JOIN
                    (
                        SELECT
                            DISTINCT pgvw.signal_id AS suid,
                            MIN(pgvw.signal_ts) AS first_google_touch,
                            MAX(pgvw.signal_ts) AS last_google_touch 
                        FROM
                            stage.signal_page_view pgvw 
                        WHERE
                            pgvw.utm_source_txt LIKE '%google%' 
                            AND pgvw.utm_medium_txt LIKE '%cpc%' 
                            AND pgvw.signal_ts BETWEEN ('2018-10-20'::date - '120 days'::interval) AND '2018-10-20' 
                        GROUP BY
                            pgvw.signal_id 
                    ) AS i 
                        ON t1.suid = i.suid FULL 
                OUTER JOIN
                    (
                        SELECT
                            DISTINCT pgvw.signal_id AS suid,
                            COUNT(DISTINCT pgvw.signal_ts) AS count_of_bing_clicks 
                        FROM
                            stage.signal_page_view pgvw 
                        WHERE
                            pgvw.utm_source_txt LIKE '%bing%' 
                            AND pgvw.utm_medium_txt LIKE '%cpc%' 
                            AND pgvw.signal_ts BETWEEN ('2018-10-20'::date - '120 days'::interval) AND '2018-10-20' 
                        GROUP BY
                            pgvw.signal_id 
                    ) AS j 
                        ON t1.suid = j.suid FULL 
                OUTER JOIN
                    (
                        SELECT
                            DISTINCT pgvw.signal_id AS suid,
                            MIN(pgvw.signal_ts) AS first_bing_touch,
                            MAX(pgvw.signal_ts) AS last_bing_touch 
                        FROM
                            stage.signal_page_view pgvw 
                        WHERE
                            pgvw.utm_source_txt LIKE '%bing%' 
                            AND pgvw.utm_medium_txt LIKE '%cpc%' 
                            AND pgvw.signal_ts BETWEEN ('2018-10-20'::date - '120 days'::interval) AND '2018-10-20' 
                        GROUP BY
                            pgvw.signal_id 
                    ) AS k 
                        ON t1.suid = k.suid FULL 
                OUTER JOIN
                    (
                        SELECT
                            DISTINCT pgvw.signal_id AS suid,
                            COUNT(DISTINCT pgvw.signal_ts) AS count_of_preroll_clicks 
                        FROM
                            stage.signal_page_view pgvw 
                        WHERE
                            pgvw.utm_source_txt LIKE '%adtaxi%' 
                            AND pgvw.utm_medium_txt LIKE '%preroll%' 
                            AND pgvw.signal_ts BETWEEN ('2018-10-20'::date - '120 days'::interval) AND '2018-10-20' 
                        GROUP BY
                            pgvw.signal_id 
                    ) AS l 
                        ON t1.suid = l.suid FULL 
                OUTER JOIN
                    (
                        SELECT
                            DISTINCT pgvw.signal_id AS suid,
                            MIN(pgvw.signal_ts) AS first_preroll_touch,
                            MAX(pgvw.signal_ts) AS last_preroll_touch 
                        FROM
                            stage.signal_page_view pgvw 
                        WHERE
                            pgvw.utm_source_txt LIKE '%adtaxi%' 
                            AND pgvw.utm_medium_txt LIKE '%preroll%' 
                            AND pgvw.signal_ts BETWEEN ('2018-10-20'::date - '120 days'::interval) AND '2018-10-20' 
                        GROUP BY
                            pgvw.signal_id 
                    ) AS m 
                        ON t1.suid = m.suid FULL 
                OUTER JOIN
                    (
                        SELECT
                            DISTINCT pgvw.signal_id AS suid,
                            COUNT(DISTINCT pgvw.signal_ts) AS count_of_display_clicks 
                        FROM
                            stage.signal_page_view pgvw 
                        WHERE
                            pgvw.utm_source_txt LIKE '%adtaxi%' 
                            AND pgvw.utm_medium_txt LIKE '%display%' 
                            AND pgvw.signal_ts BETWEEN ('2018-10-20'::date - '120 days'::interval) AND '2018-10-20' 
                        GROUP BY
                            pgvw.signal_id 
                    ) AS n 
                        ON t1.suid = n.suid FULL 
                OUTER JOIN
                    (
                        SELECT
                            DISTINCT pgvw.signal_id AS suid,
                            MIN(pgvw.signal_ts) AS first_display_touch,
                            MAX(pgvw.signal_ts) AS last_display_touch 
                        FROM
                            stage.signal_page_view pgvw 
                        WHERE
                            pgvw.utm_source_txt LIKE '%adtaxi%' 
                            AND pgvw.utm_medium_txt LIKE '%display%' 
                            AND pgvw.signal_ts BETWEEN ('2018-10-20'::date - '120 days'::interval) AND '2018-10-20' 
                        GROUP BY
                            pgvw.signal_id 
                    ) AS o 
                        ON t1.suid = o.suid FULL 
                OUTER JOIN
                    (
                        SELECT
                            DISTINCT pgvw.signal_id AS suid,
                            COUNT(DISTINCT pgvw.signal_ts) AS count_of_social_clicks 
                        FROM
                            stage.signal_page_view pgvw 
                        WHERE
                            pgvw.utm_source_txt LIKE '%adtaxi%' 
                            AND pgvw.utm_medium_txt LIKE '%social%' 
                            AND pgvw.signal_ts BETWEEN ('2018-10-20'::date - '120 days'::interval) AND '2018-10-20' 
                        GROUP BY
                            pgvw.signal_id 
                    ) AS p 
                        ON t1.suid = p.suid FULL 
                OUTER JOIN
                    (
                        SELECT
                            DISTINCT pgvw.signal_id AS suid,
                            MIN(pgvw.signal_ts) AS first_social_touch,
                            MAX(pgvw.signal_ts) AS last_social_touch 
                        FROM
                            stage.signal_page_view pgvw 
                        WHERE
                            pgvw.utm_source_txt LIKE '%adtaxi%' 
                            AND pgvw.utm_medium_txt LIKE '%social%' 
                            AND pgvw.signal_ts BETWEEN ('2018-10-20'::date - '120 days'::interval) AND '2018-10-20' 
                        GROUP BY
                            pgvw.signal_id
                    ) AS q 
                        ON t1.suid = q.suid 
                WHERE
                    crm.order_dt BETWEEN '2018-10-15' AND '2018-10-20' 
                    AND t1.suid IS NOT NULL 
                GROUP BY
                    t1.suid,
                    t1.value_txt,
                    crm.order_dt,
                    crm.order_id,
                    crm.sold_by_store_id,
                    crm.major_desc,
                    a.lifetime_transactions,
                    a.lifetime_order_amt,
                    b.transactions_in_period,
                    b.order_amount_in_period,
                    c.online_orders_in_period,
                    c.online_order_amount_in_period,
                    d.total_impressions,
                    d.first_ad_impression,
                    d.last_ad_impression,
                    e.total_page_views,
                    e.first_page_view,
                    e.last_page_view,
                    f.count_of_email_clicks,
                    g.first_email_touch,
                    g.last_email_touch,
                    h.count_of_google_clicks,
                    i.first_google_touch,
                    i.last_google_touch,
                    j.count_of_bing_clicks,
                    k.first_bing_touch,
                    k.last_bing_touch,
                    l.count_of_preroll_clicks,
                    m.first_preroll_touch,
                    m.last_preroll_touch,
                    n.count_of_display_clicks,
                    o.first_display_touch,
                    o.last_display_touch,
                    p.count_of_social_clicks,
                    q.first_social_touch,
                    q.last_social_touch 
