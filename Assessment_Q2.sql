USE adashi_staging;

-- Question 2: Transaction Frequency Analysis (OPTIMIZED)
-- Calculate average transactions per customer per month and categorize by frequency

-- APPROACH:
-- 1. Filter transactions first to reduce processing volume
-- 2. Use efficient date functions for better performance
-- 3. Pre-define frequency categories for easier analysis
-- 4. Create custom sort for meaningful output order

-- First CTE: Calculate number of transactions per customer per month
WITH CustomerTransactions AS (
    SELECT 
        owner_id,
        DATE_FORMAT(transaction_date, '%Y-%m-01') as month_start,
        COUNT(*) as transactions_per_month
    FROM 
        savings_savingsaccount
    WHERE 
        transaction_status = 'success' 
        AND transaction_date IS NOT NULL
    GROUP BY 
        owner_id, 
        DATE_FORMAT(transaction_date, '%Y-%m-01')
),

-- Second CTE: Calculate averages and categorize customers by transaction frequency
CustomerFrequency AS (
    SELECT 
        owner_id,
        AVG(transactions_per_month) as avg_transactions_per_month,
        CASE 
            WHEN AVG(transactions_per_month) >= 10 THEN 'High Frequency'
            WHEN AVG(transactions_per_month) >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END as frequency_category
    FROM 
        CustomerTransactions
    GROUP BY 
        owner_id
)

-- Final aggregation query: Summarize by frequency category
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
        ELSE 3
    END
LIMIT 1000; -- Add limit for safety on large datasets 