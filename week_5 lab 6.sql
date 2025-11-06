create database if not exists week_6;
use week_6;

-- query 1. Using Scheme diagram, Create tables by properly specifying the
-- primary keys and the foreign keys.

create table employee(empno int primary key,ename varchar(30),mgr_no int,hiredate date,sal int,deptno int);

alter table employee
add constraint fk_employeeupdated
foreign key (deptno) references dept(deptno)
on delete cascade;

create table dept(deptno int primary key,dname varchar(30),dloc varchar(30));

create table incentives(empno int,incentive_date date,incentive_amount int,primary key(empno,incentive_date),foreign key(empno) references employee(empno),on delete cascade);

create table project(pno int primary key,ploc varchar(30),pname varchar(30));

create table assigned_to(empno int,pno int,job_role varchar(30),primary key(empno,pno),foreign key(empno) references employee(empno)  on delete cascade on update cascade,
foreign key(pno) references project(pno) on delete cascade on update cascade);assigned_toassigned_to
-- query 1 end

-- query 2. Enter greater than five tuples for each table.
INSERT INTO dept VALUES (10,'ACCOUNTING','MUMBAI');
INSERT INTO dept VALUES (20,'RESEARCH','BENGALURU');
INSERT INTO dept VALUES (30,'SALES','DELHI');
INSERT INTO dept VALUES (40,'OPERATIONS','CHENNAI');

INSERT INTO employee VALUES (7369,'Adarsh',7902,'2012-12-17','80000.00','20');
INSERT INTO employee VALUES (7499,'Shruthi',7698,'2013-02-20','16000.00','30');
INSERT INTO employee VALUES (7521,'Anvitha',7698,'2015-02-22','12500.00','30');
INSERT INTO employee VALUES (7566,'Tanvir',7839,'2008-04-02','29750.00','20');
INSERT INTO employee VALUES (7654,'Ramesh',7698,'2014-09-28','12500.00','30');
INSERT INTO employee VALUES (7698,'Kumar',7839,'2015-05-01','28500.00','30');
INSERT INTO employee VALUES (7782,'CLARK',7839,'2017-06-09','24500.00','10');
INSERT INTO employee VALUES (7788,'SCOTT',7566,'2010-12-09','30000.00','20');
INSERT INTO employee VALUES ('7839','KING',NULL,'2009-11-17','500000.00','10');
INSERT INTO employee VALUES ('7876','ADAMS',7788,'2013-01-12','11000.00','20');
INSERT INTO employee VALUES ('7900','JAMES',7698,'2017-12-03','9500.00','30');
INSERT INTO employee VALUES ('7902','FORD','7566','2010-12-03','30000.00','20');

INSERT INTO incentives VALUES(7499,'2019-02-01',5000.00);
INSERT INTO incentives VALUES(7521,'2019-03-01',2500.00);
INSERT INTO incentives VALUES(7566,'2022-02-01',5070.00);
INSERT INTO incentives VALUES(7654,'2020-02-01',2000.00);	
INSERT INTO incentives VALUES(7654,'2022-04-01',879.00);
INSERT INTO incentives VALUES(7521,'2019-02-01',8000.00);
INSERT INTO incentives VALUES(7698,'2019-03-01',500.00);
INSERT INTO incentives VALUES(7698,'2020-03-01',9000.00);
INSERT INTO incentives VALUES(7698,'2022-04-01',4500.00);

INSERT INTO project VALUES(101,'AI Project','BENGALURU');
INSERT INTO project VALUES(102,'IOT','HYDERABAD');
INSERT INTO project VALUES(103,'BLOCKCHAIN','BENGALURU');
INSERT INTO project VALUES(104,'DATA SCIENCE','MYSURU');
INSERT INTO project VALUES(105,'AUTONOMUS SYSTEMS','PUNE');

INSERT INTO assigned_to VALUES(7499,101,'Software Engineer');
INSERT INTO assigned_to VALUES(7521,101,'Software Architect');
INSERT INTO assigned_to VALUES(7566,101,'Project Manager');
INSERT INTO assigned_to VALUES(7654,102,'Sales');
INSERT INTO assigned_to VALUES(7521,102,'Software Engineer');
INSERT INTO assigned_to VALUES(7499,102,'Software Engineer');
INSERT INTO assigned_to VALUES(7654,103,'Cyber Security');
INSERT INTO assigned_to VALUES(7698,104,'Software Engineer');
INSERT INTO assigned_to VALUES(7900,105,'Software Engineer');
INSERT INTO assigned_to VALUES(7839,104,'General Manager');

Select * from dept;
select * from employee;
select * from incentives;
select * from project;
select * from assigned_to;
-- query 2 end

-- query 3:Retrieve the employee numbers of all employees who work on
-- project located in Bengaluru, Hyderabad, or Mysuru

select employee.empno,project.pname 
from employee,project,assigned_to
where assigned_to.empno=employee.empno and assigned_to.pno=project.pno
and project.pname in ("BENGALURU","HYDERABAD","MYSURU");

-- query 4. Get Employee ID’s of those employees who didn’t receive incentives

select empno 
from employee
where empno not in(
select i.empno 
from incentives  i
);

-- query 5. Write a SQL query to find the employees name, number, dept,
-- job_role, department location and project location who are working for
-- a project location same as his/her department location.

select 
emp.ename,emp.empno,d.dname,a.job_role,d.dloc,p.pname
from employee emp
join dept d on emp.deptno=d.deptno
join assigned_to a on a.empno=emp.empno
join project p on p.pno=a.pno
where p.pname=d.dloc;

