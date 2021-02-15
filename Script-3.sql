DROP table mytable

CREATE TABLE mytable(
   Uniq_Id               VARCHAR(MAX) NOT NULL distkey sortkey 
  ,Product_Name          VARCHAR(MAX) 
  ,Brand_Name            VARCHAR(MAX)
  ,Asin                  VARCHAR(MAX)
  ,Category              VARCHAR(MAX)
  ,Upc_Ean_Code          VARCHAR(MAX)
  ,List_Price            VARCHAR(MAX) 
  ,Selling_Price         VARCHAR(MAX)
  ,Quantity              VARCHAR(MAX)
  ,Model_Number          VARCHAR(MAX)
  ,About_Product         VARCHAR(MAX)
  ,Product_Specification VARCHAR(MAX)
  ,Technical_Details     VARCHAR(MAX)
  ,Shipping_Weight       VARCHAR(MAX)
  ,Product_Dimensions    VARCHAR(MAX)
  ,Image                 VARCHAR(MAX) 
  ,Variants              VARCHAR(MAX)
  ,Sku                   VARCHAR(MAX)
  ,Product_Url           VARCHAR(MAX) 
  ,Stock                 VARCHAR(MAX)
  ,Product_Details       VARCHAR(MAX)
  ,Dimensions            VARCHAR(MAX)
  ,Color                 VARCHAR(MAX)
  ,Ingredients           VARCHAR(MAX)
  ,Direction_To_Use      VARCHAR(MAX)
  ,Is_Amazon_Seller      VARCHAR(MAX) 
  ,Size_Quantity_Variant VARCHAR(MAX)
  ,Product_Description   VARCHAR(MAX)
);

ALTER TABLE mytable
DROP COLUMN Technical_Details;

copy mytable from 's3://project-three-business-intelligence/marketing_sample_for_amazon_data.csv'
credentials 'aws_iam_role=arn:aws:iam::{endpoint}:role/REDSHIFTNEW'
ignoreheader 1
delimiter ',' region 'us-east-2'
removequotes
emptyasnull
blanksasnull
maxerror 5;

select d.query, substring(d.filename,14,20), 
d.line_number as line, 
substring(d.value,1,16) as value,
substring(le.err_reason,1,48) as err_reason
from stl_loaderror_detail d, stl_load_errors le
where d.query = le.query
and d.query = pg_last_copy_id();

SELECT category, selling_price FROM mytable m
ORDER BY selling_price ASC
LIMIT 100

SELECT category, selling_price FROM mytable m 
GROUP BY m.category ORDER BY m.selling_price

select * from (
    select category, 
           selling_price, 
           row_number() over (partition by category order by selling_price desc) as price_rank 
    from mytable) ranks
where price_rank <= 10;

Select * from mytable m 
where asin = ''

select "column"
from pg_table_def
where tablename = 'mytable'
