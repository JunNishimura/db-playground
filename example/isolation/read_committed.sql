-- set the transaction isolation level read committed;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- [Prepare]
INSERT INTO users (name, age) VALUES ('Alice', 20), ('Bob', 30), ('Charlie', 40), ('David', 50), ('Eve', 60), ('Frank', 70), ('Grace', 80), ('Helen', 90), ('Ivy', 100), ('Jack', 110);

-- [Test1]
-- check to see if dirty read does not occur
-- Transaction 1
BEGIN;
SELECT * FROM users WHERE name = 'Alice';
-- Transaction 2
BEGIN;
UPDATE users SET age = 21 WHERE name = 'Alice';
-- Transaction 1
SELECT * FROM users WHERE name = 'Alice';
-- Transaction 2
ROLLBACK;
-- Transaction 1
ROLLBACK;

-- [Test2]
-- check to see if fuzzy read occurs
-- Transaction 1
BEGIN;
SELECT * FROM users WHERE name = 'Alice';
-- Transaction 2
BEGIN;
UPDATE users SET age = 21 WHERE name = 'Alice';
-- Transaction 1
SELECT * FROM users WHERE name = 'Alice';
-- Transaction 2
COMMIT;
-- Transaction 1
SELECT * FROM users WHERE name = 'Alice';
ROLLBACK;

-- [Test3]
-- check to see if phantom read occurs
-- Transaction 1
BEGIN;
SELECT COUNT(*) FROM users;
-- Transaction 2
BEGIN;
INSERT INTO users (name, age) VALUES ('Kate', 120);
-- Transaction 1
SELECT COUNT(*) FROM users;
-- Transaction 2
COMMIT;
-- Transaction 1
SELECT COUNT(*) FROM users;
ROLLBACK;

-- [Close]
DELETE FROM users;

-- back to the default isolation level
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;