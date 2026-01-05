select cst_id,count(*) from silver.crm_cust_info
group by cst_id having count(*) > 1 or cst_id is null;


INSERT into silver.crm_cust_info (
cst_id,
cst_key, 
cst_firstname,  
cst_lastname,  
cst_martial_status, 
cst_gndr, 
cst_create_date
)
select 
cst_id,
cst_key,
TRIM(cst_firstname) as cst_firstname, 
TRIM(cst_lastname) as cst_lastname,
case when upper(trim(cst_martial_status)) ='M' then 'Married'
	when upper(trim(cst_martial_status)) ='S' then 'Single'
    else 'None'
END cst_martial_status, 
case when upper(TRIM(cst_gndr)) ='M' then 'Male'
      when upper(TRIM(cst_gndr)) ='F' then 'Female'
      else 'None'
END cst_gndr,
cst_create_date from
(
select *,row_number() over (partition by cst_id order by cst_create_date desc)  as last_fla
from bronze.crm_cust_info )t
where last_fla =1;

select cst_lastname from silver.crm_cust_info
where cst_lastname != trim(cst_lastname);

select distinct cst_martial_status from bronze.crm_cust_info;

select distinct prd_line from bronze.crm_product_info;

select *,row_number() over (partition by cst_id order by cst_create_date desc)
as lastfla from bronze.crm_product_info;

insert into silver.crm_product_info(
prd_id,
cat_id,
prd_key, 
prd_name,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
)
select
prd_id,
replace(substring(prd_key,1,5),'-','_') as cat_id,
substring(prd_key,7,length(prd_key)) as prd_key,
prd_name,
IFNULL(prd_cost,0) as prd_cost, 
case upper(trim(prd_line))
	 when 'M' THEN 'Mountain'
     when 'S' THEN 'Other Sales'
     when 'R' THEN 'Road'
     when  'T' THEN 'Touring'
     else 'None'
END as prd_line,
prd_start_dt,
prd_end_dt
from bronze.crm_product_info;

select * from silver.crm_product_info where prd_start_dt > prd_end_dt;

select prd_cost from bronze.crm_product_info where prd_cost != trim(prd_cost);


select * from bronze.crm_sales_details;

insert into silver.crm_sales_details(
sls_ord_num,
sls_prd_key, 
sls_cust_id,
sls_order_dt, 
sls_ship_dt, 
sls_due_dt, 
sls_sales, 
sls_quantity,
sls_price
)
select
sls_ord_num,
sls_prd_key,
sls_cust_id,
cast(sls_order_dt as date) as sls_order_dt,
cast(sls_ship_dt as date) as sls_ship_dt,
cast(sls_due_dt as date) as sls_due_dt,
case when  sls_sales != sls_quantity * ABS(sls_price) then  sls_quantity * ABS(sls_price)
else sls_sales 
END sls_sales,
sls_quantity,
sls_price
from bronze.crm_sales_details;

select * from silver.crm_sales_details where length(sls_order_dt) != 8;
select * from bronze.crm_sales_details where sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt;

select sls_sales,sls_quantity,sls_price from bronze.crm_sales_details where sls_sales != sls_quantity *sls_price ;

insert into silver.erp_cust_az12(
cid,
bdate,
gen
)
select
case when  cid like 'NAS%' then substring(cid,4,length(cid))
      else cid
end as cid, 
bdate,
case when upper(trim(gen)) IN ('F','Female') then 'Female'
        when upper(trim(gen)) IN ('M','Male') then 'Male' 
        else 'None'
end as gen
from bronze.erp_cust_az12;

insert into silver.erp_loc_a101(
cid,
cntry
)
select 
replace(cid,'-','') as cid,
case when trim(cntry) = 'DE' THEN 'Germany'
     when trim(cntry) IN ('US','USA') then 'United States'
     else 'none'
end as cntry
from bronze.erp_loc_a101;

insert into silver.erp_px_cat_g1v2 (
id,
cat,
subcat,
maintenance
)
select
id,
cat,
subcat,
maintenance
from bronze.erp_px_cat_g1v2;
