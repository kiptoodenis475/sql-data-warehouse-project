/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy,
    and standardization across the 'silver' schemas. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

PRINT '===========================================';
PRINT 'Running Data Quality Checks: Silver Layer';
PRINT '===========================================';

-- ============================================================================
-- Checking 'silver.crm_cust_info'
-- ============================================================================

-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT 
    cst_id,
    COUNT(*) AS duplicate_count
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for Unwanted Spaces in String Fields
-- Expectation: No Results
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

-- Check Data Standardization & Consistency
-- Expectation: Only 'Male', 'Female', or 'n/a'
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;


-- ============================================================================
-- Checking 'silver.crm_prd_info'
-- ============================================================================

-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT 
    prd_id,
    COUNT(*) AS duplicate_count
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check Invalid Date Ranges (Start Date > End Date)
-- Expectation: No Results
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- Check Data Standardization (Product Line)
-- Expectation: Only valid category values
SELECT DISTINCT prd_line
FROM silver.crm_prd_info;


-- ============================================================================
-- Checking 'silver.crm_sales_details'
-- ============================================================================

-- Check for Invalid Dates or Unmapped Customer/Product Keys
-- Expectation: No Results
SELECT *
FROM silver.crm_sales_details
WHERE sls_cust_id IS NULL 
   OR sls_prd_key IS NULL;

-- Check Business Logic Consistency (Sales = Quantity * Price)
-- Expectation: No Results
SELECT *
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL 
   OR sls_quantity <= 0 
   OR sls_price <= 0;


-- ============================================================================
-- Checking 'silver.erp_cust_az12'
-- ============================================================================

-- Check for Future Birth Dates
-- Expectation: No Results
SELECT *
FROM silver.erp_cust_az12
WHERE bdate > GETDATE();

-- Check Gender Standardization
-- Expectation: Only 'Male', 'Female', or 'n/a'
SELECT DISTINCT gen
FROM silver.erp_cust_az12;


-- ============================================================================
-- Checking 'silver.erp_loc_a101'
-- ============================================================================

-- Check Country Code Standardization (Ensure unmapped codes like 'DE', 'US' are absent)
-- Expectation: Only standardized full country names
SELECT DISTINCT cntry
FROM silver.erp_loc_a101;


-- ============================================================================
-- Checking 'silver.erp_px_cat_g1v2'
-- ============================================================================

-- Check for NULLs in Primary Key
-- Expectation: No Results
SELECT *
FROM silver.erp_px_cat_g1v2
WHERE id IS NULL;

PRINT '===========================================';
PRINT 'Data Quality Checks Completed';
PRINT '===========================================';
