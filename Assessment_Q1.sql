USE adashi_staging;

-- Question 1: High-Value Customers with Multiple Products (OPTIMIZED)
-- Finding customers who have both savings and investment plans, sorted by total deposits

-- APPROACH:
-- 1. Pre-filter plans table to identify qualifying plan types first
-- 2. Calculate metrics for both plan types in separate CTEs
-- 3. Join CTEs on indexed owner_id column to find customers with both plan types
-- 4. Add customer details and format with ROUND for 2 decimal places

-- First CTE: Pre-filter plans to identify relevant plan types
WITH FilteredPlans AS (
    SELECT 
        id,
        owner_id,
        CASE
            WHEN is_regular_savings = 1 THEN 'savings'
            WHEN is_a_fund = 1 THEN 'investment'
            ELSE 'other'
        END AS plan_type
    FROM 
        plans_plan
    WHERE 
        is_regular_savings = 1 OR is_a_fund = 1
),

-- Second CTE: Calculate metrics for savings plans
SavingsPlans AS (
    SELECT 
        p.owner_id,
        COUNT(DISTINCT p.id) as savings_count,
        SUM(s.confirmed_amount)/100 as savings_total
    FROM 
        FilteredPlans p
    JOIN 
        savings_savingsaccount s ON s.plan_id = p.id AND s.transaction_status = 'success'
    WHERE 
        p.plan_type = 'savings'
    GROUP BY 
        p.owner_id
),

-- Third CTE: Calculate metrics for investment plans
InvestmentPlans AS (
    SELECT 
        p.owner_id,
        COUNT(DISTINCT p.id) as investment_count,
        SUM(s.confirmed_amount)/100 as investment_total
    FROM 
        FilteredPlans p
    JOIN 
        savings_savingsaccount s ON s.plan_id = p.id AND s.transaction_status = 'success'
    WHERE 
        p.plan_type = 'investment'
    GROUP BY 
        p.owner_id
)

-- Main query: Join CTEs to find customers with both plan types
SELECT 
    s.owner_id,
    CONCAT(u.first_name, ' ', u.last_name) as customer_name,
    s.savings_count,
    i.investment_count,
    ROUND((s.savings_total + i.investment_total), 2) as total_deposits
FROM 
    SavingsPlans s
JOIN 
    InvestmentPlans i ON s.owner_id = i.owner_id
LEFT JOIN 
    users_customuser u ON s.owner_id = u.id
ORDER BY 
    total_deposits DESC
LIMIT 100;  -- Limit results for better performance on large datasets 