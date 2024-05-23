-- [Prepare]
INSERT INTO users (id, name, age) VALUES (10, 'Alice', 20), (20, 'Bob', 30), (30, 'Charlie', 40);

-- [Test1]
-- check to see if next-key lock is acquired
BEGIN;
SELECT name FROM users WHERE name > 'Alice' AND name < 'Bob' FOR UPDATE;
SELECT * FROM performance_schema.data_locks\G;
ROLLBACK;

-- [Test2]
-- check to see if next-key lock is not compatible with exclusive lock
-- Transaction 1
BEGIN;
SELECT name FROM users WHERE name > 'Alice' AND name < 'Bob' FOR UPDATE;
-- Transaction 2
BEGIN;
SELECT name FROM users WHERE name = 'Bob' FOR UPDATE;
-- Transaction 1
SELECT * FROM performance_schema.data_locks\G;
ROLLBACK;
-- Transaction 2
SELECT * FROM performance_schema.data_locks\G;
ROLLBACK;

-- [Test3]
-- check to see if next-key lock is not compatible with insert intention lock
-- Transaction 1
BEGIN;
SELECT name FROM users WHERE name > 'Alice' AND name < 'Bob' FOR UPDATE;
-- Transaction 2
BEGIN;
INSERT INTO users (id, name, age) VALUES (15, 'Boa', 50);
-- Transaction 1
SELECT * FROM performance_schema.data_locks\G;
ROLLBACK;
-- Transaction 2
ROLLBACK;

-- [Test4]
-- check to see if edge case of next-key lock is acquired
-- Transaction 1
BEGIN;
SELECT name FROM users WHERE name > 'Alice' AND name <= 'Bob' FOR UPDATE;
-- Transaction 2
BEGIN;
INSERT INTO users (id, name, age) VALUES (15, 'Charl', 50);
-- Transaction 1
SELECT * FROM performance_schema.data_locks\G;
ROLLBACK;
-- Transaction 2
ROLLBACK;


-- [Close]
DELETE FROM users;