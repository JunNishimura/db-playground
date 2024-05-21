-- [Prepare]
INSERT INTO users (name, age) VALUES ('Alice', 20), ('Bob', 30), ('Charlie', 40), ('David', 50), ('Eve', 60), ('Frank', 70), ('Grace', 80), ('Helen', 90), ('Ivy', 100), ('Jack', 110);

-- [Test1]
-- check to see if cycle deadlock occurs
-- Transaction 1
BEGIN;
UPDATE users SET age = 31 WHERE name = 'Bob';
-- Transaction 2
BEGIN;
UPDATE users SET age = 22 WHERE name = 'Alice';
-- Transaction 1
SELECT * FROM performance_schema.data_locks\G;
UPDATE users SET age = 21 WHERE name = 'Alice';
-- Transaction 2
SELECT * FROM performance_schema.data_locks\G;
UPDATE users SET age = 32 WHERE name = 'Bob';
-- check deadlock
SHOW ENGINE INNODB STATUS\G
-- Transaction 1
ROLLBACK;

-- [Test2]
-- check to see if cycle deadlock does not occur
-- Transaction 1
BEGIN;
UPDATE users SET age = 21 WHERE name = 'Alice';
-- Transaction 2
BEGIN;
UPDATE users SET age = 22 WHERE name = 'Alice';
-- Transaction 1
SELECT * FROM performance_schema.data_locks\G;
UPDATE users SET age = 31 WHERE name = 'Bob';
ROLLBACK;
-- Transaction 2
SELECT * FROM performance_schema.data_locks\G;
UPDATE users SET age = 32 WHERE name = 'Bob';
-- Transaction 2
ROLLBACK;

-- [Close]
DELETE FROM users;