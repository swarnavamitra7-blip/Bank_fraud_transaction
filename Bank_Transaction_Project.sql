CREATE DATABASE bank_analytics;

USE bank_analytics;

ALTER TABLE transactions
MODIFY TransactionID VARCHAR(50),
MODIFY AccountID VARCHAR(50),
MODIFY TransactionAmount DECIMAL(10,2),
MODIFY TransactionDate DATETIME,
MODIFY TransactionType VARCHAR(20),
MODIFY Location VARCHAR(100),
MODIFY DeviceID VARCHAR(50),
CHANGE `IP Address` IPAddress VARCHAR(45),
MODIFY MerchantID VARCHAR(50),
MODIFY Channel VARCHAR(20),
MODIFY CustomerOccupation VARCHAR(50),
MODIFY AccountBalance DECIMAL(12,2),
MODIFY PreviousTransactionDate DATETIME;

SELECT COUNT(*) FROM transactions;

SELECT * FROM transactions LIMIT 10;

DESCRIBE transactions;

SELECT * 
FROM transactions
LIMIT 10;

SELECT COUNT(*) AS total_rows
FROM transactions;

SELECT *
FROM transactions
WHERE TransactionAmount IS NULL;

SELECT TransactionID, COUNT(*)
FROM transactions
GROUP BY TransactionID
HAVING COUNT(*) > 1;

SELECT 'TransactionType' AS ColumnName, TransactionType AS Category, COUNT(*) AS Count
FROM transactions
GROUP BY TransactionType;

SELECT 'Channel' AS ColumnName, Channel AS Category, COUNT(*) AS Count
FROM transactions
GROUP BY Channel;

SELECT 'Location' AS ColumnName, Location AS Category, COUNT(*) AS Count
FROM transactions
GROUP BY Location;

SELECT 'CustomerOccupation' AS ColumnName, CustomerOccupation AS Category, COUNT(*) AS Count
FROM transactions
GROUP BY CustomerOccupation;

ALTER TABLE transactions
DROP COLUMN DeviceID;

ALTER TABLE transactions
DROP COLUMN MerchantID;

ALTER TABLE transactions
DROP COLUMN `IPAddress`;

DESCRIBE transactions;

SELECT COUNT(*) FROM transactions;

# Total Transaction Value Processed by the Bank

SELECT SUM(TransactionAmount) AS Total_Transaction_Value
FROM transactions;

# Most Used Transaction Channel

SELECT Channel, COUNT(*) AS Total_Transactions
FROM transactions
GROUP BY Channel
ORDER BY Total_Transactions DESC;

#  Locations Generating the Highest Number of Transactions

SELECT Location, COUNT(*) AS Transaction_Count
FROM transactions
GROUP BY Location
ORDER BY Transaction_Count DESC
LIMIT 10;

# Average Transaction Amount per Customer Account

SELECT AccountID, AVG(TransactionAmount) AS Avg_Transaction_Amount
FROM transactions
GROUP BY AccountID
ORDER BY Avg_Transaction_Amount DESC
LIMIT 10;

# Occupation Groups with the Highest Number of Transactions

SELECT CustomerOccupation, COUNT(*) AS Total_Transactions
FROM transactions
GROUP BY CustomerOccupation
ORDER BY Total_Transactions DESC;

# Accounts with the Highest Total Transaction Amounts

SELECT AccountID, SUM(TransactionAmount) AS Total_Spent
FROM transactions
GROUP BY AccountID
ORDER BY Total_Spent DESC
LIMIT 10;

# Distribution of Debit vs Credit Transactions

SELECT TransactionType, COUNT(*) AS Transaction_Count
FROM transactions
GROUP BY TransactionType;

# Accounts with High Login Attempts (Potential Security Risk)

SELECT AccountID, MAX(LoginAttempts) AS Max_Login_Attempts
FROM transactions
GROUP BY AccountID
HAVING Max_Login_Attempts > 3
ORDER BY Max_Login_Attempts DESC
LIMIT 10;

# Relationship Between Customer Age and Transaction Amount

SELECT CustomerAge, AVG(TransactionAmount) AS Avg_Transaction
FROM transactions
GROUP BY CustomerAge
ORDER BY CustomerAge
LIMIT 10;

# Transaction Channels with Highest Average Transaction Amount

SELECT Channel, AVG(TransactionAmount) AS Avg_Channel_Transaction
FROM transactions
GROUP BY Channel
ORDER BY Avg_Channel_Transaction DESC;

# Identify Customers with Unusually High Transactions (Fraud Indicator)

WITH TransactionStats AS (
    SELECT 
        AccountID,
        TransactionAmount,
        AVG(TransactionAmount) OVER (PARTITION BY AccountID) AS Avg_Transaction
    FROM transactions
)

SELECT *
FROM TransactionStats
WHERE TransactionAmount > Avg_Transaction * 3
ORDER BY TransactionAmount DESC
LIMIT 10;

# Rank Customers by Total Transaction Value

WITH CustomerSpending AS (
    SELECT 
        AccountID,
        SUM(TransactionAmount) AS Total_Spending
    FROM transactions
    GROUP BY AccountID
)

SELECT 
AccountID,
Total_Spending,
RANK() OVER (ORDER BY Total_Spending DESC) AS Spending_Rank
FROM CustomerSpending
LIMIT 10;

# Detect Accounts with Rapid Consecutive Transactions

SELECT 
AccountID,
TransactionDate,
TransactionAmount,
TIMESTAMPDIFF(
    MINUTE,
    LAG(TransactionDate) OVER (PARTITION BY AccountID ORDER BY TransactionDate),
    TransactionDate
) AS Minutes_Between_Transactions
FROM transactions
ORDER BY Minutes_Between_Transactions DESC
LIMIT 10;

# Analyze Monthly Transaction Trends

WITH MonthlyTransactions AS (
    SELECT 
        DATE_FORMAT(TransactionDate, '%Y-%m') AS Month,
        SUM(TransactionAmount) AS Monthly_Total
    FROM transactions
    GROUP BY Month
)

SELECT 
Month,
Monthly_Total,
SUM(Monthly_Total) OVER (ORDER BY Month) AS Running_Total
FROM MonthlyTransactions
LIMIT 10;