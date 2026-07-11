-- Create stg and dwh databases if they do not exist
IF DB_ID('stg_Bank') IS NULL
BEGIN
	CREATE DATABASE stg_Bank;
END

IF DB_ID('dwh_Bank') IS NULL
BEGIN
	CREATE DATABASE dwh_Bank;
END