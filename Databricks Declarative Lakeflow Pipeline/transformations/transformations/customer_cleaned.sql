CREATE OR REFRESH MATERIALIZED VIEW silver.cleaned_sales_data
(
    CONSTRAINT sales_quantity_check
        EXPECT (quantity IS NOT NULL)
        ON VIOLATION DROP ROW,

    CONSTRAINT sales_channel_check
        EXPECT (channel IS NOT NULL)
        ON VIOLATION DROP ROW,

    CONSTRAINT sales_promo_code_check
        EXPECT (promo_code IS NOT NULL)
        ON VIOLATION DROP ROW,

    CONSTRAINT customer_email_check
        EXPECT (email IS NOT NULL)
        ON VIOLATION DROP ROW
)
COMMENT "Cleaned Sales Data"
AS
SELECT
    FS.sale_id,
    FS.order_date,
    FS.customer_id,
    FS.product_id,
    FS.quantity,
    FS.discount,
    FS.region_id,
    FS.channel,
    FS.promo_code,
    C.first_name,
C.last_name,
C.email,
C.join_date,
C.vip,
P.product_name,
P.category,
P.price,
P.in_stock,
R.region_name,
R.country,
FS.quantity * P.price AS Revenue
FROM
lakeflow_dlt_uc.silver.fact_sales FS
LEFT JOIN lakeflow_dlt_uc.silver.customers C
    ON FS.customer_id = C.customer_id
LEFT JOIN lakeflow_dlt_uc.silver.products P
    ON FS.product_id = P.product_id
LEFT JOIN lakeflow_dlt_uc.silver.regions R
    ON FS.region_id = R.region_id
    
