#1. 查看数据概况（确认行为类型分布）
SELECT 
    behavior_type,
    COUNT(*) AS cnt
FROM user_behavior
GROUP BY behavior_type;

#2. 总体 PV/UV（访问量/独立访客）
SELECT 
    COUNT(*) AS pv,
    COUNT(DISTINCT user_id) AS uv
FROM user_behavior
WHERE behavior_type = 'pv';

#3. 转化漏斗（点击→加购→购买）
SELECT 
    COUNT(DISTINCT CASE WHEN behavior_type = 'pv' THEN user_id END) AS pv_users,
    COUNT(DISTINCT CASE WHEN behavior_type = 'cart' THEN user_id END) AS cart_users,
    COUNT(DISTINCT CASE WHEN behavior_type = 'buy' THEN user_id END) AS buy_users
FROM user_behavior;

#4. 用户活跃时段分布（按小时统计 PV）
SELECT 
    HOUR(datetime) AS hour,
    COUNT(*) AS pv
FROM user_behavior
WHERE behavior_type = 'pv'
GROUP BY HOUR(datetime)
ORDER BY HOUR;

#5. 复购率（购买次数≥2的用户占比）
WITH buy_count AS (
    SELECT user_id, COUNT(*) AS buy_times
    FROM user_behavior
    WHERE behavior_type = 'buy'
    GROUP BY user_id
)
SELECT 
    COUNT(DISTINCT user_id) AS total_buyers,
    COUNT(DISTINCT CASE WHEN buy_times >= 2 THEN user_id END) AS repeat_buyers,
    COUNT(DISTINCT CASE WHEN buy_times >= 2 THEN user_id END) / COUNT(DISTINCT user_id) AS repeat_rate
FROM buy_count;