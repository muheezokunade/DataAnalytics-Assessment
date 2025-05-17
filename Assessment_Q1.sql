USE adashi_staging;

-- Question 1: High-Value Customers with Multiple Products
-- Finding customers who have both savings and investment plans, sorted by total deposits

-- APPROACH:
-- 1. Use CTEs to separately calculate metrics for savings and investment plans
-- 2. Join these CTEs to identify customers with both plan types
-- 3. Sort by total deposits to identify high-value customers

-- First CTE: Identify savings plans and calculate total deposits
WITH SavingsPlans AS (
    SELECT 
        p.owner_id,
        COUNT(DISTINCT p.id) as savings_count,  -- Count unique savings plans per owner
        SUM(s.confirmed_amount)/100 as savings_total -- Convert kobo to Naira
    FROM 
        plans_plan p
    JOIN 
        savings_savingsaccount s ON s.plan_id = p.id  -- Link savings accounts to plans
    WHERE 
        p.is_regular_savings = 1  -- Filter for regular savings plans only
        AND s.transaction_status = 'success'  -- Include only successful transactions
    GROUP BY 
        p.owner_id
    HAVING 
        COUNT(DISTINCT p.id) > 0  -- Ensure customer has at least one savings plan
),

-- Second CTE: Identify investment plans and calculate total deposits
InvestmentPlans AS (
    SELECT 
        p.owner_id,
        COUNT(DISTINCT p.id) as investment_count,  -- Count unique investment plans per owner
        SUM(s.confirmed_amount)/100 as investment_total  -- Convert kobo to Naira
    FROM 
        plans_plan p
    JOIN 
        savings_savingsaccount s ON s.plan_id = p.id  -- Link savings accounts to plans
    WHERE 
        p.is_a_fund = 1  -- Filter for investment funds only
        AND s.transaction_status = 'success'  -- Include only successful transactions
    GROUP BY 
        p.owner_id
    HAVING 
        COUNT(DISTINCT p.id) > 0  -- Ensure customer has at least one investment plan
)

-- Main query: Join the CTEs to find customers with both plan types
SELECT 
    s.owner_id,
    u.name,  -- Customer's name
    s.savings_count,  -- Number of savings plans
    i.investment_count,  -- Number of investment plans
    (s.savings_total + i.investment_total) as total_deposits  -- Combined deposits across all plan types
FROM 
    SavingsPlans s
JOIN 
    InvestmentPlans i ON s.owner_id = i.owner_id  -- Join to get only customers with both plan types
LEFT JOIN 
    users_customuser u ON s.owner_id = u.id  -- Include customer details
ORDER BY 
    total_deposits DESC;  -- Sort by highest value customers first 