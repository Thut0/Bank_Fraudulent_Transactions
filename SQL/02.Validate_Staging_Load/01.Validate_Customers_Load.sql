USE stg_Bank
GO

-- Total rows loaded
SELECT COUNT(*) AS Total_Rows
FROM stg_Bank.dbo.stg_customers

-- Check for missing rows
SELECT *
FROM stg_customers
WHERE CustomerID IS NULL;

-- Check for duplicate ** before rerunning the pipeline
SELECT CustomerID,
COUNT(*) AS Duplicate_Count
FROM stg_customers
GROUP BY CustomerID
HAVING COUNT(*) > 1;