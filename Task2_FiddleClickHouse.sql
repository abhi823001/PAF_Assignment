SELECT 
    e.enquiry_id, 
    e.date, 
    e.user_id, 
    COALESCE(groupArray(t.txn_id), []) AS txn_ids
FROM enquiries e
LEFT JOIN (
    SELECT DISTINCT ON (t1.txn_id) 
        t1.txn_id, t1.user_id, t1.date, e1.enquiry_id
    FROM txns t1
    JOIN enquiries e1
        ON t1.user_id = e1.user_id
        AND t1.date BETWEEN e1.date AND e1.date + INTERVAL 30 DAY
    ORDER BY t1.txn_id, e1.date ASC -- Ensures the earliest enquiry is selected
) t ON e.enquiry_id = t.enquiry_id
GROUP BY e.enquiry_id, e.date, e.user_id;