-- Question 2: Transaction Frequency Analysis
-- Calculate average transactions per customer per month and categorize by frequency

WITH CustomerTransactions AS (
    SELECT 
        s.owner_id,
        DATE_FORMAT(s.transaction_date, '%Y-%m-01') as month_start,
        COUNT(*) as transactions_per_month
    FROM 
        savings_savingsaccount s
    WHERE 
        s.transaction_status = 'success'
    GROUP BY 
        s.owner_id, 
        DATE_FORMAT(s.transaction_date, '%Y-%m-01')
),
CustomerFrequency AS (
    SELECT 
        owner_id,
        AVG(transactions_per_month) as avg_transactions_per_month,
        CASE 
            WHEN AVG(transactions_per_month) >= 10 THEN 'High Frequency'
            WHEN AVG(transactions_per_month) >= 3 AND AVG(transactions_per_month) < 10 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END as frequency_category
    FROM 
        CustomerTransactions
    GROUP BY 
        owner_id
)
SELECT 
    frequency_category,
    COUNT(*) as customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) as avg_transactions_per_month
FROM 
    CustomerFrequency
GROUP BY 
    frequency_category
ORDER BY
    CASE 
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2
        WHEN frequency_category = 'Low Frequency' THEN 3
    END; 