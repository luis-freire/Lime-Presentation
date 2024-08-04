-- Display key performance metrics such as Hourly Revenue Analysis, Seasonal Revenue, Profits and Revenue Trends, and Rider Demgraphics; for informed decision-making and reccomendation of raising prices next year.

-----------------------------------------------------------------------------------------------------------------------------------------------------
---(APPENDED TABLE)----
---- First step is to append the 2021 and 2022 data tables into one complete data table. This lets us see all our data in one query.
SELECT *
FROM PortfolioProjects.dbo.lime_share_2021
UNION
SELECT *
FROM PortfolioProjects.dbo.lime_share_2022
---- (APPENDED TABLE)------
-------------------------------------------------------------------------------------------------------------------------------------------------------

-- LEFT JOINED TABLE (APPENDED TABLE W/ COST_TABLE) ---



---- Next step, we will JOIN our final table into our newly appended table. To do this, first we must subquery our appended table (CTE) and LEFT JOIN that to our 'cost_table'. LEFT JOIN takes all the data from our appended table and uses the similar foreign key [yr] from the'cost_table' and joins them together.

---- (Subquery)
WITH CTE AS (
	SELECT *
FROM PortfolioProjects.dbo.lime_share_2021
UNION
SELECT *
FROM PortfolioProjects.dbo.lime_share_2022)


---- ( We use the subquery to LEFT JOIN both tables using the foreign key [yr]. NOTE: We had to define the path of 'cost_table' in LEFT JOIN function)
SELECT *
FROM CTE
LEFT JOIN PortfolioProjects.dbo.cost_table
ON CTE.yr = PortfolioProjects.dbo.cost_table.yr

----(APPENDED TABLE W/ COST_TABLE)-------
---------------------------------------------------------------------------------------------------------------------------------------------------

--- CLEANED TABLE W/ COLUMNS ONLY NEEDED TO CREATE METRICS -----


---- This creates two [yr] columns in our New Table (CTE & 'cost_table'). So we get rid of the identical [yr] column from 'cost_table'. (It served its purposed in joining both data tables.) We also only SELECT the columns we need in order to create the key metrics in our analysis, in this case [dteday], [season], [CTE.yr], [weekday], [hr], [rider_type], [riders], [price], and [COGS](Costs of goods sold), or known as cleaning our data tables. We start by including the CTE query first.
WITH CTE AS (
	SELECT *
FROM PortfolioProjects.dbo.lime_share_2021
UNION
SELECT *
FROM PortfolioProjects.dbo.lime_share_2022)


--- (Then, from that CTE, we SELECT the columns we want)
SELECT dteday,
	CTE.yr,
	season,
	weekday,
	hr,
	rider_type,
	riders,
	price,
	COGS
--- (We include the LEFT JOIN function to have SQL follow the correct paths.)
FROM CTE
LEFT JOIN PortfolioProjects.dbo.cost_table
ON CTE.yr = PortfolioProjects.dbo.cost_table.yr 

--- CLEANED DATA TABLE ---
------------------------------------------------------------------------------------------------------------------------------------------------------

-- CREATING THE REVUNE METRIC AND PROFT METRIC -- 


---- Next step is to figure out the reveune generated throughout the two years and by multiplying the [riders] column with [price] column. Revenue does not include the amount money invested for goods.
---- To find the actual profit, we must first find the revenue made from our services [riders]*[price] and subrtract that to the amount of money invested. [riders]*[price]-[COGS]


WITH CTE AS (
	SELECT *
FROM PortfolioProjects.dbo.lime_share_2021
UNION
SELECT *
FROM PortfolioProjects.dbo.lime_share_2022)



SELECT dteday,
	CTE.yr,
	season,
	weekday,
	hr,
	rider_type,
	riders,
	price,
	COGS,
	riders*price AS revenue, -- This is where we add the multiplication function and name the results as [revenue].
	riders*price-COGS AS profit -- This is where we subract the revenue with COGS and name the results as [profit].
FROM CTE
LEFT JOIN PortfolioProjects.dbo.cost_table
ON CTE.yr = PortfolioProjects.dbo.cost_table.yr 