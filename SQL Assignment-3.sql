use [303]
--1. Select all departments in all locations where the Total Salary of a Department is Greater than twice the Average Salary for the department.
--And max basic for the department is at least thrice the Min basic for the department
create table dept (
    deptid int primary key,
    deptname varchar(100),
    location varchar(100)
);
create table emp (
    empid int primary key,
    empname varchar(100),
    deptid int,
    salary int,
    basicsal int,
    foreign key (deptid) references dept(deptid)
);
insert into dept (deptid, deptname, location) values
(1, 'hr', 'mumbai'),
(2, 'it', 'delhi'),
(3, 'sales', 'bangalore'),
(4, 'finance', 'chennai');
insert into emp (empid, empname, deptid, salary, basicsal) values
(101, 'alice', 1, 50000, 20000),
(102, 'bob',   1, 60000, 30000),
(103, 'cara',  1, 70000, 60000),
(104, 'dan',   2, 50000, 20000),
(105, 'eva',   2, 52000, 25000),
(106, 'frank', 3, 40000, 10000),
(107, 'gina',  3, 60000, 15000),
(108, 'hank',  3, 80000, 45000),
(109, 'ivy',   4, 40000, 25000);
select d.deptid,d.deptname,d.[location] from dept d 
join emp e on d.deptid=e.deptid group by d.deptid,d.deptname,d.[location]
having sum(e.salary)>2*avg(e.salary) and max(e.basicsal)>=3*min(e.basicsal)

--2. As per the companies rule if an employee has put up service of 1 Year 3 Months and 15 days in office, Then She/he would be eligible for a Bonus.
--the Bonus would be Paid on the first of the Next month after which a person has attained eligibility. Find out the eligibility date for all the employees. 
--And also find out the age of the Employee On the date of Payment of the First bonus. Display the Age in Years, Months, and Days.
--Also Display the weekday Name, week of the year, Day of the year and week of the month of the date on which the person has attained the eligibility
create table staff (
    staffid int primary key,
    staffname varchar(100),
    dob date,
    doj date
);
 
insert into staff (staffid, staffname, dob, doj) values
(1, 'alice', '1990-04-10', '2022-01-01'),
(2, 'bob', '1985-09-25', '2023-02-10'),
(3, 'charlie', '1995-12-15', '2021-05-20'),
(4, 'diana', '1988-07-08', '2020-11-15'),
(5, 'ethan', '1992-03-30', '2021-08-05')

with bonus_dates as (
    select
        staffid,
        staffname,
        dob,
        doj,
        dateadd(day, 15, dateadd(month, 3, dateadd(year, 1, doj))) as eligibility_date,
        datefromparts(
            year(dateadd(month, 1, dateadd(day, 15, dateadd(month, 3, dateadd(year, 1, doj))))),
            month(dateadd(month, 1, dateadd(day, 15, dateadd(month, 3, dateadd(year, 1, doj))))),
            1
        ) as bonus_payment_date
    from staff
)
select
    staffid,
    staffname,
    doj,
    dob,
    eligibility_date,
    bonus_payment_date,
 
    -- age in years
    case 
        when month(bonus_payment_date) > month(dob)
          or (month(bonus_payment_date) = month(dob) and day(bonus_payment_date) >= day(dob))
        then year(bonus_payment_date) - year(dob)
        else year(bonus_payment_date) - year(dob) - 1
    end as age_years,
 
    -- age in months
    case
        when day(bonus_payment_date) >= day(dob)
        then (datediff(month, dob, bonus_payment_date)) % 12
        else (datediff(month, dob, bonus_payment_date) - 1) % 12
    end as age_months,
 
    -- age in days
    case
        when day(bonus_payment_date) >= day(dob)
        then day(bonus_payment_date) - day(dob)
        else day(eomonth(dateadd(month, -1, bonus_payment_date))) + day(bonus_payment_date) - day(dob)
    end as age_days,
 
    datename(weekday, eligibility_date) as eligibility_weekday,
    datepart(week, eligibility_date) as eligibility_week_of_year,
    datepart(dayofyear, eligibility_date) as eligibility_day_of_year,
    ((datepart(day, eligibility_date) - 1) / 7) + 1 as eligibility_week_of_month
 
from bonus_dates;

--3. Company Has decided to Pay a bonus to all its employees. The criteria is as follows
--a. Service Type 1. Employee Type 1. Minimum service is 10. Minimum service left should be 15 Years. Retirement age will be 60 Years
--b. Service Type 1. Employee Type 2. Minimum service is 12. Minimum service left should be 14 Years . Retirement age will be 55 Years
--c. Service Type 1. Employee Type 3. Minimum service is 12. Minimum service left should be 12 Years . Retirement age will be 55 Years
--d. for Service Type 2,3,4 Minimum Service should Be 15 and Minimum service left should be 20 Years . Retirement age will be 65 Years
--Write a query to find out the employees who are eligible for the bonus.

