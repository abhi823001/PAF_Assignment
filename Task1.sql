----Task1 Code----------
---create output1 table for task 1

CREATE TABLE output1 (
    user_id    String,
    date Date,
    count_enqs Integer,
    count_txns Integer
) ENGINE=Memory;

-----Insert records in the output1 table for task1

Insert into output1
SELECT 
    user_id, 
    date, 
    SUM(enquiry_count) AS enquiry_count, 
    SUM(transaction_count) AS transaction_count
FROM (
    SELECT 
        user_id, 
        date, 
        COUNT(*) AS enquiry_count, 
        0 AS transaction_count
    FROM enquiries
    GROUP BY user_id, date
    
    UNION ALL
    
    SELECT 
        user_id, 
        date, 
        0 AS enquiry_count, 
        COUNT(*) AS transaction_count
    FROM txns
    GROUP BY user_id, date
) t
GROUP BY user_id, date;

Select * from output1;

