# Bank Fraudulent Transactions - ETL & Data Warehouse

An enterprise-grade ETL pipeline built with **SQL Server Integration Services (SSIS)** and **T-SQL** that extracts customer and transaction data, loads it into staging and data warehouse environments, and validates data integrity for fraud detection analysis.

## Overview

This project implements a complete data pipeline for banking transaction fraud detection. It orchestrates the flow of data from source CSV files through staging tables into a dimensional data warehouse, with comprehensive validation checks at each stage.

### Stack
- **Language:** T-SQL (TSQL)
- **ETL Platform:** SQL Server Integration Services (SSIS)
- **Database:** Microsoft SQL Server
- **Data Format:** CSV (source), relational tables (processed)

## Architecture

```
Data/                           # Source data files
  ├── 1782925864006_Customers.csv       # Customer master data
  └── 1782925866727_Transactions.csv    # Transaction records

SQL/                            # T-SQL scripts
  ├── 01.Create Databases/
  │   └── create_databases.sql          # Initialize stg_Bank and dwh_Bank
  ├── 02.Validate_Staging_Load/
  │   ├── 01.Validate_Customers_Load.sql    # Row counts, nulls, duplicates
  │   └── 02.Validate_Transactions_Load.sql # JOIN validation, duplicates
  └── 03.Validate_Merged_Staging_Load/
      └── 01.Validate_Merged_Customer_Transactions.sql  # Post-merge checks

SSIS/                           # SSIS packages (.dtsx files)
  └── Bank_Fraud_ETL/
      ├── 01_Load_Customers_To_Staging.dtsx       # CSV → stg_customers
      ├── 02_Load_Transactions_To_Staging.dtsx    # CSV → stg_transactions
      ├── 03_Load_Customers_To_Dwh.dtsx           # stg → dwh_customers
      ├── 04_Load_Transactions_To_Dwh.dtsx        # stg → dwh_transactions
      ├── 05_Merge_Customer_And_Transactions.dtsx # JOIN stg data
      ├── 06_Load_Flagged_Transactions_To_Dwh.dtsx # Fraud flagging logic
      ├── Bank_Fraud_ETL.dtproj                   # SSIS project file
      └── Project.params                           # Connection parameters
```

## Data Flow

1. **Extract:** CSV source files (`Customers.csv`, `Transactions.csv`) are read from the `/Data` directory
2. **Load to Staging:** SSIS packages load raw data into `stg_Bank` database (`stg_customers`, `stg_transactions` tables)
3. **Validate Staging:** T-SQL scripts verify row counts, check for nulls, and detect duplicate records
4. **Load to DWH:** Cleaned data moves from staging to `dwh_Bank` warehouse
5. **Merge & Enrich:** Customer and transaction data are joined and enriched
6. **Flag Fraud:** Transactions meeting fraud criteria are identified and loaded to a flagged transactions table

## Getting Started

### Prerequisites
- Microsoft SQL Server 2016 or later (with SQL Server Data Tools for SSIS development)
- SQL Server Management Studio (SSMS) for executing scripts
- Source data files (Customers.csv, Transactions.csv) in the `/Data` directory

### Setup Steps

1. **Create Databases:**
   ```sql
   -- Run this first to initialize staging and warehouse databases
   EXECUTE sp_executesql 'SQL/01.Create Databases/create_databases.sql'
   ```

2. **Run SSIS Packages in Order:**
   - Open `SSIS/Bank_Fraud_ETL/Bank_Fraud_ETL.dtproj` in SQL Server Data Tools
   - Execute packages in sequence:
     1. `01_Load_Customers_To_Staging`
     2. `02_Load_Transactions_To_Staging`
     3. `03_Load_Customers_To_Dwh`
     4. `04_Load_Transactions_To_Dwh`
     5. `05_Merge_Customer_And_Transactions`
     6. `06_Load_Flagged_Transactions_To_Dwh`

3. **Validate Data Integrity:**
   ```sql
   -- Check customers load
   EXECUTE sp_executesql 'SQL/02.Validate_Staging_Load/01.Validate_Customers_Load.sql'
   
   -- Check transactions load
   EXECUTE sp_executesql 'SQL/02.Validate_Staging_Load/02.Validate_Transactions_Load.sql'
   
   -- Check merged data
   EXECUTE sp_executesql 'SQL/03.Validate_Merged_Staging_Load/01.Validate_Merged_Customer_Transactions.sql'
   ```

## Key Components

### SSIS Packages

| Package | Purpose |
|---------|---------|
| `01_Load_Customers_To_Staging` | Reads CSV, transforms, loads to `stg_customers` |
| `02_Load_Transactions_To_Staging` | Reads CSV, transforms, loads to `stg_transactions` |
| `03_Load_Customers_To_Dwh` | Transforms and loads customers to `dwh_customers` |
| `04_Load_Transactions_To_Dwh` | Transforms and loads transactions to `dwh_transactions` |
| `05_Merge_Customer_And_Transactions` | Joins customers + transactions for enriched dataset |
| `06_Load_Flagged_Transactions_To_Dwh` | Applies fraud detection rules and flags suspicious transactions |

### Validation Scripts

- **Row Count Checks:** Verify all records loaded successfully
- **NULL Checks:** Ensure required fields are not null
- **Duplicate Detection:** Identify duplicate CustomerID and TransactionID records before rerunning pipeline
- **Join Validation:** Confirm customers and transactions can be joined on CustomerID

## Database Schema

### Staging Database (`stg_Bank`)
- `stg_customers` — Raw customer records from CSV
- `stg_transactions` — Raw transaction records from CSV

### Data Warehouse Database (`dwh_Bank`)
- `dwh_customers` — Cleaned, deduplicated customer dimension
- `dwh_transactions` — Cleaned transaction fact table
- `dwh_flagged_transactions` — Transactions flagged as potentially fraudulent

## Usage Notes

- **Run validation scripts after each SSIS package** to catch issues early
- **Check for duplicates before rerunning the pipeline** (particularly after `05_Merge_Customer_And_Transactions`)
- **Ensure connection parameters are configured** in `Project.params` to point to your SQL Server instance
- **Data files must be in CSV format** and placed in the `/Data` directory

## Future Enhancements

- Add data quality rules (min/max values, date ranges)
- Implement incremental load logic for large datasets
- Add alerting for failed SSIS package executions
- Create reporting views in DWH for fraud analytics dashboard
- Add error logging and exception handling

## Repository Structure

```
.
├── Data/                           # Source data files (CSV)
├── SQL/                            # T-SQL validation and setup scripts
│   ├── 01.Create Databases/
│   ├── 02.Validate_Staging_Load/
│   └── 03.Validate_Merged_Staging_Load/
├── SSIS/                           # SSIS ETL packages
│   └── Bank_Fraud_ETL/
├── README.md                       # This file
└── .gitignore
```

## License

No license specified. For questions, contact the repository owner.

---

**Created:** July 2026  
**Language:** T-SQL, SSIS XML  
**Status:** Active Development
