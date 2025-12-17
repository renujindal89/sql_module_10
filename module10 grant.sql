use db2;

 -- grant means give previliage to other user like who can access our database 
 -- like who can only raed our data 
 -- like who can delete our data 
 -- DBA  has full control on our database 
 -- out side user  can only read my data 
 -- Analyst CAN READ AND WRITE in our database but not allowed to delete any record 
 
CREATE USER 'admin3_user'@'localhost' IDENTIFIED BY 'complere@1234';

select * from employee2;
grant select on db2.employee2 to 'admin3_user'@'localhost';

revoke select on db2.employee2 from  'admin3_user'@'localhost';

grant select,insert,delete,update on  db2.employee2 to 'admin3_user'@'localhost';

GRANT ALL PRIVILEGES ON db2.* TO 'admin3_user'@'localhost';

