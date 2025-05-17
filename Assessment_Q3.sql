USE adashi_staging;
-- Question 3: Account Inactivity Alert (OPTIMIZED)
-- Find active accounts with no transactions in the last 1 year (365 days)

-- APPROACH:
-- 1. Pre-filter transactions to reduce data volume
-- 2. Use appropriate indexing for joins
-- 3. Calculate inactive threshold date once to improve performance
-- 4. Sort by most critical accounts first

-- Calculate the inactive threshold date once
SET @threshold_date = DATE_SUB(CURRENT_DATE(), INTERVAL 365 DAY);

-- First CTE: Get the last transaction date for each plan and customer
WITH LatestTransactions AS (
    SELECT 
        plan_id,
        owner_id,
        MAX(transaction_date) as last_transaction_date
    FROM 
        savings_savingsaccount
    WHERE 
        transaction_status = 'success'
        AND transaction_date IS NOT NULL
    GROUP BY 
        plan_id, owner_id
)

-- Main query: Find active plans with no recent activity
SELECT 
    lt.plan_id,
    lt.owner_id,
    CONCAT(u.first_name, ' ', u.last_name) as customer_name,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END as type,
    lt.last_transaction_date,
    DATEDIFF(CURRENT_DATE(), lt.last_transaction_date) as inactivity_days
FROM 
    LatestTransactions lt
JOIN 
    plans_plan p ON lt.plan_id = p.id AND p.status_id = 1
LEFT JOIN
    users_customuser u ON lt.owner_id = u.id
WHERE 
    lt.last_transaction_date < @threshold_date
ORDER BY 
    inactivity_days DESC
LIMIT 1000; -- Add limit for better performance 