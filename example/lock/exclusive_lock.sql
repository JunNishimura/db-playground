-- [Prepare]
INSERT INTO users (name, age) VALUES ('Alice', 20), ('Bob', 30), ('Charlie', 40), ('David', 50), ('Eve', 60), ('Frank', 70), ('Grace', 80), ('Helen', 90), ('Ivy', 100), ('Jack', 110);

-- [Test1]
-- check to see if exclusive lock is acquired
BEGIN;
SELECT name FROM users WHERE name = 'Alice' FOR UPDATE;
SELECT * FROM performance_schema.data_locks\G;
ROLLBACK;

-- [Test2]
-- check to see if exclusive lock is acquired for UPDATE statement
BEGIN;
UPDATE users SET age = 21 WHERE name = 'Alice';
SELECT * FROM performance_schema.data_locks\G;
ROLLBACK;

-- [Test3]
-- check to see if shared lock and exclusive lock are incompatible
-- Transaction 1
BEGIN;
SELECT name FROM users WHERE name = 'Alice' FOR SHARE;
-- Transaction 2
BEGIN;
SELECT name FROM users WHERE name = 'Alice' FOR UPDATE;
-- Transaction 1
SELECT * FROM performance_schema.data_locks\G;
ROLLBACK;
-- Transaction 2
SELECT * FROM performance_schema.data_locks\G;
ROLLBACK;

-- [Test4]
-- check to see if exclusive locks are incompatible
-- Transaction 1
BEGIN;
SELECT name FROM users WHERE name = 'Alice' FOR UPDATE;
-- Transaction 2
BEGIN;
SELECT name FROM users WHERE name = 'Alice' FOR UPDATE;
-- Transaction 1
SELECT * FROM performance_schema.data_locks\G;
ROLLBACK;
-- Transaction 2
SELECT * FROM performance_schema.data_locks\G;
ROLLBACK;

-- [Close]
DELETE FROM users;