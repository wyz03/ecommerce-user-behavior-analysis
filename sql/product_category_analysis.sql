#热销商品/品类排行
-- 品类级别：点击量TOP 10
SELECT 
    category_id,
    COUNT(*) AS pv
FROM user_behavior
WHERE behavior_type = 'pv'
GROUP BY category_id
ORDER BY pv DESC
LIMIT 10;

-- 品类级别：购买量TOP 10
SELECT 
    category_id,
    COUNT(*) AS buy_cnt
FROM user_behavior
WHERE behavior_type = 'buy'
GROUP BY category_id
ORDER BY buy_cnt DESC
LIMIT 10;

-- 商品级别（item_id）购买量TOP 10
SELECT 
    item_id,
    category_id,
    COUNT(*) AS buy_cnt
FROM user_behavior
WHERE behavior_type = 'buy'
GROUP BY item_id, category_id
ORDER BY buy_cnt DESC
LIMIT 10;

#品类复购率分析
-- 先计算每个用户在每个品类的购买次数
WITH user_category_purchase AS (
    SELECT 
        user_id,
        category_id,
        COUNT(*) AS purchase_count
    FROM user_behavior
    WHERE behavior_type = 'buy'
    GROUP BY user_id, category_id
),
-- 统计每个品类的总购买用户数和复购用户数（购买次数≥2）
category_stats AS (
    SELECT 
        category_id,
        COUNT(DISTINCT user_id) AS total_buyers,
        COUNT(DISTINCT CASE WHEN purchase_count >= 2 THEN user_id END) AS repeat_buyers
    FROM user_category_purchase
    GROUP BY category_id
)
SELECT 
    category_id,
    total_buyers,
    repeat_buyers,
    ROUND(repeat_buyers / total_buyers, 4) AS repeat_rate
FROM category_stats
WHERE total_buyers >= 10   -- 过滤样本太少的品类
ORDER BY repeat_rate DESC
LIMIT 20;