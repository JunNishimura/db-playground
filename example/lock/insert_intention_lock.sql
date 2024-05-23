-- [Prepare]
INSERT INTO users (id, name, age) VALUES (10, 'Alice', 20), (20, 'Bob', 30), (30, 'Charlie', 40);

-- [Test1]
-- check to see if gap lock is not compatible with insert intention lock
-- Transaction 1
BEGIN;
SELECT * FROM users WHERE id = 15 FOR UPDATE;
-- Transaction 2
BEGIN;
INSERT INTO users (id, name, age) VALUES (15, 'David', 50);
-- Transaction 1
SELECT * FROM performance_schema.data_locks\G;
ROLLBACK;
-- Transaction 2
SELECT * FROM performance_schema.data_locks\G;
ROLLBACK;

-- [Test2]
-- check to see if insert record changes the range of gap lock
-- Transaction 1
BEGIN;
INSERT INTO users (id, name, age) VALUES (15, 'David', 50);
-- Transaction 2
BEGIN;
SELECT * FROM users WHERE id = 13 FOR UPDATE;
-- Transaction 1
SELECT * FROM performance_schema.data_locks\G;
ROLLBACK;
-- Transaction 2
ROLLBACK;

-- get next-key lock
-- Transaction 1
BEGIN;
UPDATE users SET age = 21 WHERE id > 11 and id < 19;

-- [Close]
DELETE FROM users;