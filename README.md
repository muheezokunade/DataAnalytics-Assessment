# DataAnalytics-Assessment

This repository contains SQL solutions for a financial database analysis assessment. The assessment involves analyzing a database to extract valuable business insights from customer transaction data, savings and investment plans, and user information.

## Database Structure

The database contains four main tables:
- `users_customuser`: Customer demographic and contact information
- `savings_savingsaccount`: Records of deposit transactions
- `plans_plan`: Records of plans created by customers (savings and investment plans)
- `withdrawals_withdrawal`: Records of withdrawal transactions

## Solution Explanations

### Question 1: High-Value Customers with Multiple Products

**Approach:**
- Created two CTEs (Common Table Expressions) to separately identify customers with savings plans and investment plans
- For each type of plan, counted the number of plans and summed the deposits
- Joined these results to identify customers with both types of plans
- Sorted by total deposits to highlight the highest-value cross-sell opportunities

**Key Technical Components:**
- Used `COUNT(DISTINCT p.id)` to accurately count unique plans per customer
- Converted amounts from kobo to Naira by dividing by 100
- Used `JOIN` between the two CTEs to ensure customers have both plan types
- Applied `LEFT JOIN` to include customer names from the users table
- Filtered for successful transactions only to ensure accurate financial data

**Business Value:**
- Identifies high-value customers who have already demonstrated trust in multiple products
- These customers are prime candidates for additional financial services
- Allows marketing teams to target cross-selling efforts based on deposit amounts

### Question 2: Transaction Frequency Analysis

**Approach:**
- First grouped transactions by customer and month to calculate transactions per month
- Calculated average monthly transaction frequency for each customer
- Categorized customers into frequency segments based on activity levels
- Aggregated results to show distribution across segments

**Key Technical Components:**
- Used `DATE_FORMAT()` to group transactions by month
- Applied `AVG()` function to calculate average transactions per month
- Implemented `CASE` statements to categorize customers by activity level
- Created custom sorting to display results in a logical order (High → Medium → Low)

**Business Value:**
- Segments customers based on engagement level, enabling targeted strategies
- Identifies high-frequency users who may be candidates for premium services
- Highlights low-frequency users who might benefit from re-engagement campaigns
- Provides a foundation for creating different marketing strategies by segment

### Question 3: Account Inactivity Alert

**Approach:**
- Identified the most recent transaction date for each customer's plans
- Calculated the inactive period by comparing to the current date
- Filtered for active accounts with no transactions in over a year
- Categorized accounts by type (Savings vs. Investment)

**Key Technical Components:**
- Used `MAX(transaction_date)` to find the most recent activity
- Applied `DATEDIFF()` to calculate days of inactivity
- Implemented `CASE` statements to categorize plan types
- Filtered using `status_id = 1` to focus only on active accounts
- Sorted by inactivity days to prioritize the most critical accounts

**Business Value:**
- Identifies dormant accounts that may be at risk of being abandoned
- Enables proactive outreach to re-engage customers before they leave
- Helps comply with regulatory requirements for monitoring inactive accounts
- Reduces financial and operational risks associated with dormant accounts

### Question 4: Customer Lifetime Value (CLV) Estimation

**Approach:**
- Calculated customer tenure in months from registration date
- Aggregated transaction data to determine activity level and total transaction amount
- Estimated profit per transaction based on a percentage of transaction amount
- Calculated CLV using a formula based on average monthly profit and projected lifespan

**Key Technical Components:**
- Used `TIMESTAMPDIFF()` to calculate months between registration and current date
- Implemented CLV formula based on transaction profit and tenure
- Applied `COALESCE()` to handle customers with no transactions
- Used a projected customer lifespan of 60 months (5 years) for CLV calculation

**Business Value:**
- Provides a quantitative measure of each customer's long-term value to the business
- Enables allocation of resources based on customer potential
- Identifies high-value customers for retention and loyalty programs
- Allows for better customer acquisition cost analysis and ROI calculations

## Challenges Encountered

### Database Configuration Challenges
- The original SQL file (adashi_assessment.sql) actually creates and uses a database named `adashi_staging` rather than matching its filename
- Had to explicitly include `USE adashi_staging;` at the beginning of each query to ensure they run against the correct database
- This highlights the importance of examining database structure before writing queries, especially when working with unfamiliar databases

### Data Quality Issues
- The `name` column in the `users_customuser` table contained NULL values for most records
- Modified queries to use `CONCAT(first_name, ' ', last_name)` instead to display proper customer names
- This demonstrates the importance of inspecting data quality before relying on specific columns

### Data Conversion
- Had to convert monetary amounts from kobo to Naira (dividing by 100) for meaningful financial analysis

### CLV Calculation
- Implemented a simplified CLV model based on historical data, estimated profit margin, and projected customer lifespan
- Used 2.5% as an estimated profit margin on transactions based on industry standards

### Transaction Categorization
- Created meaningful frequency categories to segment customers by engagement level
- Ensured that segmentation provided a balanced distribution of customers

## Query Optimizations

All queries in this project have been optimized for better performance while maintaining the same analytical results. The following optimization techniques were applied:

### Data Volume Reduction
- Added pre-filtering CTEs to reduce data processing volume early in the execution plan
- Applied NULL checks to prevent unnecessary processing of invalid data
- Added specific filters like `confirmed_amount > 0` to exclude non-meaningful transactions

### Efficient Join Strategies
- Used appropriate JOIN types based on data relationships
- Moved filter conditions into JOIN clauses where possible to filter data earlier
- Leveraged existing indexes on join columns (owner_id, plan_id) for faster data retrieval

### Variable Extraction
- Defined SQL variables for frequently used values (e.g., profit margin, threshold dates)
- Improved code maintainability and reduced repeated calculations
- Enhanced readability with meaningful variable names

### Query Structure Improvements
- Combined related filter conditions to reduce multiple table scans
- Simplified complex expressions and removed redundant operations
- Used CASE statements more efficiently for categorization

### Performance Safeguards
- Added LIMIT clauses to prevent excessive result sets
- Applied proper rounding and formatting of monetary values
- Documented key optimization techniques for future maintenance

These optimizations have significantly improved query execution time while maintaining accuracy of results, making the analytical queries more suitable for production environments.

## Conclusion

These SQL solutions demonstrate the ability to extract meaningful business insights from raw financial data. The queries analyze customer behavior, identify cross-selling opportunities, flag inactive accounts, and estimate customer value - all critical components for data-driven decision making in financial services. 