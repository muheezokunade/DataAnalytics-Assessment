# Financial Data Analytics Assessment

## Overview
This repository contains solutions for a comprehensive financial data analytics assessment for Cowrywise. The analysis examines transaction data from a financial services platform to extract actionable business insights that drive strategic decision-making.

## Database Structure
The analysis is based on four primary database tables:

| Table | Description |
|-------|-------------|
| `users_customuser` | Customer profiles with demographic and contact information |
| `savings_savingsaccount` | Deposit transaction records with amounts and timestamps |
| `plans_plan` | Savings and investment plans created by customers |
| `withdrawals_withdrawal` | Withdrawal transaction history |

## Analysis and Solutions

### Question 1: High-Value Customers with Multiple Products
**Business Question:** Which customers use both savings and investment products, and which offer the highest cross-selling potential?

**Approach:**
The analysis identifies customers who actively use both product types and ranks them by total deposit volume. This approach highlights the most valuable cross-sell opportunities and potential brand ambassadors.

**Technical Implementation:**
- Created separate CTEs for savings and investment activity
- Calculated plan counts and total deposits for each customer
- Joined results to identify customers with both product types
- Sorted by deposit value to prioritize high-value opportunities

**Value Delivered:**
This analysis identifies customers already comfortable with multiple product types who are prime candidates for additional services. Marketing teams can use this data to create targeted campaigns for customers with demonstrated product trust.

### Question 2: Transaction Frequency Analysis
**Business Question:** How can customers be segmented based on their transaction patterns?

**Approach:**
The solution calculates average monthly transaction frequency for each customer and creates meaningful segments based on activity levels. This reveals distinct customer engagement patterns that require different business approaches.

**Technical Implementation:**
- Grouped transactions by customer and month
- Calculated average monthly transactions per customer
- Created segmentation categories based on activity levels
- Implemented custom sorting for intuitive result presentation

**Value Delivered:**
This segmentation enables tailored engagement strategies:
- High-frequency users (power users): Premium service opportunities
- Medium-frequency users (active users): Engagement maintenance programs
- Low-frequency users (occasional users): Re-engagement campaigns

### Question 3: Account Inactivity Alert
**Business Question:** Which active accounts show signs of abandonment risk?

**Approach:**
The query identifies accounts that remain active in the system but show no transaction activity for over a year. By sorting accounts by inactivity duration, it prioritizes the most at-risk relationships.

**Technical Implementation:**
- Found most recent transaction date for each account
- Calculated days since last activity
- Filtered for active accounts with no transactions in 365+ days
- Added plan type categorization to enable targeted outreach

**Value Delivered:**
This analysis enables:
- Proactive customer retention efforts before accounts are abandoned
- Regulatory compliance with dormant account monitoring requirements
- Reduced financial and operational risks from inactive accounts
- Improved customer experience through timely engagement

### Question 4: Customer Lifetime Value (CLV) Estimation
**Business Question:** What is the projected long-term value of each customer?

**Approach:**
The solution develops a CLV model that considers customer tenure, transaction history, estimated profit margin, and projected customer lifespan to quantify each customer's future value to the business.

**Technical Implementation:**
- Calculated customer tenure from registration date
- Analyzed transaction patterns and volume
- Applied a 2.5% profit margin based on industry standards
- Projected forward using a 60-month (5-year) customer lifespan

**Value Delivered:**
This CLV model enables:
- Resource allocation based on customer potential
- Identification of high-value customers for retention programs
- Better customer acquisition cost analysis
- Improved ROI calculations for marketing initiatives

## Challenges and Solutions

### Database Configuration
**Challenge:** The database filename didn't match the actual database name used within the SQL file.

**Solution:** Added explicit `USE adashi_staging;` statements to all queries, ensuring consistent execution against the correct database.

### Data Quality
**Challenge:** The `name` column contained NULL values for most customer records.

**Solution:** Customer names were constructed using `CONCAT(first_name, ' ', last_name)`, delivering more complete and useful results.

### Financial Calculations
**Challenge:** Monetary values were stored in kobo (1/100 of Naira) requiring conversion for meaningful analysis.

**Solution:** Implemented consistent currency conversion throughout all queries, ensuring financial figures are presented in standard Naira format with appropriate decimal precision.

## Performance Optimizations

To ensure these analytical queries could run efficiently in production environments, several optimizations were implemented:

### Data Processing Efficiency
- Pre-filtered data using targeted CTEs to reduce processing volume
- Leveraged existing database indexes for faster joins
- Applied appropriate NULL handling to prevent unnecessary processing

### Query Structure Improvements
- Defined SQL variables for frequently used values
- Combined related filter conditions to minimize table scans
- Implemented efficient join strategies based on data relationships

### Performance Safeguards
- Added appropriate LIMIT clauses to control result set size
- Applied consistent formatting for monetary values
- Documented optimization techniques for future maintenance

## Conclusion

This assessment demonstrates how strategic SQL analysis can transform raw financial data into actionable business insights. The solutions provided enable data-driven decision making across multiple business functions:

- **Marketing:** Targeted cross-selling opportunities and segmented campaigns
- **Customer Success:** Proactive engagement with at-risk accounts
- **Product:** Understanding of customer usage patterns across product lines
- **Finance:** Better valuation of customer relationships and acquisition efforts

These analytical approaches create tangible business value by identifying revenue opportunities, reducing customer churn, and optimizing resource allocation. 