---- Inspecting Data ---
SELECT * FROM project.superstore;

--- 'Regional_Sales Analysis' ----
------ /// We make less profit in Central Region compare to south while Sales No are higher in Central Region ///---------

SELECT superstore.Region AS Region, ROUND(SUM(SALES)) AS SALE, round(avg(Sales)) as Avg_Sale
FROM project.superstore
GROUP BY 1
ORDER BY 2 DESC; ---- //'Average Order_Amount Are Highest in South Region But Genrated least Sale in That region'// -----

SELECT superstore.Region AS Region, ROUND(SUM(profit)) AS Profit, round(avg(Profit)) as Avg_Profit, round(avg(Discount),2)*100 as Avg_Discont
FROM project.superstore
GROUP BY 1
ORDER BY 2 DESC; ---- //'Giving Most Discount in Central was not profitable at all becouse done poor Sales after all'//---

--- " we did most sales iN Region?---"
SELECT  REGION as Region, COUNT(Sales) AS No_Of_SALE
FROM superstore
GROUP BY 1 
ORDER BY 2 desc; 

--- 'Regional_sale along with Categorical_sale' ----
with NEW_TABLE AS(
SELECT superstore.Region AS Region,Category ,ROUND(SUM(SALES)) AS SALE
FROM project.superstore
GROUP BY 1,2
ORDER BY 1 DESC)
SELECT * , SUM(SALE) over (partition by REGION) AS REGIONAL_SALE
FROM NEW_TABLE
group by 1,2
ORDER BY REGIONAL_SALE DESC, sale desc;

---- "CUSTOMER ANALYSIS"----
SELECT 
case when SALES <= 100 then 'up to 100'
 when SALES <= 500 then '100 - 500'
 else '500+' end as amount_bin
,case when SALES <= 100 then 'small'
 when SALES <= 500 then 'medium'
 else 'large' end as amount_category
,count(`Customer ID`) as customers
FROM superstore
GROUP BY 1,2
order by 1;  ---- 'Customer bin based on Sales Value'

--- //'Size of Customer based on total item purchesed'// ---
SELECT Item_Purchesd, COUNT(*) AS No_Of_Customers FROM 
(SELECT `CUSTOMER NAME` AS Custmer,  count(`Order ID`) as Item_Purchesd
from superstore
group by `CUSTOMER NAME` 
order by count(`Order ID`) desc) A 
group by 1;   

--- //'Regional Customers'//----
SELECT Region, count(distinct(`CUSTOMER NAME`)) as Total_customer
from superstore
group by region
order by count(distinct(`CUSTOMER NAME`))desc; 

--- 'Most Profitable Customer In each Region'---
select * FROM
(SELECT REGION,`Customer Name` AS CUSTOMER, ROUND(SUM(PROFIT),2) AS PROFIT, concat(round(avg(Discount),2)*100, '%') as discount,
RANK() OVER (partition by Region ORDER BY ROUND(SUM(PROFIT),2) DESC) AS RN
 FROM superstore
 GROUP BY 1,2) a
 WHERE RN<=5 and discount <=10; ---- //'Most of profitable customer are getting discount less than 10%'//---
 
---- \\"N0 OF CUSTOMER IS EACH DISCOUNT BUCKET"\\----

SELECT bucket,discount_range, COUNT(*) AS No_Of_Customers FROM (SELECT `CUSTOMER NAME`,
CASE WHEN ROUND(AVG(DISCOUNT)*100) >= 30 THEN "HIGH_DISCOUNT"
WHEN ROUND(AVG(DISCOUNT)*100)<30 AND ROUND(AVG(DISCOUNT)*100)=20 THEN "MEDIUM_DISCOUNT"
ELSE "LOW_DISCOUNT" END AS BUCKET,
 case WHEN ROUND(AVG(DISCOUNT)*100) >= 30 THEN "More Than 30%"
WHEN ROUND(AVG(DISCOUNT)*100)<30 AND ROUND(AVG(DISCOUNT)*100)=20 THEN "Between 20-30%"
ELSE "
less than 10%" END AS Discount_Range
FROM SUPERSTORE 
GROUP BY `CUSTOMER NAME`) X
GROUP BY BUCKET,discount_range;

---- PRODUCT ANALYSIS----

----  Most Sold Product ----
SELECT `PRODUCT NAME` AS Product,  count(*) as No_Time_Sold, sum(Quantity) as Total_Quantity 
from superstore 
group by 1 
order by No_Time_Sold desc; 

---- TOP 10 MOST PROFITABLE PRODUCT----
SELECT  `PRODUCT NAME` AS Product, round(SUM(PROFIT),2) AS PROFIT
FROM superstore GROUP BY PRODUCT ORDER BY PROFIT DESC
LIMIT 10;  



