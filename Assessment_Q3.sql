USE adashi_staging;
-- Question 3: Account Inactivity Alert
-- Find active accounts with no transactions in the last 1 year (365 days)

-- APPROACH:
-- 1. First CTE: Find the most recent transaction date for each plan
-- 2. Main query: Join with plan details, calculate inactivity period, filter for active plans inactive >365 days
-- 3. Sort results by inactivity days to highlight the most critical accounts first

-- First CTE: Get the last transaction date for each plan and customer
WITH LatestTransactions AS (
    SELECT 
        s.plan_id,
        s.owner_id,
        MAX(s.transaction_date) as last_transaction_date  -- Find the most recent transaction date
    FROM 
        savings_savingsaccount s
    WHERE 
        s.transaction_status = 'success'  -- Only consider successful transactions
    GROUP BY 
        s.plan_id, s.owner_id  -- Group by plan and owner to get per-plan metrics
)

-- Main query: Find active plans with no recent activity
SELECT 
    lt.plan_id,
    lt.owner_id,
    -- Determine plan type based on plan attributes
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END as type,
    lt.last_transaction_date,  -- Date of last transaction
    DATEDIFF(CURRENT_DATE(), lt.last_transaction_date) as inactivity_days  -- Calculate days since last transaction
FROM 
    LatestTransactions lt
JOIN 
    plans_plan p ON lt.plan_id = p.id  -- Join to get plan details
WHERE 
    p.status_id = 1  -- Only include active plans (status_id = 1)
    AND DATEDIFF(CURRENT_DATE(), lt.last_transaction_date) > 365  -- Filter for plans inactive for more than 1 year
ORDER BY 
    inactivity_days DESC;  -- Sort by most inactive first to identify critical accounts 