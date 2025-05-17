USE adashi_staging;

-- Question 4: Customer Lifetime Value (CLV) Estimation (OPTIMIZED)
-- Calculate CLV based on account tenure and transaction volume

-- APPROACH:
-- 1. Pre-filter active customers first to reduce data volume
-- 2. Pre-filter successful transactions for efficiency
-- 3. Simplify CLV calculation and handle edge cases
-- 4. Use appropriate indexes for joins
-- 5. Limit results for better performance

-- Define constants for CLV calculation
SET @profit_margin = 0.025; -- 2.5% profit margin
SET @projection_months = 60; -- 5-year (60-month) customer lifespan projection

-- First CTE: Calculate customer tenure in months from registration date to present
WITH CustomerTenure AS (
    SELECT 
        id as customer_id,
        CONCAT(first_name, ' ', last_name) as customer_name,
        TIMESTAMPDIFF(MONTH, date_joined, CURRENT_DATE()) as tenure_months
    FROM 
        users_customuser
    WHERE 
        is_active = 1
        AND date_joined IS NOT NULL
),

-- Second CTE: Calculate transaction metrics for each customer
CustomerTransactions AS (
    SELECT 
        owner_id,
        COUNT(*) as total_transactions,
        SUM(confirmed_amount) as total_transaction_amount
    FROM 
        savings_savingsaccount
    WHERE 
        transaction_status = 'success'
        AND confirmed_amount > 0
    GROUP BY 
        owner_id
),

-- Third CTE: Combine tenure and transaction data to calculate CLV
CustomerCLV AS (
    SELECT 
        ct.customer_id,
        ct.customer_name,
        ct.tenure_months,
        COALESCE(tr.total_transactions, 0) as total_transactions,
        (COALESCE(tr.total_transaction_amount, 0) * @profit_margin) / 100 as transaction_profit_naira,
        CASE
            WHEN ct.tenure_months > 0 THEN 
                ((COALESCE(tr.total_transaction_amount, 0) * @profit_margin) / 100) / ct.tenure_months * @projection_months
            ELSE 0
        END as estimated_clv
    FROM 
        CustomerTenure ct
    INNER JOIN 
        CustomerTransactions tr ON ct.customer_id = tr.owner_id
)

-- Final query: Present CLV data sorted by highest value first
SELECT 
    customer_id,
    customer_name,
    tenure_months,
    total_transactions,
    ROUND(estimated_clv, 2) as estimated_clv
FROM 
    CustomerCLV
WHERE 
    total_transactions > 0
    AND estimated_clv > 0
ORDER BY 
    estimated_clv DESC
LIMIT 1000; 