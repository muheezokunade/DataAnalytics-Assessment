-- Question 1: High-Value Customers with Multiple Products
-- Finding customers who have both savings and investment plans, sorted by total deposits

WITH SavingsPlans AS (
    SELECT 
        p.owner_id,
        COUNT(DISTINCT p.id) as savings_count,
        SUM(s.confirmed_amount)/100 as savings_total -- converting kobo to Naira
    FROM 
        plans_plan p
    JOIN 
        savings_savingsaccount s ON s.plan_id = p.id
    WHERE 
        p.is_regular_savings = 1 
        AND s.transaction_status = 'success'
    GROUP BY 
        p.owner_id
    HAVING 
        COUNT(DISTINCT p.id) > 0
),
InvestmentPlans AS (
    SELECT 
        p.owner_id,
        COUNT(DISTINCT p.id) as investment_count,
        SUM(s.confirmed_amount)/100 as investment_total -- converting kobo to Naira
    FROM 
        plans_plan p
    JOIN 
        savings_savingsaccount s ON s.plan_id = p.id
    WHERE 
        p.is_a_fund = 1
        AND s.transaction_status = 'success'
    GROUP BY 
        p.owner_id
    HAVING 
        COUNT(DISTINCT p.id) > 0
)
SELECT 
    u.id as owner_id,
    u.name,
    sp.savings_count,
    ip.investment_count,
    (COALESCE(sp.savings_total, 0) + COALESCE(ip.investment_total, 0)) as total_deposits
FROM 
    users_customuser u
JOIN 
    SavingsPlans sp ON u.id = sp.owner_id
JOIN 
    InvestmentPlans ip ON u.id = ip.owner_id
ORDER BY 
    total_deposits DESC; 