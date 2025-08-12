1 SQL Part – Data Cleaning & RFM Table Creation
Step 1: Create database & table

CREATE DATABASE retail_rfm;
USE retail_rfm;

CREATE TABLE online_retail (
    InvoiceNo VARCHAR(10),
    StockCode VARCHAR(20),
    Description VARCHAR(255),
    Quantity INT,
    InvoiceDate DATETIME,
    UnitPrice DECIMAL(10, 2),
    CustomerID INT,
    Country VARCHAR(50)
);

Step 2: Import CSV into MySQL
(Use MySQL Workbench “Table Data Import Wizard” or LOAD DATA INFILE.)

Step 3: Clean Data
-- Remove NULL Customer IDs
DELETE FROM online_retail WHERE CustomerID IS NULL;

-- Remove negative or zero quantities
DELETE FROM online_retail WHERE Quantity <= 0;

-- Remove negative or zero prices
DELETE FROM online_retail WHERE UnitPrice <= 0;

Step 4: Calculate Recency, Frequency, Monetary
-- Set a reference date (1 day after last transaction in data)
SET @snapshot_date = (SELECT DATE_ADD(MAX(InvoiceDate), INTERVAL 1 DAY) FROM online_retail);

-- RFM Calculation
SELECT
    CustomerID,
    DATEDIFF(@snapshot_date, MAX(InvoiceDate)) AS Recency,
    COUNT(DISTINCT InvoiceNo) AS Frequency,
    ROUND(SUM(Quantity * UnitPrice), 2) AS Monetary
FROM online_retail
GROUP BY CustomerID
ORDER BY Monetary DESC;

Step 5: Save RFM Table
CREATE TABLE rfm_scores AS
SELECT
    CustomerID,
    DATEDIFF(@snapshot_date, MAX(InvoiceDate)) AS Recency,
    COUNT(DISTINCT InvoiceNo) AS Frequency,
    ROUND(SUM(Quantity * UnitPrice), 2) AS Monetary
FROM online_retail
GROUP BY CustomerID;
