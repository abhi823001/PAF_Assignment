# PAF_Assignment
#####Task1 approach#######
### **Step 1: Union All**
1. Combines the results from the two parts of the inner query:
   - Enquiries data (`enquiry_count` with `transaction_count` as `0`).
   - Transactions data (`transaction_count` with `enquiry_count` as `0`).
2. `UNION ALL` ensures that both sets of data are included without removing duplicates

### **Step 2: Aggregate**
   - Aggregates data to calculate the total number of enquiries and transactions for each user (`user_id`) and each date (`date`).
   - The sums for `enquiry_count` and `transaction_count` are calculated from the results of the inner query.

#####Task2 approach#####
### **Step 1: LEFT JOIN**
Joins two tables to read all the enquirires with the transaction ids.

### **Step 2: Sub Query with Distinct transaction ids**
1. This subquery identifies transactions (txns) that fall within a 30-day window after an enquiry.
2. The DISTINCT ON (t1.txn_id) ensures that each transaction is linked to only one enquiry—the earliest one.
3. ORDER BY t1.txn_id, e1.date ASC ensures that for each transaction, the enquiry chosen is the earliest available.






