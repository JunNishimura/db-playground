-- [Prepare]
INSERT INTO users (id, name, age) VALUES (10, 'Alice', 20), (20, 'Bob', 30), (30, 'Charlie', 40);

-- [Test1]
-- check to see if gap lock is not acquired for transaction isolation level READ UNCOMMITTED
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
SELECT * FROM users WHERE id = 15 FOR UPDATE;
SELECT * FROM performance_schema.data_locks\G;
ROLLBACK;

-- [Test2]
-- check to see if gap lock is acquired for transaction isolation level READ COMMITTED
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN;
SELECT * FROM users WHERE id = 15 FOR UPDATE;
SELECT * FROM performance_schema.data_locks\G;
ROLLBACK;

-- [Test3]
-- check to see if gap lock is acquired for transaction isolation level REPEATABLE READ
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN;
SELECT * FROM users WHERE id = 15 FOR UPDATE;
SELECT * FROM performance_schema.data_locks\G;
ROLLBACK;

-- [Test4]
-- check to see if gap lock is acquired for transaction isolation level SERIALIZABLE
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN;
SELECT * FROM users WHERE id = 15 FOR UPDATE;
SELECT * FROM performance_schema.data_locks\G;
ROLLBACK;

-- [Test5]
-- check to see if gap lock is compatible
-- Transaction 1
BEGIN;
SELECT * FROM users WHERE id = 15 FOR UPDATE;
-- Transaction 2
BEGIN;
SELECT * FROM users WHERE id = 15 FOR UPDATE;
-- Transaction 1
SELECT * FROM performance_schema.data_locks\G;
ROLLBACK;
-- Transaction 2
ROLLBACK;

-- [Close]
DELETE FROM users;