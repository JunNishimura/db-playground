-- set transaction isolation level repeatable read;
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- [Prepare]
INSERT INTO users (name, age) VALUES ('Alice', 20), ('Bob', 30), ('Charlie', 40), ('David', 50), ('Eve', 60), ('Frank', 70), ('Grace', 80), ('Helen', 90), ('Ivy', 100), ('Jack', 110);

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

-- check to see if fuzzy read does not occur
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

-- check to see if phantom read does not occur
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