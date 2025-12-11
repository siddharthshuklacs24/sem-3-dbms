create database supplier;
use supplier;


-- query 1: Using Scheme diagram, Create tables by properly specifying the primary keys and the foreign keys.

create table SUPPLIERS(sid integer(5) primary key, sname varchar(20), city
varchar(20));
desc SUPPLIERS;
create table PARTS(pid integer(5) primary key, pname varchar(20), color varchar(10));
desc PARTS;
create table CATALOG(sid integer(5), pid integer(5), foreign key(sid)
references SUPPLIERS(sid), foreign key(pid) references PARTS(pid), cost
float(6), primary key(sid, pid));
desc CATALOG;

-- query 2. Insert appropriate records in each table.


insert into suppliers values(10001,  'Acme Widget','Bangalore');
insert into suppliers values(10002,  'Johns','Kolkata');
insert into suppliers values(10003,  'Vimal','Mumbai');
insert into suppliers values(10004, 'Reliance','Delhi');
insert into suppliers values(10005, 'Mahindra','Mumbai');
select * from SUPPLIERS;
commit;


insert into PARTS values(20001, 'Book','Red');
insert into PARTS values(20002, 'Pen','Red');
insert into PARTS values(20003, 'Pencil','Green');
insert into PARTS values(20004, 'Mobile','Green');
insert into PARTS values(20005, 'Charger','Black');
select * from PARTS;

insert into CATALOG values(10001, 20001,10);
insert into CATALOG values(10001, 20002,10);
insert into CATALOG values(10001, 20003,30);
insert into CATALOG values(10001, 20004,10);
insert into CATALOG values(10001, 20005,10);
insert into CATALOG values(10002, 20001,10);
insert into CATALOG values(10002, 20002,20);
insert into CATALOG values(10003, 20003,30);
insert into CATALOG values(10004, 20003,40);
select * from CATALOG;

-- query 3. Find the pnames of parts for which there is some supplier.
select distinct(p.pname)
from parts p
left join catalog c 
on p.pid=c.pid
where c.sid in(select sid from suppliers);

-- query 4. Find the snames of suppliers who supply every part.
select  s.sname
from catalog c
left join suppliers s 
on s.sid=c.sid
group by sname
having count(distinct(c.pid))=(select count(*) from parts);

-- query 5. Find the snames of suppliers who supply every red part.
select  s.sname
from catalog c
left join suppliers s 
on s.sid=c.sid
group by sname
having count(distinct(c.pid))>=(select count(*) from parts
where color='red');

-- query 6. Find the pnames of parts supplied by Acme Widget Suppliers and by no
-- one else.
select pname
from parts 
where pid in(
select c.pid
from catalog c
join suppliers s
on s.sid=c.sid
where s.sname='Acme Widget'
and c.pid not in(select c2.pid from catalog c2  join suppliers s2 on s2.sid=c2.sid where s2.sname!='Acme Widget'));

-- query 7. Find the sids of suppliers who charge more for some part than the average
-- cost of that part (averaged over all the suppliers who supply that part).

select s.sid 
from catalog c,suppliers s,(select pid,avg(cost) as mean from catalog group by pid) ct
where c.sid=s.sid and c.pid=ct.pid and c.cost>ct.mean;

-- query 8:for each part,find the name of the supplier who charges the most for that part.-- 

select c.pid,s.sname
from catalog c,suppliers s ,(select pid ,max(cost) as mx 
from catalog group by pid)
 cmax where c.sid=s.sid and cmax.pid=c.pid and c.cost=cmax.mx;


-- additional queries on suppliers database
 
--  query-1:find the most expensive part overall and the supplier who supplies it

select p.pname,p.pid,c.cost,s.sid,s.sname from catalog c
join parts p on p.pid=c.pid
join suppliers s on s.sid=c.sid
where c.cost =(select max(cost) from catalog);

-- query-2:. Find suppliers who do NOT supply any red parts.-- 
select sid,sname from suppliers
where sid in(
select sid from catalog 
where pid in
(select pid from parts 
where color='red'));

-- query-3: Show each supplier and total value of all parts they supply.


select c.sid,s.sname,sum(c.cost) as total_value
from catalog  c
join suppliers s on c.sid=s.sid
group by sid ;

-- query-4: Find suppliers who supply at least 2 parts cheaper than ₹20.
select sname,sid from suppliers
where sid in(
with sid_num as(
select  sid from catalog
where cost<=20)
select sid from sid_num
group by sid
having count(sid)>=2);

-- query-5: List suppliers who offer the cheapest cost for each part.


with pid_grouped as(
select pid,min(cost) as min_cost
from catalog
group by pid
)
select c.sid,s.sname,pg.pid,pg.min_cost
from catalog c
join suppliers s on s.sid=c.sid 
join pid_grouped pg on c.pid=pg.pid and c.cost=pg.min_cost;


-- query 7:create a view showing suppliers and the total numbers of parts they supply.

create view Total_parts (S_name,Total_parts)
as
select sid,count(sid)
from catalog
group by sid;
select * from Total_parts;
drop view Total_parts;

-- query 8:create a view of the most expensive supplier for each part

create view Max_charge (S_name,P_id)
as
select S.sname,C.pid
from catalog C,suppliers S,(select pid, max(cost) as Mx from catalog group by pid) Cmax
where C.sid=S.sid and Cmax.pid=C.pid and C.Cost=Cmax.Mx;
select * from Max_charge;

-- query 9:create a trigger to set to default cost if not provided


DELIMITER $$
create trigger t2 
before insert on catalog
for each row
begin
if new.cost is null
then set new.cost=default(cost);
end if;
end$$
DELIMITER ;

