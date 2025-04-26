use Projects;

select * from blinkit_data;

-- data cleaning

select distinct item_fat_content from blinkit_data;

update blinkit_data
set item_fat_content = case
when item_fat_content in ('LF','low fat') then 'Low Fat'
when item_fat_content = 'reg' then 'Regular'
else
item_fat_content
end;

select distinct item_fat_content from blinkit_data;
	
	select * from blinkit_data;

-- KPI's Requirement

-- Total Sales
	select cast(sum(Total_sales) as decimal(10,2)) as Total_Sales
	from blinkit_data;

-- Overall Average Sales
	select avg(total_sales) as Avg_Sales from blinkit_data;

-- Average Sales for each Unique Items
	select cast(sum(total_sales) / count(distinct item_identifier) as decimal(10,2)) as Average_Sales_Per_Item
	from blinkit_data;

-- Number of items
	select count(item_identifier) as no_of_items
	from blinkit_data;

-- Number of Unique items
	select count(distinct item_identifier) as no_of_items
	from blinkit_data;

-- Overall Average rating
	select cast(avg(rating) as decimal(10,2)) As Average_Rating from blinkit_data;

-- Average rating for each unique item
	select  distinct item_identifier, avg(Rating) as Avg_Rating
	from blinkit_data
	group by item_identifier
	order by Avg_Rating desc;

-- Total Sales,Average Sales, no of items, Avg_Rating by Fat Content
	select item_fat_content, sum(total_sales) as Total_sales, avg(total_sales) As Avg_Sales, count(item_identifier) as No_of_Items,
	avg(rating) as Avg_Rating from blinkit_data
	group by item_fat_content;

-- Total Sales,Average Sales, no of items, Avg_Rating by Item Type
	select item_type, cast(sum(total_sales) as decimal(10,2)) as Total_Sales,
	cast(avg(total_sales) as decimal(10,1)) as Avg_Sales, cast(count(item_identifier) as decimal(10,2)) as no_of_items,
	cast(avg(rating) as decimal(10,2)) as Avg_Rating
	from blinkit_data
	group by item_type;

-- Fat Content by outlet for Total Sales & Pivot the Data
	select outlet_location_type, item_fat_content,cast(sum(total_sales) as decimal(10,2)) as Total_Sales,
	cast(avg(total_sales) as decimal(10,1)) as Avg_Sales, cast(count(item_identifier) as decimal(10,2)) as no_of_items,
	cast(avg(rating) as decimal(10,2)) as Avg_Rating
	from blinkit_data
	group by outlet_location_type, item_fat_content
	order by item_fat_content, outlet_location_type;

	CREATE TABLE backup_outlet_fat (
    outlet_location_type VARCHAR(255),
    item_fat_content VARCHAR(255),
    Total_Sales DECIMAL(10, 2),
    Avg_Sales DECIMAL(10, 1),
    no_of_items DECIMAL(10, 2),
    Avg_Rating DECIMAL(10, 2)
	);

	-- insert into backup_outlet_fat
	insert into backup_outlet_fat
	select outlet_location_type, item_fat_content,cast(sum(total_sales) as decimal(10,2)) as Total_Sales,
	cast(avg(total_sales) as decimal(10,1)) as Avg_Sales, cast(count(item_identifier) as decimal(10,2)) as no_of_items,
	cast(avg(rating) as decimal(10,2)) as Avg_Rating
	from blinkit_data
	group by outlet_location_type, item_fat_content
	order by item_fat_content, outlet_location_type;

	select * from backup_outlet_fat;

	select outlet_location_type,
	sum(case when item_fat_content = 'Low Fat' then total_sales else 0 end) as Low_Fat_Total_Sales,
	avg(case when item_fat_content = 'Low Fat' then Avg_sales else 0 end) as Low_Fat_Avg_Sales,
	sum(case when item_fat_content = 'Low Fat' then no_of_items else 0 end) as Low_Fat_Count_items,
	avg(case when item_fat_content = 'Low Fat' then Avg_rating else 0 end) as Low_Fat_avg_rating,

	sum(case when item_fat_content = 'Regular' then total_sales else 0 end) as Reg_Total_Sales,
	avg(case when item_fat_content = 'Regular' then Avg_sales else 0 end) as Reg_Avg_Sales,
	sum(case when item_fat_content = 'Regular' then no_of_items else 0 end) as Reg_Count_items,
	avg(case when item_fat_content = 'Regular' then Avg_rating else 0 end) as Reg_avg_rating
	from backup_outlet_fat
	group by outlet_location_type;

-- Total Sales by Outlet Estlablishment

	select outlet_establishment_year, sum(total_sales) as Total_sales
	from blinkit_data
	group by outlet_establishment_year;

	-- Percentage of sales by outlet size

	select outlet_size, sum(total_sales) as Total_Sales,
	cast(sum(total_sales) * 100 / (select sum(total_sales) from blinkit_data) as decimal(10,2)) as PerSales_Outlet 
	from blinkit_data
	group by outlet_size;

	-- Sales by outlet location
	select outlet_identifier, sum(total_sales) as Total_Sales,
	cast(sum(total_sales) * 100 / (select sum(total_sales) from blinkit_data) as decimal(10,2)) as PerSales_Outlet
	from blinkit_data group by outlet_identifier
	order by PerSales_outlet desc;


	-- All metrics by outlet type
	select outlet_type,
	sum(total_sales) as Total_Sales,
cast(sum(total_sales) * 100 / (select sum(total_sales) from blinkit_data) as decimal(10,2)) as PerSales_Outlet,
	avg(Total_sales) as Avg_Sales,
	count(item_identifier) as no_of_items,
	avg(rating) as Avg_Rating
	from blinkit_data
	group by outlet_type
	order by outlet_type;

