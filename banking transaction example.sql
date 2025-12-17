--  Here's a simple example of a banking transaction in MySQL using 
 transaction control to transfer money between two accounts. 
 This ensures that either both updates succeed or none do — preserving data integrity.



create database transaction ;
use transaction;
drop database transaction;
CREATE TABLE accounts (
    account_id VARCHAR(10) PRIMARY KEY,
    account_holder VARCHAR(100),
    balance DECIMAL(10,2) NOT NULL DEFAULT 0.00
);
INSERT INTO accounts (account_id, account_holder, balance) VALUES
('A123', 'Amit', 10000.00),
('B456', 'Aditya', 5000.00),
('C789', 'Tushar', 2000.00);
CREATE TABLE transactions(
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    from_account VARCHAR(10),
    to_account VARCHAR(10),
    transaction_type ENUM('debit', 'credit') NOT NULL, -- The column can store ONLY these two values:
    amount DECIMAL(10,2),
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    description VARCHAR(255),
    FOREIGN KEY (from_account) REFERENCES accounts(account_id),
    FOREIGN KEY (to_account) REFERENCES accounts(account_id)

);
drop table transactions;
select * from accounts;


⚠️ Important Notes: for this banking example i use "if else condition" to check whether 
the account holder have sufficient balance or not . For this i use 
IF...THEN...ELSE...END IF syntax  
And this syntax only works inside stored programs, such as:

Stored procedures
Functions
Triggers
Events
if else condition  does not work directly in a MySQL  script unless it's inside a stored program.
 That's why i use stored procedure here  to explain this transaction control statement.
  One more thing i want to  mentioned here ,I use  
ROW_COUNT() function here to get the number of rows affected by the most recent DML operation.
And I also used one variable here i.e "row_changed" to hold the value of row_count() function 

DELIMITER $$

CREATE PROCEDURE ttransfer_funds15()
BEGIN
    DECLARE rows_changed INT;

    START TRANSACTION;

    -- Step 1:  Check balance of A123(amit)
    
    SELECT balance FROM accounts WHERE account_id = 'A123';
    -- Step 2: Attempt to deduct ₹2000 (will fail if balance < 2000)
     insert into accounts values ('e129','renu',3000);
    UPDATE accounts
    SET balance = balance - 2000
    WHERE account_id = 'A123' AND balance >= 2000;
    
    -- Step 3: Check if deduction succeeded or not 
     -- If no rows were affected, rollback
     -- otherwise add amount to second user 

    SET rows_changed = ROW_COUNT();  --  1
   IF rows_changed = 0 THEN
        ROLLBACK;
        select 'User have insufficient balance' as message;
    ELSE
        -- Step 5: Credit B456 and log transaction
        UPDATE accounts
        SET balance = balance + 2000
        WHERE account_id = 'B456';

        -- Step 6: Log transaction
        INSERT INTO transactions (from_account, to_account,transaction_type, amount,description)
        VALUES ('A123', 'B456','debit', 2000, CONCAT('Transfer to ', to_account));

        COMMIT;
        select 'transaction successful' as message;
    END IF;
END$$

DELIMITER ;

call ttransfer_funds15();
select * from accounts;
select * from transactions;

 -- SECOND EXAMPLE with error handling  HAVING INSUFFICIENT BALANCE 
 
  -- suppose i want to snd  5000 from tushar acc to Amit account 
 DELIMITER $$

CREATE PROCEDURE tttransfer_funds15()
BEGIN
    DECLARE rows_changed INT;

    START TRANSACTION;

    -- Step 1:  Check balance of A123
    SELECT balance FROM accounts WHERE account_id = 'C789';
    -- Step 2: Attempt to deduct ₹2000 (will fail if balance < 2000)
    insert into accounts values ('ee122','ritu',3000);
    
    UPDATE accounts
    SET balance = balance - 5000
    WHERE account_id = 'C789' AND balance >= 5000;
    
    -- Step 3: Check if deduction succeeded
     -- If no rows were affected, rollback

    SET rows_changed = ROW_COUNT();  -- 0
    
    IF rows_changed = 0 THEN
        ROLLBACK;
        select 'Tushar have insufficient balance' as message;
    ELSE
        -- Step 5: Credit B456 and log transaction
        UPDATE accounts
        SET balance = balance + 5000
        WHERE account_id = 'A123';

        -- Step 6: Log transaction
        INSERT INTO transactions (from_account, to_account, amount,description)
        VALUES ('C789', 'A123', 5000, CONCAT('Transfer to ', to_account));

        COMMIT;
        select 'transaction successful' as message;
    END IF;
END$$

DELIMITER ;

-- AS WE CAN SEE NO ROW IS EFFECTED By STRORED PROCEDURE MEANS  command ROLLBACK IS executed 

call tttransfer_funds15();
-- LETS CHECK WITH TABLES ASWELL 

select * from accounts;
--  YOU CAN SEE Tushar account is not updated and AMIT account is also not updated due to insufficient balane 
select * from transactions;
