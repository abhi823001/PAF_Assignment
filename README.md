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

#####Task2 approach##### Using MYSQL
### **Step 1: RankedEnquiries**
The query starts with a Common Table Expression (CTE) named `RankedEnquiries`. Here's what it does:
1. **Purpose**: It associates each transaction (`txn_id`) with enquiries (`enquiry_id`) submitted by the same user (`user_id`) within a 30-day window before the transaction date (`txn_date`).
2. **Logic**:
   - `ROW_NUMBER() OVER (PARTITION BY t.txn_id ORDER BY e.date ASC)`:
     - Assigns a ranking (`Ranks`) to each enquiry for a given transaction, based on the enquiry date (`e.date`), prioritizing the **earliest enquiry first**.
   - `JOIN enquiries e ON t.user_id = e.user_id`:
     - Links transactions to enquiries where `user_id` matches.
   - `t.date BETWEEN e.date AND e.date + INTERVAL 30 DAY`:
     - Ensures that only enquiries submitted within 30 days prior to the transaction date are considered.
3. **Output**:
   - A list of transactions (`txn_id`) with their associated enquiries (`enquiry_id`), ranked by proximity to the transaction date.

---

### **Step 2: FilteredEnquiries**
Another CTE, `FilteredEnquiries`, filters the ranked data:
1. **Purpose**: Selects the **top-ranked enquiry (Ranks = 1)** for each transaction.
   - Ensures that each transaction is linked to only one enquiry.
2. **Logic**:
   - `WHERE ranks = 1`:
     - Filters out all enquiries except the earliest one for a transaction.
3. **Output**:
   - A filtered list of transactions (`txn_id`) and their associated enquiries (`enquiry_id`), ensuring **one enquiry per transaction**.

---

### **Step 3: Final Query**
In the final query:
1. **Purpose**:
   - For each enquiry (`e.enquiry_id`), aggregates all transactions (`txn_ids`) linked to it.
   - Allows a single enquiry to be linked to multiple transactions.
2. **Logic**:
   - `LEFT JOIN FilteredEnquiries f ON e.enquiry_id = f.enquiry_id`:
     - Joins the original enquiries table (`enquiries e`) with the filtered list of transactions (`FilteredEnquiries f`) on `enquiry_id`.
   - `COALESCE(JSON_ARRAYAGG(f.txn_id), JSON_ARRAY())`:
     - Aggregates all linked transaction IDs into a JSON array for each enquiry.
     - If no transactions are linked to an enquiry, returns an empty JSON array (`JSON_ARRAY()`).
   - `GROUP BY e.enquiry_id, e.date, e.user_id`:
     - Groups the results by enquiry ID (`enquiry_id`), enquiry date (`e.date`), and user ID (`e.user_id`).
3. **Output**:
   - Each enquiry, along with its linked transactions (`txn_ids`), is presented in the final output.



