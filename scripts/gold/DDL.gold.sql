
create view gold.dim_customers as
select
row_number() over (order by cst_id) as customer_key,
c1.cst_id as customer_id,
c1.cst_key as customer_number, 
c1.cst_firstname as first_name, 
c1.cst_lastname as last_name,
c3.cntry as country, 
c1.cst_martial_status as martial_status,
case when c1.cst_gndr != 'None' then c1.cst_gndr
     else coalesce(c2.gen,'n/a')
end as gender, 
c2.bdate as birth_date,
c1.cst_create_date as create_date
from silver.crm_cust_info c1
left join silver.erp_cust_az12 c2
on c1.cst_key = c2.cid
left join silver.erp_loc_a101 c3
on c1.cst_key = c3.cid;




create view gold.dim_products as
select 
row_number() over (order by c1.prd_start_dt,c1.prd_key) as product_key,
c1.prd_id as product_id,
c1.prd_key as product_number,
c1.prd_name as product_name,
c1.cat_id as category_id,
c2.cat as category,
c2.subcat as sub_category,
c2.maintenance,
c1.prd_cost as cost,
c1.prd_line as product_line,
c1.prd_start_dt as start_date
from silver.crm_product_info c1
left join silver.erp_px_cat_g1v2 c2
on c1.cat_id = c2.id;


create view gold.fact_sales as
select
s.sls_ord_num as order_number,
d.product_key,
c.customer_key, 
s.sls_order_dt as order_date, 
s.sls_ship_dt as shipping_date,
s.sls_due_dt as due_date,
s.sls_sales as sales_amount,
s.sls_quantity as quantity,
s.sls_price
from silver.crm_sales_details s
left join gold.dim_products d
on s.sls_prd_key = d.product_number
left join gold.dim_customers c 
on s.sls_cust_id = c.customer_id
