USE adashi_staging;

-- Question 4: Customer Lifetime Value (CLV) Estimation
-- Calculate CLV based on account tenure and transaction volume

-- APPROACH:
-- 1. First CTE: Calculate customer tenure in months
-- 2. Second CTE: Aggregate transaction data (count and amount)
-- 3. Third CTE: Combine tenure and transaction data to calculate CLV
-- 4. Final query: Present CLV data sorted by highest value first

-- First CTE: Calculate customer tenure in months from registration date to present
WITH CustomerTenure AS (
    SELECT 
        u.id as customer_id,
        u.name,
        TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE()) as tenure_months  -- Calculate months since joining
    FROM 
        users_customuser u
    WHERE 
        u.is_active = 1  -- Only consider active customers
),

-- Second CTE: Calculate transaction metrics for each customer
CustomerTransactions AS (
    SELECT 
        s.owner_id,
        COUNT(*) as total_transactions,  -- Total number of transactions
        SUM(s.confirmed_amount) as total_transaction_amount  -- Total transaction amount (in kobo)
    FROM 
        savings_savingsaccount s
    WHERE 
        s.transaction_status = 'success'  -- Only count successful transactions
    GROUP BY 
        s.owner_id
),

-- Third CTE: Combine tenure and transaction data to calculate CLV
CustomerCLV AS (
    SELECT 
        ct.customer_id,
        ct.name,
        ct.tenure_months,
        COALESCE(tr.total_transactions, 0) as total_transactions,
        -- Profit per transaction is estimated at 2.5% of transaction amount
        (COALESCE(tr.total_transaction_amount, 0) * 0.025) / 100 as transaction_profit_naira,  -- Convert kobo to Naira
        -- CLV formula: (Average Monthly Profit) * (Average Customer Lifespan)
        -- Using (transaction_profit / tenure_months) * 60 as CLV with 5-year (60-month) horizon
        CASE
            WHEN ct.tenure_months > 0 THEN 
                ((COALESCE(tr.total_transaction_amount, 0) * 0.025) / 100) / ct.tenure_months * 60
            ELSE 0
        END as estimated_clv
    FROM 
        CustomerTenure ct
    LEFT JOIN 
        CustomerTransactions tr ON ct.customer_id = tr.owner_id  -- Join to include customers with no transactions
)

-- Final query: Present CLV data sorted by highest value first
SELECT 
    customer_id,
    name,
    tenure_months,
    total_transactions,
    ROUND(estimated_clv, 2) as estimated_clv  -- Round CLV to 2 decimal places
FROM 
    CustomerCLV
WHERE 
    total_transactions > 0  -- Only include customers with at least one transaction
ORDER BY 
    estimated_clv DESC;  -- Sort by highest CLV first 