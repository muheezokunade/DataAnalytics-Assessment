-- Question 4: Customer Lifetime Value (CLV) Estimation
-- Calculate CLV based on account tenure and transaction volume

WITH CustomerTenure AS (
    SELECT 
        u.id as customer_id,
        u.name,
        TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE()) as tenure_months
    FROM 
        users_customuser u
    WHERE 
        u.is_active = 1 
),
CustomerTransactions AS (
    SELECT 
        s.owner_id,
        COUNT(*) as total_transactions,
        SUM(s.confirmed_amount) as total_transaction_amount
    FROM 
        savings_savingsaccount s
    WHERE 
        s.transaction_status = 'success'
    GROUP BY 
        s.owner_id
),
CustomerCLV AS (
    SELECT 
        ct.customer_id,
        ct.name,
        ct.tenure_months,
        COALESCE(tr.total_transactions, 0) as total_transactions,
        -- Profit per transaction is 0.1% of total transaction amount
        CASE 
            WHEN ct.tenure_months > 0 THEN
                (COALESCE(tr.total_transactions, 0) / ct.tenure_months) * 12 * 
                (COALESCE(tr.total_transaction_amount, 0) * 0.001) / 100 -- 0.1% in Naira (dividing by 100 to convert kobo to Naira)
            ELSE 0
        END as estimated_clv
    FROM 
        CustomerTenure ct
    LEFT JOIN 
        CustomerTransactions tr ON ct.customer_id = tr.owner_id
)
SELECT 
    customer_id,
    name,
    tenure_months,
    total_transactions,
    ROUND(estimated_clv, 2) as estimated_clv
FROM 
    CustomerCLV
WHERE 
    total_transactions > 0
ORDER BY 
    estimated_clv DESC; 