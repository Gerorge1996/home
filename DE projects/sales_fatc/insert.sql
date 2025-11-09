INSERT INTO dim_shipping 
SELECT 100+ROW_NUMBER() over() AS ship_id, 
	   ship_mode 
FROM (SELECT distinct ship_mode FROM orders)x;

INSERT INTO dim_customer
SELECT 1000+ROW_NUMBER() over() AS customer_id, 
	   customer_name,
	   segment
FROM (SELECT distinct customer_id,customer_name,segment FROM orders)x;

INSERT INTO dim_geo
SELECT 2000+ROW_NUMBER() over() AS geo_id,
	   country,
	   city,
	   state,
	   postal_code,
	   region
FROM (SELECT distinct country,city,state,region FROM orders)x;


INSERT INTO dim_product
SELECT 3000 + ROW_NUMBER() over() AS product_id,
	   x.product_id AS product_innder_id,
	   category,
	   subcategory AS sub_category,
	   product_name
FROM (SELECT distinct product_id,category,subcategory,product_name FROM orders)x;


INSERT INTO dim_date
WITH dates_table AS 
(
SELECT     MIN(LEAST(order_date, ship_date)) AS minimal_date,
           MAX(GREATEST(order_date, ship_date)) AS maximum_date
FROM orders
),
dt_table AS (
	SELECT date
	(
		generate_series
		(
			    (SELECT minimal_date FROM dates_table)::date,
			    (SELECT maximum_date FROM dates_table)::date,
			    '1 day'::interval
		)
	) AS date
)
SELECT date,
	   extract(YEAR FROM "date") AS year,
	   extract(month FROM "date") AS month,
	   extract(week FROM "date") AS week,
	   EXTRACT(ISODOW FROM "date") AS week_day,
	   CASE WHEN EXTRACT(ISODOW FROM "date") IN (6,7) THEN TRUE ELSE FALSE END AS is_holiday
FROM dt_table;

INSERT INTO sales_fact 
SELECT o.row_id,
	   o.order_id,
	   o.order_date,
	   o.ship_date AS shiped_date,
	   dh.ship_id,
	   dc.customer_id,
	   dp.product_id,
	   o.sales,
	   o.quantity,
	   o.discount,
	   o.profit,
	   dg.geo_id 
FROM orders AS o
LEFT JOIN dim_shipping AS dh    ON dh.ship_mode = o.ship_mode
LEFT JOIN dim_customer AS dc ON dc.customer_name = o.customer_name AND dc.segment = o.segment
LEFT JOIN dim_product  AS dp ON dp.product_inner_id = o.product_id AND dp.category = o.category  
																	AND dp.sub_category = o.subcategory 
																	AND dp.product_name = o.product_name 
LEFT JOIN dim_geo      AS dg ON dg.city = o.city AND dg.country =o.country 
												AND dg.state = o.state 
												AND (dg.postal_code =o.postal_code OR dg.postal_code IS NULL)
												AND dg.region  = o.region;