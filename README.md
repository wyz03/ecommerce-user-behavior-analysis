# 淘宝用户行为数据分析

## 项目简介

本项目基于阿里天池提供的淘宝用户行为数据集，使用 **MySQL（HeidiSQL）** 完成数据导入与基础指标计算，后续将利用 **Python（RFM 模型）** 和 **Power BI** 进行用户分层与可视化分析。目的是模拟电商数据分析师的工作流程，从数据清洗、指标计算到业务洞察。

## 数据集

- **来源**：[阿里天池 - User Behavior Data](https://tianchi.aliyun.com/dataset/649)
- **原始规模**：约 1 亿条用户行为记录（压缩包 905MB，解压后约 3GB）
- **抽样数据**：为便于本地分析，使用 Python 抽取前 20 万行作为样本（`UserBehavior_sample.csv`）
- **字段说明**：

| 字段 | 类型 | 说明 |
|------|------|------|
| user_id | INT | 用户ID |
| item_id | INT | 商品ID |
| category_id | INT | 商品类目ID |
| behavior_type | VARCHAR(10) | 行为类型（pv / cart / fav / buy） |
| timestamp | INT | 行为发生的 Unix 时间戳（秒） |

## 数据准备（导入 MySQL）

1. **下载并抽样**  
   从天池下载 `UserBehavior.csv.zip`，解压后得到约 3GB 的 CSV 文件。  
   使用 Python 脚本读取前 20 万行，生成 `UserBehavior_sample.csv`（约 25MB）。

2. **创建数据库与表**  
   在 MySQL（HeidiSQL）中创建数据库 `ecommerce`，并创建表 `user_behavior`，建表语句如下（也可参考 `sql/create_table.sql`）：

   ```sql
   CREATE TABLE user_behavior (
       user_id INT,
       item_id INT,
       category_id INT,
       behavior_type VARCHAR(10),
       timestamp INT,
       datetime DATETIME
   );
   ```

3. **导入数据**  
   通过 HeidiSQL 的导入向导（右键表 → 导入 → CSV 文件），选择 `UserBehavior_sample.csv`，设置字段分隔符为逗号，勾选“第一行包含字段名”，将数据导入表中。

## SQL 分析（核心指标）

所有分析查询均保存在 `sql/analysis_queries.sql` 中，主要计算以下指标：

- **PV/UV**：总点击次数与独立访客数
- **转化漏斗**：点击 → 加购 → 购买的独立用户数及转化率
- **用户活跃时段分布**：按小时统计点击行为
- **复购率**：购买次数≥2的用户占比

执行示例（部分）：

```sql
-- PV/UV
SELECT 
    COUNT(*) AS pv,
    COUNT(DISTINCT user_id) AS uv
FROM user_behavior
WHERE behavior_type = 'pv';

-- 转化漏斗
SELECT 
    COUNT(DISTINCT CASE WHEN behavior_type = 'pv' THEN user_id END) AS pv_users,
    COUNT(DISTINCT CASE WHEN behavior_type = 'cart' THEN user_id END) AS cart_users,
    COUNT(DISTINCT CASE WHEN behavior_type = 'buy' THEN user_id END) AS buy_users
FROM user_behavior;
```

详细查询请查看 `sql/analysis_queries.sql`。

## 后续计划

- [ ] **Python RFM 模型**：计算每个用户的最近购买时间（Recency）、购买频率（Frequency），完成用户分层（高价值用户、潜力用户等）。
- [ ] **Power BI 可视化看板**：连接 MySQL 或读取处理后的数据，制作交互式报表，展示用户活跃趋势、转化漏斗、用户价值分布。
- [ ] **撰写分析报告**：总结关键结论与运营建议。

## 文件结构

```
ecommerce-user-behavior-analysis/
├── README.md                   # 项目说明
├── .gitignore                  # Git 忽略文件（数据、缓存等）
├── sql/
│   ├── create_table.sql        # 建表语句
│   └── analysis_queries.sql    # SQL 分析查询
├── python/                     # Python 分析脚本（RFM 等）
└── powerbi/                    # Power BI 看板文件（截图或链接）
```

## 环境要求

- MySQL 8.0 或兼容版本
- Python 3.8+（pandas, pymysql, matplotlib）
- Power BI Desktop

## 参考链接

- 阿里天池数据集：[User Behavior Data](https://tianchi.aliyun.com/dataset/649)
- GitHub 仓库：[wyz03/ecommerce-user-behavior-analysis](https://github.com/wyz03/ecommerce-user-behavior-analysis)

---

*注：本项目仍在完善中，欢迎交流。*