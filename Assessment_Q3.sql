-- Question 3: Account Inactivity Alert
-- Find active accounts with no transactions in the last 1 year (365 days)

WITH LatestTransactions AS (
    SELECT 
        s.plan_id,
        s.owner_id,
        MAX(s.transaction_date) as last_transaction_date
    FROM 
        savings_savingsaccount s
    WHERE 
        s.transaction_status = 'success'
    GROUP BY 
        s.plan_id, s.owner_id
)
SELECT 
    lt.plan_id,
    lt.owner_id,
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
    plans_plan p ON lt.plan_id = p.id
WHERE 
    p.status_id = 1 -- Active accounts only
    AND DATEDIFF(CURRENT_DATE(), lt.last_transaction_date) > 365 -- Last transaction over 1 year ago
    AND (p.is_regular_savings = 1 OR p.is_a_fund = 1) -- Savings or investment accounts
ORDER BY 
    inactivity_days DESC; 