create table staff_roster (
    staff_id int primary key,
    staff_name varchar(100),
    birth_date date,
    join_date date,
    emp_category int,         
    service_class int,       
    work_centre varchar(50),
    current_status varchar(20) 
);
insert into staff_roster values
(101, 'alice',  '1980-08-05', '2010-07-01', 1, 1, 'centre-a', 'active'),
(102, 'bob',    '1985-02-20', '2013-01-15', 2, 1, 'centre-b', 'active'),
(103, 'charlie','1990-11-11', '2012-06-01', 3, 1, 'centre-b', 'active'),
(104, 'daisy',  '1972-05-30', '2005-03-20', 2, 2, 'centre-c', 'active'),
(105, 'ethan',  '1988-09-25', '2009-09-01', 1, 3, 'centre-c', 'on leave'),
(106, 'fay',    '1983-01-10', '2015-04-15', 3, 1, 'centre-a', 'active'),
(107, 'george', '1975-06-06', '2000-08-10', 2, 4, 'centre-d', 'active'),
(108, 'helen',  '1995-12-12', '2022-01-01', 1, 1, 'centre-a', 'active');

select 
    staff_id, 
    staff_name, 
    emp_category, 
    service_class,
    datediff(year, join_date, getdate()) as years_of_service,
    retirement_age - datediff(year, birth_date, getdate()) as years_left
from staff_roster
cross apply (
    select 
        case 
            when service_class = 1 and emp_category = 1 then 60
            when service_class = 1 and emp_category in (2, 3) then 55
            when service_class in (2, 3, 4) then 65
            else 60
        end as retirement_age
) as r
where 
(
    service_class = 1 and (
        (emp_category = 1 and 
         datediff(year, join_date, getdate()) >= 10 and 
         r.retirement_age - datediff(year, birth_date, getdate()) >= 15)
        or
        (emp_category = 2 and 
         datediff(year, join_date, getdate()) >= 12 and 
         r.retirement_age - datediff(year, birth_date, getdate()) >= 14)
        or
        (emp_category = 3 and 
         datediff(year, join_date, getdate()) >= 12 and 
         r.retirement_age - datediff(year, birth_date, getdate()) >= 12)
    )
)
or
(
    service_class in (2, 3, 4) and
    datediff(year, join_date, getdate()) >= 15 and
    r.retirement_age - datediff(year, birth_date, getdate()) >= 20
);



--4.write a query to Get Max, Min and Average age of employees, service of employees by service Type , Service Status for each Centre(display in years and Months)

select 
    service_class,
    current_status,
    work_centre,

    max(datediff(month, birth_date, getdate()) / 12) as max_age_years,
    min(datediff(month, birth_date, getdate()) / 12) as min_age_years,
    avg(datediff(month, birth_date, getdate()) / 12.0) as avg_age_years,

    max(datediff(month, join_date, getdate()) / 12) as max_service_years,
    min(datediff(month, join_date, getdate()) / 12) as min_service_years,
    avg(datediff(month, join_date, getdate()) / 12.0) as avg_service_years

from staff_roster
group by service_class, current_status, work_centre;

--5. Write a query to list out all the employees where any of the words (Excluding Initials) in the Name starts and ends with the same
--character. (Assume there are not more than 5 words in any name )

create table personnel_log (
    emp_code int primary key,
    full_name varchar(100)
);

insert into personnel_log values
(1, 'alice'),
(2, 'bob'),
(3, 'anna maria'),
(4, 'j. s. smith'),
(5, 'eve elaine'),
(6, 'kevin k. k. kane'),
(7, 'ron r. reed'),
(8, 'x xavier x'),
(9, 'a. k. a.'),
(10, 'madam lila');

select emp_code, full_name
from (
    select 
        emp_code,
        full_name,
        parsename(replace(full_name, ' ', '.'), 1) as word1,
        parsename(replace(full_name, ' ', '.'), 2) as word2,
        parsename(replace(full_name, ' ', '.'), 3) as word3,
        parsename(replace(full_name, ' ', '.'), 4) as word4,
        parsename(replace(full_name, ' ', '.'), 5) as word5
    from personnel_log
) as name_parts
where 
    (
        (len(word1) > 1 and left(word1,1) = right(word1,1)) or
        (len(word2) > 1 and left(word2,1) = right(word2,1)) or
        (len(word3) > 1 and left(word3,1) = right(word3,1)) or
        (len(word4) > 1 and left(word4,1) = right(word4,1)) or
        (len(word5) > 1 and left(word5,1) = right(word5,1))
    );


