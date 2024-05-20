-- [Prepare]
INSERT INTO users (name, age) VALUES ('Alice', 20), ('Bob', 30), ('Charlie', 40), ('David', 50), ('Eve', 60), ('Frank', 70), ('Grace', 80), ('Helen', 90), ('Ivy', 100), ('Jack', 110);

-- [Test1]
-- check to see if secondary index is locked
BEGIN;
SELECT name FROM users WHERE name = 'Alice' FOR SHARE;
SELECT * FROM performance_schema.data_locks\G
ROLLBACK;

-- [Test2]
-- check to see if both clustered index and secondary index are locked
BEGIN;
SELECT age FROM users WHERE name = 'Alice' FOR SHARE;
SELECT * FROM performance_schema.data_locks\G
ROLLBACK;

-- [Test3]
-- check to see if two transactions are trying to acquire a shared lock on the same row
-- Transaction 1
BEGIN;
SELECT name FROM users WHERE name = 'Alice' FOR SHARE;
-- Transaction 2
BEGIN;
SELECT name FROM users WHERE name = 'Alice' FOR SHARE;
-- Transaction 1
SELECT * FROM performance_schema.data_locks\G
ROLLBACK;
-- Transaction 2
ROLLBACK;

-- [Close]
DELETE FROM users;