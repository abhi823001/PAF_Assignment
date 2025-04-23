----Task2 code----
----Create output2 table same as required schema----

Create Table output2(
 enquiry_id varchar(40),
 date Date,
 user_id varchar(40),
 txn_ids varchar(40)
 ) ENGINE = Memory;

----Insert records into this table -----

WITH RankedEnquiries AS (
    SELECT
        t.txn_id,
        t.date AS txn_date,
        e.enquiry_id,
        e.date AS enquiry_date,
        e.user_id,
        ROW_NUMBER() OVER (PARTITION BY t.txn_id ORDER BY e.date ASC) AS Ranks
    FROM txns t
    JOIN enquiries e
    ON t.user_id = e.user_id
       AND t.date BETWEEN e.date AND e.date + INTERVAL 30 DAY
),
FilteredEnquiries AS (
    SELECT
        txn_id,
        enquiry_id,
        user_id,
        txn_date,
        enquiry_date
    FROM RankedEnquiries
    WHERE ranks = 1
)
SELECT
    e.enquiry_id,
    e.date AS enquiry_date,
    e.user_id,
    COALESCE(JSON_ARRAYAGG(f.txn_id), JSON_ARRAY()) AS txn_ids
FROM enquiries e
LEFT JOIN FilteredEnquiries f
ON e.enquiry_id = f.enquiry_id
GROUP BY e.enquiry_id, e.date, e.user_id;