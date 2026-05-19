create database zepto;

use zepto;

alter table Zepto_Products
add column S_no serial;

alter table Zepto_Products
modify S_no serial after Category;

alter table Zepto_Products
modify Category VARCHAR(512) after S_no;

select * from zepto_products;

# Data Exploration

# 1. Count of Rows

Select count(*) from Zepto_Products;

# 2. Sample Data

Select * from Zepto_Products limit 10;

# 3. null Values

select * from Zepto_Products
where Category is null or
name is null or
mrp is null or
discountPercent is null or
availableQuantity is null or
discountedSellingPrice is null or
weightInGms is null or
outOfStock is null or
quantity is null;

# 4. Different Product Categories

select distinct(Category) from Zepto_Products
order by Category;

# 5. Products in stock Vs out of stock

select outOfStock, count(*) from Zepto_Products
group by outOfStock;

# 6. Products names present multiple times

select name, count(*) from Zepto_Products
group by name
having count(*) > 1
order by count(*) desc, name;

# Data Cleaning

# 1. Products with Price = 0

select * from zepto_products
where mrp = 0 or discountedSellingPrice = 0;

Delete from Zepto_Products
where mrp = 0 or discountedSellingPrice = 0;

select count(*) from zepto_products;

# 2. Convert Paise to Rupees

update Zepto_Products
set mrp = mrp/100.0, discountedSellingPrice = discountedSellingPrice/100.0;

# Data Analysis

# 1. Find the top 10 best-value products based on the discount percentage.

select distinct(name), mrp, discountPercent
from Zepto_Products
order by discountPercent desc
limit 10;

# 2. What are the Products with High MRP but out of stock.

select distinct(name), mrp
from Zepto_Products
where outofStock = 'True' and mrp > 300
order by mrp desc;

# 3. Calculate estimated Revenue for each category.

select Category, sum(discountedSellingPrice * availableQuantity) as Total_Revenue
from Zepto_Products
group by Category
order by Total_Revenue;

# 4. Find all products where MRP is greater than 500 Rupees and discount is less than 10%.

select distinct(name), mrp, discountPercent
from Zepto_Products
where mrp > 500 and discountPercent < 10
order by discountPercent desc;

# 5. Identify the top 5 categories offering the highest average discount percentage.

select Category, round(avg(discountPercent),2) as Avg_Per
from Zepto_Products
group by Category
order by Avg_Per desc
limit 5;

# 6. Find the price per gram for products above 100g and sort by best value.

select distinct(name), weightInGms, discountedSellingPrice, round((discountedSellingPrice/weightInGms), 2) as Gram_Price
from Zepto_Products
where weightInGms > 100
order by Gram_Price
Limit 10;

# 7. Group the products into categoties like Low, Medium, Bulk.

select distinct name, weightInGms,
case when weightInGms < 1000 then 'Low'
	 when weightInGms < 5000 then 'Medium'
     else 'Bulk'
end as Pro_Category
from Zepto_Products;

# 8. What is the Total Inventory Weight Per Category.

select Category, sum(weightInGms * availableQuantity) as Total_weight
from Zepto_Products
group by Category
order by Total_weight desc;