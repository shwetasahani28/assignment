create database Statxo;
use statxo;

CREATE TABLE Table1 (
    Emp_ID INT,
    Region VARCHAR(50),
    Name VARCHAR(100),
    Department VARCHAR(100),
    Month VARCHAR(10),
    Year VARCHAR(10),
    Sales DECIMAL(10,2),
    Discounts DECIMAL(10,2),
    Date DATE,
    Percent_Sales DECIMAL(5,2),
    Percent_Discount DECIMAL(5,2),
    Category VARCHAR(100)
);

INSERT INTO table1 (Emp_ID, Region, Name, Department, Month, Year, Sales, Discounts, Date, Percent_Sales, Percent_Discount, Category)
VALUES
(10001, 'East', 'DeRusha, Joe', '5255-Data/Connectivity Sales', 'Jan', 'FY13', 100000.00, 25000.00, '2023-01-24', NULL, NULL, NULL),
(10002, 'East', 'De Pasquale, Richard', '5256-Sales Mgt & Support', 'Jan', 'FY13', 150000.00, 30000.00, '2023-01-01', NULL, NULL, NULL),
(10003, 'East', 'Dobbert, Susan', '5257-Auto Sales', 'Jan', 'FY13', 200000.00, 35000.00, '2023-01-08', NULL, NULL, NULL),
(10003, 'East', 'Dobbert, Susan', '5257-Auto Sales', 'Jan', 'FY13', 200000.00, 35000.00, '2023-01-08', NULL, NULL, NULL),
(10003, 'East', 'Dobbert, Susan', '5257-Auto Sales', 'Jan', 'FY13', 200000.00, 35000.00, '2023-01-08', NULL, NULL, NULL),
(10003, 'East', 'Dobbert, Susan', '5257-Auto Sales', 'Jan', 'FY13', 200000.00, 35000.00, '2023-01-08', NULL, NULL, NULL),
(10001, 'East', 'DeRusha, Joe', '5255-Data/Connectivity Sales', 'Jan', 'FY13', 100000.00, 25000.00, '2023-01-28', NULL, NULL, NULL),
(10002, 'East', 'De Pasquale, Richard', '5256-Sales Mgt & Support', 'Jan', 'FY13', 150000.00, 30000.00, '2023-01-21', NULL, NULL, NULL),
(10003, 'East', 'Dobbert, Susan', '5257-Auto Sales', 'Jan', 'FY13', 200000.00, 35000.00, '2023-01-23', NULL, NULL, NULL),
(10005, 'West', 'Dunton, Donna', '5259-Sales Channel', 'Jan', 'FY13', 300000.00, 45000.00, '2023-01-14', NULL, NULL, NULL),
(10007, 'West', 'De Sousa, Kristi', '5263-Sales Support', 'Jan', 'FY13', 400000.00, 55000.00, '2023-01-28', NULL, NULL, NULL),
(10004, 'East', 'Dillard, Susan', '5258-IAP Sales', 'Jan', 'FY13', 250000.00, 40000.00, '2023-01-28', NULL, NULL, NULL),
(10005, 'West', 'Dunton, Donna', '5259-Sales Channel', 'Jan', 'FY13', 300000.00, 45000.00, '2023-01-21', NULL, NULL, NULL),
(10006, 'West', 'De Vries, John', '5262-Auto GM', 'Jan', 'FY13', 350000.00, 50000.00, '2023-01-23', NULL, NULL, NULL),
(10007, 'West', 'De Sousa, Kristi', '5263-Sales Support', 'Jan', 'FY13', 400000.00, 55000.00, '2023-01-14', NULL, NULL, NULL),
(10008, 'West', 'Defonso, Daniel', '5264-ARD Sales', 'Jan', 'FY13', 450000.00, 60000.00, '2023-01-28', NULL, NULL, NULL);

CREATE TABLE Table2 (
    Department VARCHAR(100),
    Category VARCHAR(50)
);
 
INSERT INTO Table2 (Department, Category)
VALUES
('5255-Data/Connectivity Sales', 'Data'),
('5256-Sales Mgt & Support', 'Support'),
('5257-Auto Sales', 'Sales'),
('5259-Sales Channel', 'Sales'),
('5263-Sales Support', 'Support'),
('5258-IAP Sales', 'IAP'),
('5262-Auto GM', 'Auto GM'),
('5264-ARD Sales', 'ARD');

-- Identify top 3 transactions for each Region based on Sales--  

SELECT
    t1.Emp_ID,
    t1.Region,
    t1.Name,
    t1.Department,
    t1.Month,
    t1.Year,
    t1.Sales,
    t1.Discounts,
    t1.Date,
    t2.Category
FROM
    Table1 t1
JOIN
    Table2 t2 ON t1.Department = t2.Department
WHERE
    (SELECT COUNT(*)
     FROM Table1 t1_inner
     WHERE t1_inner.Region = t1.Region AND t1_inner.Sales >= t1.Sales) <= 3
ORDER BY
    t1.Region, t1.Sales DESC
    limit 3;
    
    
-- Change the Date format (MM/DD/YYYY) (Posting Date) (Main Table)-- 
SELECT DATE_FORMAT(date, '%m-%d-%y') AS posting_date FROM table1;
    

-- Calculate the % of sales and % Discount in the above table-- 
select ROUND((Sales / SUM(Sales) OVER ()) * 100, 2) AS Percent_Sales,
    ROUND((Discounts / SUM(Discounts) OVER ()) * 100, 2) AS Percent_Discount
FROM
    Table1;
   

-- Write the SQL query to update the Category in table 1 using reference table 2 -- 
UPDATE Table1
SET Category = (
    SELECT Table2.Category
    FROM Table2
    WHERE Table1.Department = Table2.Department
    LIMIT 1
);

select * from table1;

-- Find the minimum and maximum sales of each Department-- 

select max(sales), min(sales) from table1;

-- Write the SQL query to Add the rank of each Emp ID based on total sales.-- 
WITH TotalSalesRank AS (
    SELECT
        Emp_ID,
        SUM(Sales) AS TotalSales,
        ROW_NUMBER() OVER (ORDER BY SUM(Sales) DESC) AS SalesRank
    FROM
        Table1
    GROUP BY
        Emp_ID
) 
SELECT
    t1.*,
    tsr.SalesRank
FROM
    Table1 t1
JOIN
    TotalSalesRank tsr ON t1.Emp_ID = tsr.Emp_ID;









