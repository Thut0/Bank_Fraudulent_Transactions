USE dwh_Bank
GO

-- Total rows loaded
Select COUNT(*) AS Total_Rows
FROM dwh_Bank.dbo.dwh_transactions

--Preview the data
SELECT *
FROM stg_Bank.dbo.stg_transactions

--Check for duplicate transactionID
SELECT TransactionID,
COUNT(*) AS Duplicate_Count
FROM stg_Bank.dbo.stg_transactions
GROUP BY TransactionID
HAVING COUNT(*) > 1

--JOIN test

SELECT *
FROM stg_Bank.dbo.stg_transactions AS t
JOIN stg_Bank.dbo.stg_customers AS c
ON t.CustomerID = c.CustomerID