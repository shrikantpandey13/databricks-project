CREATE OR REFRESH MATERIALIZED VIEW gold.category_sales_summary AS
SELECT
    category,
    YEAR(order_date) AS year,
    SUM(revenue) AS total_revenue
FROM
    lakeflow_dlt_uc.silver.cleaned_sales_data
GROUP BY category, YEAR(order_date)
ORDER BY category, year;

CREATE OR REFRESH MATERIALIZED VIEW gold.
revenue_by_customers_in_each_region AS
SELECT
    *
FROM (
    SELECT
        customer_id,
        first_name,
        last_name,
        region_name,
        SUM(revenue) AS total_revenue,
        RANK() OVER (PARTITION BY region_name ORDER BY SUM(revenue)
        DESC) AS revenue_rank
    FROM lakeflow_dlt_uc.silver.cleaned_sales_data
    GROUP BY customer_id, first_name, last_name, region_name
) ranked_customers
WHERE revenue_rank <= 5
ORDER BY region_name, revenue_rank;


CREATE OR REFRESH MATERIALIZED VIEW gold.
Customer_Lifetime_Value_Estimation AS
SELECT
    customer_id,
    first_name,
    last_name,
    SUM(revenue) AS lifetime_revenue,
    COUNT(DISTINCT order_date) AS purchase_days,
    AVG(revenue) AS avg_revenue_per_purchase
FROM lakeflow_dlt_uc.silver.cleaned_sales_data
GROUP BY customer_id, first_name, last_name
ORDER BY lifetime_revenue DESC;



