--1)Write a query to find the all the names which are similar in pronouncing as suresh, sort the result in the order of similarity
select empname from employees 
where soundex(EmpName) = soundex('suresh') or difference(empname, 'suresh')>=3
order by difference(empname, 'suresh') desc;

--2)write a query to find second highest salary in organisation without using subqueries and top
with cte as(select empid,empname,salary,dense_rank()over(order by salary desc) as rnk from employees)
select empid,empname,salary from cte where rnk=2

--3)write a query to find max salary and dep name from all the dept with out using top and limit
select d.deptid,d.deptname,max(e.salary) as max_salary from departments d 
left join employees e on d.deptid=e.deptid group by d.deptid,d.deptname

--4)Write a SQL query to maximum number from a table without using MAX or MIN aggregate functions.
--Consider the numbers as mentioned below:
--7859
--6897
--9875
--8659
--7600
--7550
create table Qno_4(
val int);
insert into Qno_4 values(7859),
						(6897),
						(9875),
						(8659),
						(7600),
						(7550)
select val from Qno_4 where val >= all(select val from Qno_4)

--5) Write an SQL query to fetch all the Employees who are also managers from the Employee Details table.
select distinct m.empid ,m.empname from employees e join employees m on e.managerid = m.empid

