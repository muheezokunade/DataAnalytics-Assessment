USE adashi_staging;

-- Question 2: Transaction Frequency Analysis
-- Calculate average transactions per customer per month and categorize by frequency

-- APPROACH:
-- 1. First CTE: Calculate monthly transaction count for each customer
-- 2. Second CTE: Calculate average monthly transactions and assign frequency categories
-- 3. Final query: Aggregate and summarize results by frequency category

-- First CTE: Calculate number of transactions per customer per month
WITH CustomerTransactions AS (
    SELECT 
        s.owner_id,
        DATE_FORMAT(s.transaction_date, '%Y-%m-01') as month_start,  -- Group by month
        COUNT(*) as transactions_per_month  -- Count transactions in each month
    FROM 
        savings_savingsaccount s
    WHERE 
        s.transaction_status = 'success'  -- Only include successful transactions
    GROUP BY 
        s.owner_id, 
        DATE_FORMAT(s.transaction_date, '%Y-%m-01')  -- Group by customer and month
),

-- Second CTE: Calculate averages and categorize customers by transaction frequency
CustomerFrequency AS (
    SELECT 
        owner_id,
        AVG(transactions_per_month) as avg_transactions_per_month,  -- Average transactions per month
        -- Assign frequency categories based on transaction volume
        CASE 
            WHEN AVG(transactions_per_month) >= 10 THEN 'High Frequency'  -- 10+ transactions per month
            WHEN AVG(transactions_per_month) >= 3 AND AVG(transactions_per_month) < 10 THEN 'Medium Frequency'  -- 3-9 transactions per month
            ELSE 'Low Frequency'  -- Less than 3 transactions per month
        END as frequency_category
    FROM 
        CustomerTransactions
    GROUP BY 
        owner_id  -- Group by customer to get per-customer averages
)

-- Final aggregation query: Group by frequency category to get counts and averages
SELECT 
    frequency_category,
    COUNT(*) as customer_count,  -- Number of customers in each category
    ROUND(AVG(avg_transactions_per_month), 1) as avg_transactions_per_month  -- Average transactions per month (rounded)
FROM 
    CustomerFrequency
GROUP BY 
    frequency_category
-- Custom sort order for frequency categories (High, Medium, Low)
ORDER BY 
    CASE 
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2
        ELSE 3
    END; 