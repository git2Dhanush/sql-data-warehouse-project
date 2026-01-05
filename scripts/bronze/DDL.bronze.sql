# NVARCHAR - supports multiple languages  # VARCHAR -supoorts only english\latin
DROP TABLE IF EXISTS bronze.crm_cust_info;
create  table bronze.crm_cust_info (
cst_id INT,
cst_key VARCHAR(50)   character set latin1, # non-unicode
cst_firstname VARCHAR(50) character set utf8mb4, #unicode     
cst_lastname VARCHAR(50) character set utf8mb4,
cst_martial_status VARCHAR(50) character set latin1 ,
cst_gndr VARCHAR(50) character set latin1 ,
cst_create_date DATE
);

#select * from bronze.crm_cust_info;
#describe bronze.crm_customer_info;
#drop table bronze.crm_customer_info;

DROP TABLE IF EXISTS bronze.crm_product_info;
create table bronze.crm_product_info (
prd_id        INT,
prd_key       varchar(50),
prd_name      varchar(50),
prd_cost      INT,
prd_line      varchar(50),
prd_start_dt  datetime,
prd_end_dt    DATETIME
);

drop table if exists  bronze.crm_sales_details ;
create table bronze.crm_sales_details (
sls_ord_num        varchar(50),
sls_prd_key       varchar(50),
sls_cust_id       INT,
sls_order_dt      INT,
sls_ship_dt       INT,
sls_due_dt        INT,
sls_sales       INT,
sls_quantity  INT,
sls_price     INT
);

drop table if exists bronze.erp_cust_az12;
create table bronze.erp_cust_az12(
cid varchar(50),
bdate DATE,
gen    varchar(50)
);

drop table if exists bronze.erp_loc_a101;
create table bronze.erp_loc_a101(
cid varchar(50),
cntry  varchar(50)
);

drop table if exists bronze.erp_px_cat_g1v2; # similar to create or replace
create table bronze.erp_px_cat_g1v2(
id varchar(50),
cat varchar(50),
subcat  varchar(50),
maintenance varchar(50)
);

drop table bronze.crm_cust_info_stg;
#truncate table bronze.crm_cust_info;
#select * from bronze.crm_cust_info;

LOAD DATA  INFILE '\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\prd_info.csv'
INTO TABLE bronze.crm_product_info
FIELDS TERMINATED BY ','
enclosed by '"'
lines terminated by '\n'
IGNORE 1 lines;
