import pandas as pd
import mysql.connector

# Connect to MySQL
conn = mysql.connector.connect(
    host='localhost',
    user='root',
    password='yourpassword',
    database='retail_rfm'
)

# Load RFM table
rfm_df = pd.read_sql("SELECT * FROM rfm_scores", conn)

# RFM Scoring
rfm_df['R_Score'] = pd.qcut(rfm_df['Recency'], 4, labels=[4,3,2,1])
rfm_df['F_Score'] = pd.qcut(rfm_df['Frequency'].rank(method='first'), 4, labels=[1,2,3,4])
rfm_df['M_Score'] = pd.qcut(rfm_df['Monetary'], 4, labels=[1,2,3,4])

# Combine into RFM Segment
rfm_df['RFM_Segment'] = rfm_df['R_Score'].astype(str) + rfm_df['F_Score'].astype(str) + rfm_df['M_Score'].astype(str)
rfm_df['RFM_Score'] = rfm_df[['R_Score','F_Score','M_Score']].sum(axis=1)

# Define Segments
def segment(row):
    if row['RFM_Score'] >= 9:
        return 'Best Customers'
    elif row['RFM_Score'] >= 8:
        return 'Loyal Customers'
    elif row['RFM_Score'] >= 5:
        return 'Potential Loyalists'
    else:
        return 'At Risk'
    
rfm_df['Segment'] = rfm_df.apply(segment, axis=1)

# Save to CSV for Power BI
rfm_df.to_csv("rfm_final.csv", index=False)

print(rfm_df.head())
