create database module10;
use module10;
drop table employees;
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2)
);

select * from employees;
INSERT INTO employees (id, name, salary) VALUES (1, 'Alice', 50000);
INSERT INTO employees (id, name, salary) VALUES (2, 'Bob', 60000);

select * from employees;
-- begin marks the start the transaction
-- changes made after this begin are temporary untill committed
-- commit is userd to permanently save all the changes made in transaction
-- rollback

BEGIN;

INSERT INTO employees (id, name, salary) VALUES (3, 'A', 50000);
INSERT INTO employees (id, name, salary) VALUES (4, 'B', 60000);
INSERT INTO employees (id, name, salary) VALUES (5, 'c', 50000);
INSERT INTO employees (id, name, salary) VALUES (6, 'd', 60000);
update  employees
set name='renu'
where id=1;
update employees
set salary=salary+5000
where id=1;
INSERT INTO employees (id, name, salary) VALUES (7, 'A', 50000);
INSERT INTO employees (id, name, salary) VALUES (8, 'B', 60000);
delete from employees
where id=1;

commit;
select * from employees;

begin;
truncate employees;

ROLLBACK;

select * from employees;
drop table employees;


-- 2nd example
BEGIN;

INSERT INTO employees (id, name, salary) VALUES (3, 'A', 50000);
INSERT INTO employees (id, name, salary) VALUES (4, 'B', 60000);
INSERT INTO employees (id, name, salary) VALUES (5, 'c', 50000);
INSERT INTO employees (id, name, salary) VALUES (6, 'd', 60000);
update  employees
set name='renu'
where id=1;
update employees
set salary=salary+500
where id=1;
select * from employees;

rollback;
select * from employees;

-- save point

drop table employees;

INSERT INTO employees (id, name, salary) VALUES (1, 'Alice', 50000);
INSERT INTO employees (id, name, salary) VALUES (2, 'Bob', 60000);

BEGIN;

INSERT INTO employees (id, name, salary) VALUES (3, 'A', 50000);
INSERT INTO employees (id, name, salary) VALUES (4, 'B', 60000);
INSERT INTO employees (id, name, salary) VALUES (5, 'c', 50000);
INSERT INTO employees (id, name, salary) VALUES (6, 'd', 60000);

savepoint s1;

update  employees
set name='renu'
where id=1;

savepoint s2;

update employees
set salary=salary+500
where id=1;
-- insert

rollback to savepoint s1;   -- after the check point all the transaction are rollback

select * from employees;
 