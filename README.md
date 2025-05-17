# DataAnalytics-Assessment

This repository contains SQL solutions for the Data Analytics Assessment. The assessment involves analyzing a financial database to extract valuable business insights.

## Database Structure

The database contains four main tables:
- `users_customuser`: Customer demographic and contact information
- `savings_savingsaccount`: Records of deposit transactions
- `plans_plan`: Records of plans created by customers
- `withdrawals_withdrawal`: Records of withdrawal transactions

## Solution Explanations

### Question 1: High-Value Customers with Multiple Products

**Approach:**
- Created two CTEs (Common Table Expressions) to separately identify customers with savings plans and investment plans
- For each type of plan, counted the number of plans and summed the deposits
- Joined these results with customer data to get customers with both types of plans
- Sorted by total deposits to identify high-value customers

**Challenges:**
- Identifying the correct plan types required examining the database schema to determine that `is_regular_savings = 1` and `is_a_fund = 1` are the distinguishing features
- Converted amounts from kobo to Naira (dividing by 100) for clearer results

### Question 2: Transaction Frequency Analysis

**Approach:**
- Grouped transactions by customer and month to count monthly transactions
- Calculated average monthly transactions per customer
- Categorized customers based on transaction frequency (High: ≥10, Medium: 3-9, Low: ≤2)
- Aggregated results by category with average transactions per category

**Challenges:**
- Used DATE_FORMAT to properly group transactions by month
- Created custom sort to display results in a meaningful order (High, Medium, Low)

### Question 3: Account Inactivity Alert

**Approach:**
- Identified the most recent transaction date for each account
- Calculated inactivity period by comparing to current date
- Filtered for active accounts (based on status_id) with inactivity over 365 days
- Included plan type classification (Savings or Investment)

**Challenges:**
- Determined that looking for the most recent transaction is the appropriate way to measure account activity
- Used DATEDIFF to calculate the inactivity period in days

### Question 4: Customer Lifetime Value (CLV) Estimation

**Approach:**
- Calculated customer tenure in months since signup
- Counted total transactions and summed transaction amounts for each customer
- Applied the CLV formula: (total_transactions / tenure) * 12 * avg_profit_per_transaction
- Used 0.1% of transaction value as profit per transaction

**Challenges:**
- Handling edge cases where tenure might be zero
- Converting kobo to Naira for monetary values
- Ensuring the CLV formula reflects both transaction frequency and value

## Summary

These SQL queries provide valuable business insights for different departments:
- Marketing can use CLV data to target high-value customers
- Customer service can identify inactive accounts for reactivation campaigns
- Product teams can see which customers are engaging with multiple products
- Finance teams can analyze transaction patterns to improve revenue forecasting 