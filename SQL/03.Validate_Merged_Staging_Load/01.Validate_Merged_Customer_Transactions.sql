USE stg_Bank
GO

-- Total Merged Rows
SELECT COUNT(*) AS Total_Merged_Rows
FROM stg_Bank.dbo.stg_customer_transactions

-- Fraud Detection Rule
SELECT *
FROM stg_customer_transactions
WHERE AccountStatus = 'Suspended'
OR Amount > 5000
OR [Location] <> Country

-- Total Flagged Rows
SELECT COUNT(*) AS Total_Flagged_Rows
FROM stg_Bank.dbo.stg_customer_transactions
WHERE AccountStatus = 'Suspended'
OR Amount > 5000
OR [Location] <> Country