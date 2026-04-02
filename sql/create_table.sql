CREATE TABLE user_behavior (
    user_id INT,
    item_id INT,
    category_id INT,
    behavior_type TINYINT,
    timestamp INT,           -- 原始 Unix 时间戳（秒）
    datetime DATETIME        -- 可读时间（方便查询）
);
