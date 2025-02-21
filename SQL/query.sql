-- sales：販売データを記録し、date、product_id、quantity、およびrevenueを含みます。
-- inventory：在庫データを記録し、date、product_id、およびstock_levelを含みます。
-- products：製品情報を記録し、product_id、product_name、およびcategoryを含みます。

-- 目標: 各製品の月ごとの総販売量、総収入、平均在庫レベルを抽出し、各製品の累積販売量を計算したいと考えています。

WITH monthly_sales AS (
    SELECT 
        DATE_TRUNC('month', s.date) AS month, -- 月単位に日付を切り捨て
        s.product_id, -- 製品ID
        SUM(s.quantity) AS total_quantity, -- 総販売量を計算
        SUM(s.revenue) AS total_revenue -- 総収入を計算
    FROM 
        sales s -- salesテーブルからデータを取得
    GROUP BY 
        DATE_TRUNC('month', s.date), s.product_id -- 月単位と製品IDでグループ化
),
monthly_inventory AS (
    SELECT 
        DATE_TRUNC('month', i.date) AS month, -- 月単位に日付を切り捨て
        i.product_id, -- 製品ID
        AVG(i.stock_level) AS avg_stock_level -- 平均在庫レベルを計算
    FROM 
        inventory i -- inventoryテーブルからデータを取得
    GROUP BY 
        DATE_TRUNC('month', i.date), i.product_id -- 月単位と製品IDでグループ化
),
product_sales AS (
    SELECT 
        ms.month, -- 月
        ms.product_id, -- 製品ID
        ms.total_quantity, -- 総販売量
        ms.total_revenue, -- 総収入
        mi.avg_stock_level -- 平均在庫レベル
    FROM 
        monthly_sales ms -- monthly_salesからデータを取得
    LEFT JOIN 
        monthly_inventory mi -- monthly_inventoryと左結合
    ON 
        ms.month = mi.month AND ms.product_id = mi.product_id -- 月と製品IDで結合条件を指定
)
SELECT 
    ps.month, -- 月
    p.product_name, -- 製品名
    p.category, -- カテゴリ
    ps.total_quantity, -- 総販売量
    ps.total_revenue, -- 総収入
    ps.avg_stock_level, -- 平均在庫レベル
    SUM(ps.total_quantity) OVER (PARTITION BY ps.product_id ORDER BY ps.month) AS cumulative_quantity -- 累積販売量を計算するウィンドウ関数
FROM 
    product_sales ps -- product_salesからデータを取得
JOIN 
    products p -- productsテーブルと結合
ON 
    ps.product_id = p.product_id -- 製品IDで結合条件を指定
ORDER BY 
    ps.product_id, ps.month; -- 製品IDと月で並べ替え

-- 説明:
-- monthly_sales：各製品の月ごとの総販売量と総収入を計算します。
-- monthly_inventory：各製品の月ごとの平均在庫レベルを計算します。
-- product_sales：monthly_salesとmonthly_inventoryを左結合し、販売データと在庫データを統合します。
-- 最終クエリ：product_salesからデータを抽出し、productsテーブルと結合して製品名とカテゴリを取得します。同時にウィンドウ関数SUM() OVERを使用して各製品の累積販売量を計算します。
