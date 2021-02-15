# Business Intelligence #

## This project creates an end to end business intelligence tool to allow the user to monitor product sentiment based on online reviews.##


### Here is our basic architecture diagram: ###


<a href="https://imgur.com/HCk74vV"><img src="https://i.imgur.com/HCk74vV.jpg" title="source: imgur.com" /></a>

## We'll be using a sample dataset of Amazon product reviews for demonstration purposes. ##


### We used AWS Redshift for storing our dataset. Using a could based storage solution allowed our team easy access to process the data through application layers and add other related datasets. ###

<a href="https://imgur.com/yYH5KZ5"><img src="https://i.imgur.com/yYH5KZ5.jpg" title="source: imgur.com" /></a>
<a href="https://imgur.com/UKxPRS2"><img src="https://i.imgur.com/UKxPRS2.jpg" title="source: imgur.com" /></a>

### Detailed Instructions for this step can be found [here](https://docs.aws.amazon.com/redshift/latest/gsg/getting-started.html) ###

## Below is the process of importing the Amazon dataset and constructing the table in Redshift. ##

```SQL
CREATE TABLE mytable(
   Uniq_Id               VARCHAR(MAX) NOT NULL distkey sortkey 
  ,Product_Name          VARCHAR(MAX) 
  ,Brand_Name            VARCHAR(MAX)
  ,Asin                  VARCHAR(MAX)
  ,Category              VARCHAR(MAX)
  ,Upc_Ean_Code          VARCHAR(MAX)
  ,List_Price            VARCHAR(MAX) 
  ,Selling_Price         VARCHAR(MAX)
ETC ETC ETC

copy mytable from 's3://project-three-business-intelligence/marketing_sample_for_amazon_data.csv'
credentials 'aws_iam_role=arn:aws:iam::ENTERYOUROWNINFO'
ignoreheader 1
delimiter ',' region 'us-east-2'
removequotes
emptyasnull
blanksasnull
maxerror 5;

```

## With the table set up in Redshift team members can now easily leverage Python to pull out the data, perform analytics and summarize results. ##

```python
dbname = 'dev'
host = 'project-three-bi.{endpoint_data}.us-east-2.redshift.amazonaws.com'
user = 'username'
password = 'password'
port = '5439'

endpoint = f"postgresql://{user}:{password}@{host}:{port}/{dbname}"

my_connection = create_engine(endpoint)
query = "SELECT * FROM mytable;"
df = pd.read_sql(query, my_connection)
df.head()
```
<a href="https://imgur.com/OnszAmE"><img src="https://i.imgur.com/OnszAmE.jpg" title="source: imgur.com" /></a>

## What if we would like to look at How many of each category we have availbale? ##

```python
df['parent_category'] = df['category'].apply(lambda row: row.split('|')[0])
df[['category', 'parent_category']].head()

top_ten_category = pd.DataFrame(df['parent_category'].value_counts()[:10])
cols = ['category', 'count']
top_ten_category_df = top_ten_category.reset_index()
top_ten_category_df.columns = cols
top_ten_category_df

```
<a href="https://imgur.com/p7i8oX3"><img src="https://i.imgur.com/p7i8oX3.jpg" title="source: imgur.com" /></a>

## The new summary table can be pushed back into Redshift and then visualized with PowerBI. ##

```python
top_ten_category_df.to_sql('top_ten_category_table', my_connection, index=False, if_exists='replace')
```

<a href="https://imgur.com/AKNst0L"><img src="https://i.imgur.com/AKNst0L.jpg" title="source: imgur.com" /></a>


## What does this look like in a Business Intelligence tool? ##

### Lets set it up first: ###

<a href="https://imgur.com/cdkegjn"><img src="https://i.imgur.com/cdkegjn.jpg" title="source: imgur.com" /></a>

### Nothing Fancy, merely uploading the same credentials we have been will allow us to bring the data to an interactive (albeit simple) dashboard. ###

## After some playing around, we have a dashboard accessible anywhere to a stakeholder with the right credentials. ##

<a href="https://imgur.com/7cdDDK6"><img src="https://i.imgur.com/7cdDDK6.jpg" title="source: imgur.com" /></a>







