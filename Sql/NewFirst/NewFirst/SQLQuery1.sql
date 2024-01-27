Create database First

Drop database First 

Create database First
on primary -- mdf file
(
    name = 'First.mdf',
	filename = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\First.mdf',
	size = 10MB,
	maxsize = unlimited,
	filegrowth = 10MB
),
filegroup Secondary -- ndf file
(
    name = 'First4.ndf',
	filename = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\First4.ndf',
	size = 10MB,
	maxsize = unlimited,
	filegrowth = 10MB
),
(
    name = 'First5.ndf',
	filename = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\First5.ndf',
	size = 10MB,
	maxsize = unlimited,
	filegrowth = 10MB
)
log on 
(
    name = 'First_log1.ldf',
	filename = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\First_log.ldf',
	size = 10MB,
	maxsize = unlimited,
	filegrowth = 10MB
)

use First;

--mdf
create table Table1
(
    ID int
) on Secondary


alter database First
add filegroup Third

alter database First
add file
(
    name = 'First6.ndf',
	filename = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\First6.ndf',
	size = 10MB,
	maxsize = unlimited,
	filegrowth = 10MB
) to filegroup Third

alter database First
modify filegroup Secondary default

--------------- Database Integrity ------------------
-- Domain Intigtiy [Constraints, DT]
-- Entity Intigrity [PK]
-- Refrential Intigrity [FK]  
-- DB Objects [Rule, Triggers, Index]

-- Char(5) vs varchar(5)
-- Char if we add 3 characters it will save 5 locations in memory
-- varchar if we add 3 characters it will save 3 locations in memory

use SchoolDatabase;

create table Student
(
     ID int NOT NULL,
	 [Name] nvarchar(20) not null,
	 DoB Date not null,
	 [Address] nvarchar(max),
	 Graduated bit,
	 GPA float
)

alter table Student 
add constraint StudentPK primary key (ID)

alter table Student 
add constraint StudentGPACheck check(GPA between 1.0 and 4.0)

alter table Student 
add constraint StudentAddressCheck check([Address] in ('Alex', 'Cairo', 'Assuit', 'Dakahlia'))

-- Why we add [] to address and name? because Address and Name are reserved words in MSQLSM

alter table Student 
add Phone char(11)

alter table Student 
add Gender char(1)

alter table Student 
add constraint StudentPhoneCheck check(len(Phone) = 11)

alter table Student 
add constraint StudentGenderCheck check(Gender in ('M', 'F'))

alter table Student 
add constraint StudentGPADefault Default 1.0 for GPA

alter table Student
add SSN char(14) not null 

alter table Student 
add constraint StudentSSNUnique unique (SSN)


create table Grades
(
     ID int not null identity(1,1), -- auto increment id
	 Name varchar(10) not null,
	 constraint GradesPK primary key ([ID]),
)


insert into Grades values('3rd G')

insert into Grades values('2nd G')
,('4th G'),
('1st G')

insert into Grades values('5th G')

-- identity  
-- auto generate and increment number
-- no need to insert value any more(not allowed)
-- delete statement does not restart identity
-- truncate statement restart identity
-- can't update identity column
-- when insert raise error, identity increases

delete from Grades

truncate table Grades

update Grades set ID = 3
where Name = '4th G'

insert into Grades values(null) -- Does't working 
-- IDCounter = 5
-- insert into Grades (IDCounter++, NULL) --> IDCounter = 6 and not insert

insert into Grades values('5th G') -- IDCounter = 7


truncate table Grades
-- Truncate (DCL = Data Control Language)
-- effect = delete  all 
-- restart identity counter 
-- in delete log file -> x deleted from Grades values 1, 1st G - x deleted from Grades 2, 2nd G
-- in truncate log file -> x truncate table Grades
-- truncate can't be rolled back


-- Forrign key
alter table Student 
add GradeID int not null

alter table Student 
add constraint StudentGradeFK 
foreign key (GradeID) 
references Grades(ID) 
on update cascade -- set null, set default
on delete cascade -- set null, set default
-- on weak entity: foreign key never allows null, on delete cascade


-- sequence
create sequence counter start with 1 increment by 1

insert into [dbo].[Student] 
values(next value for counter, 'Ali', getdate(),
'Dakahlia', 1, Default, '01001001001',
'M', '01001001001', 4) 

select next value for counter

insert into [dbo].[Student] 
(ID, Name, DoB, Address, Graduated, GPA, Gender, SSN, GradeID,  Phone)
values(next value for counter, 'Abdullah', getdate(),
'Dakahlia', 1, Default, 'M', '01001001001', 4, '01001001011') 

alter sequence counter restart

select next value for counter

select current_value
from sys.sequences where Name = 'couneter'

select * from Student where ID = 1

-------------------------------------------------------

-- user defined datatype

create type PhoneType from char(11)
drop type PhoneType
create type PhoneType from char(11) not null
-- add constraint be on column
-- how to add constraint on type? Rule
go
create rule PhoneLength as len(@phone) = 11

go
sp_bindrule PhoneLength, PhoneType
 
-- default 
create default PhoneDefault as '11111111111'
sp_bindefault PhoneDefault, PhoneType

alter table Student 
alter column Phone PhoneType not null

alter table Student 
drop column Phone 

alter table Student 
add Phone PhoneType -- char(11) not null check(len(phone) = 11) default '11111111111'

insert into [dbo].[Student] 
(ID, Name, DoB, Address, Graduated, GPA, Gender, SSN, GradeID,  Phone)
values(next value for counter, 'Abdullah', getdate(),
'Dakahlia', 1, Default, 'M', '01001001001', 4, Default) 

create rule SSNCheck as len(@c) = 11

insert into [dbo].[Student] 
(ID, Name, DoB, Address, Graduated, GPA, Gender, SSN, GradeID,  Phone)
values(next value for counter, 'Abdullah', getdate(),
'Dakahlia', 1, Default, 'M', '01001', 4, Default) 

alter table Student 
add constraint SSNCheckConst check(len(SSN) = 11) -- on all data(must = 11)

sp_bindrule SSNCheck, 'Student.SSN' -- on new data only
-------------------------------------------------------

-- DQL
-- Select statment
use World;

select [Code], [Name], [HeadOfState] from [dbo].[Country]
where [HeadOfState] is not null

select [Code], [Name], [HeadOfState] from [dbo].[Country]
where [Population] > 60000000

select [Code], [Name], [HeadOfState] from [dbo].[Country]
where [Population] >= 1000000 and [Population] <= 3000000


select [Code], [Name], [HeadOfState] from [dbo].[Country]
where [Population] between 1000000 and 3000000


select [Population] from [dbo].[Country]
group by [Population]
having Count([Population]) > 1

select [Population], Count([Population]) as CountPopulation from [dbo].[Country]
group by [Population]
having Count([Population]) > 1

select * from City

select Distinct [CountryCode] from City

select Distinct [CountryCode] from City
order by [CountryCode]

select [CountryCode] from City
order by Population

select Distinct [CountryCode] from City
order by [CountryCode] desc

select [Name] + ' ' + [CountryCode] from City

select [CountryCode] from City
where [CountryCode] like 'N%' -- start with N

--------------------------- join ------------------------------
-- Cross
-- inner
-- outer (left, right, full)
-- self

select Country.Name as 'Country Name', City.Name as 'City Name' from 
Country join 
City on Country.Code = City.CountryCode

select Country.Name as 'Country Name', City.Name as 'City Name' from 
Country inner join 
City on Country.Code = City.CountryCode  

select Country.Name as 'Country Name', City.Name as 'City Name' from 
Country left outer join -- left outer join  == left join 
City on Country.Code = City.CountryCode


select s.Name as 'Country Name', c.Name as 'City Name' from 
Country as s full outer join -- left outer join  == left join 
City as c on s.Code = c.CountryCode

use AdventureWorks;

select Emp.[EmployeeID] as 'Emp', Man.[EmployeeID] as 'Man' from 
[HumanResources].[Employee] as Emp
join [HumanResources].[Employee] as Man
on Emp.ManagerID = Man.EmployeeID


-- Synonym = aliase but on DB level

create synonym Emp for [HumanResources].[Employee]

select * from Emp


--------------------------- View --------------------------------
Create View EmployeeManagerData
as
select Emp.[EmployeeID] as 'EmpID', EmpContact.FirstName as 'EmpName',
Man.[EmployeeID] as 'ManID', ManContact.FirstName as 'ManName'
from [HumanResources].[Employee] as Emp
join [HumanResources].[Employee] as Man
on Emp.ManagerID = Man.EmployeeID
join [Person].[Contact] as EmpContact 
on EmpContact.ContactID = Emp.ContactID
join [Person].[Contact] as ManContact 
on ManContact.ContactID = Man.ContactID

--DQL: All Queries are applicable
select * from EmployeeManagerData -- Views for more security

select ManName, Count(EmpName) from EmployeeManagerData
group by ManName 

create view  ContactView
as
(
select [FirstName], [LastName] from [Person].[Contact]
)


--DML
-- select statement in view select from 1 table only
-- columns not selected either allowing null or has default value

use World;

create view CityView 
as(
   select [ID], [Name], [CountryCode], [District], [Population] 
   from City 
   where CountryCode = 'EGY'
)

Select * from CityView 

insert into CityView values(10001, 'Test2', 'AGO', 'Cairo', 40000)

alter view CityView 
as(
   select [ID], [Name], [CountryCode], [District], [Population] 
   from City 
   where CountryCode = 'EGY'
) with check option -- Data will input must be like data in CityView

insert into CityView values(10002, 'Test3', 'AGO', 'Cairo', 40000)

insert into CityView values(10002, 'Test3', 'EGY', 'Cairo', 40000)

------------------------------------------------------------------
--Schema is a virtual categorization for DB Object (Tables, Views, Sequence, Synonym, ETC.)
-- Default Schema Database Owner (dbo)

Create schema ProductSchema 

Create table ProductSchema.ProductTable
(
   ID int not null primary key,
   Name varchar(50) not null
)

Create table SalesTable
(
   ID int not null primary key,
   Name varchar(50) not null
)

alter schema ProductSchema
transfer [dbo].[SalesTable]

--------------------------Day3(Functions)----------------------
-- Built in Function:
---NULL: isNull(col, replacement),
-- coalesce(col1, col2, col3, col4, ..., replacement)
-- Convertion: convert(used with date for style), cast
-- Sytem Functions: db_name, suser_name, new_id, error functions
-- Aggregation Functions: max, min, avg, sum, count
-- String: upper, lower, substring, concat
-- Math Function: sin, cos, tan, pow
-- Date: Year, month, day, datename, datediff, getdate
-- Ranking Functions: row_number, dence_rank, NTile, rank
-- windowing Functions: lead, lag, first_value, last_value
-- Logical Functions: iif, choose


use Company;
go 
select [Fname]+ ' ' +[Lname] ,[DepartmentId], Isnull([EmployeId], 0) 
from [dbo].[Employees]

select [Fname]+ ' ' +[Lname] ,coalesce([EmployeId], [DepartmentId], [Salary], 'No Data') 
from [dbo].[Employees]

select [Fname]+ ' ' +[Lname] ,coalesce([EmployeId], convert(int, [Salary]), 'No Data') 
from [dbo].[Employees]

select [Fname]+ ' ' +[Lname] ,
coalesce([EmployeId], cast([Salary] as int), 'No Data') 
from [dbo].[Employees]

select convert(varchar, getdate(), 101)

select convert(varchar, getdate(), 131)

select convert(varchar, getdate(), 113)

select DB_NAME()

select SUSER_NAME()

select newid() -- GUID (Generate IDs)

insert into Company values(NEWID(), ....)

select upper([Fname]+ ' ' +[Lname]) ,[DepartmentId], Isnull([EmployeId], 0) 
from [dbo].[Employees]

select lower([Fname]+ ' ' +[Lname]) ,[DepartmentId], Isnull([EmployeId], 0) 
from [dbo].[Employees]

select * from [AdventureWorks].[HumanResources].[Department]

select concat(substring(Name,1,2), '-', SUBSTRING(GroupName, 1, 2)) from 
[AdventureWorks].[HumanResources].[Department]

select year(getdate())

select datename(MM, getdate())

select datename(DAYOFYEAR, getdate())

-- select DATEDIFF(getdate(), '31-1-2001')




--------------------------------------------
-- variables
-- local: @varname, execution level in memory, declare, initialize, assign, read
-- global: @@varname, server variables readonly
select @@SERVERNAME

select @@ERROR, @@VERSION

delete from [Company].[dbo].[worksFors]
select @@ROWCOUNT

declare @x int 
set @x = 20
--select @x = 10
--print @x
select @x

select avg(salary) from  Employees

select * from  Employees
where Salary > (select avg(salary) from  Employees)


declare @AVGSalary float
set @AVGSalary = (select avg(salary) from  Employees)
select * from  Employees
where Salary > @AVGSalary

declare @Name nvarchar(50), @Salary float
select @Name = Fname, @Salary = Salary from Employees where Id = 1
Print @Name
Print @Salary

declare @Name nvarchar(50), @Salary float
select @Name = Fname, @Salary = Salary from Employees
Print @Name
Print @Salary -- only print last value


-- insert
-- insert constructor
-- insert based on select
-- Bulk insert
declare @Emps table(name nvarchar(50), Salary float)
insert into @Emps
select Fname, Salary from Employees
select * from @Emps 

-- select into
select Fname, Salary into New from Employees -- Create Table New and put values in it


-- user defined table type
create type EmpArray as table(name nvarchar(50), Salary float)

declare @Emps EmpArray
insert into @Emps
select Fname, Salary from Employees
select * from @Emps 

-- Temp Tables
-- Local: start with #, current session
-- Global: start with ##, all sessions

create table #EmpData(name nvarchar(50), Salary float) -- stored in tempdb 

insert into #EmpData
select Fname, Salary from Employees

select * from #EmpData 


create table #EmpDataGlobal(name nvarchar(50), Salary float) -- stored in tempdb 
-- shared on all sessions, 
insert into #EmpDataGlobal
select Fname, Salary from Employees

select * from #EmpDataGlobal 


-- control of flow
-- if, if else, else
-- case 
-- exists, not exists
-- choose
-- wait for

go 
declare @x float
set @x = (select min(salary) from Employees)
if @x > 3000
begin
    select 'salaries are ok'
end
else 
begin
    update Employees set Salary = 3000 where Salary < 3000
    select 'managers need raise'   
end



if (select min(salary) from Employees) > 3000
begin
    select 'salaries are ok'
end
else 
begin
    update Employees set Salary = 3000 where Salary < 3000
    select 'managers need raise'   
end



if exists(select * from Employees where lower(Fname) like 'abdu%')
    print 'Exists'



if not exists(select * from Employees where lower(Fname) like 'abdu%')
    print 'Not Exists'
else 
    print 'Exists'


use AdventureWorks;
select [FirstName], case [Title] 
                    when 'Mr.' then 'Male'
                    when 'Ms.' then 'Female'
					end as 'Gender'
from [Person].[Contact]

-- loops

-- While
-- declare and initialize
-- while condition
-- begin 
     -- body
	 -- step statement
-- end
go
declare @x int 
set @x = 0
while @x < 5
begin
     print @x
	 set @x = @x + 1
end
-------------------------------------------------


-- User Defined Function:
-- scaler: function returns one value, declare, loops, conditions
-- inline: function returns table, select only
-- multistatement: function returns table, declare, loops, conditions

use Company;

-- Scaler Function
Create function SumTwoNumbers(@x int, @y int)
returns int 
as begin
     declare @result int
	 set @result = @x + @y
	 return @result
end

select dbo.SumTwoNumbers(100,300)


-- inline
create function getBySalary(@Salary float)
returns table
as return(
    select * from [Company].[dbo].[Employees]
	where Salary = @Salary
)

select * from dbo.getBySalary(150000)

select * from Departments
-- multi statement
go
create function EmpInDept(@Dept int)
returns @t table(DeptName nvarchar(50), NumberofEmp int)
as begin
    if exists(select * from [Departments] where Dnumber = @Dept)
	begin 
	     insert into @t 
		 select D.[Dname], count(E.[Id]) from 
         [dbo].[Departments] as D
		 join [dbo].[Employees] as E
		 on E.[DepartmentId] = D.[Dnumber]
		 group by D.Dname
	end
	return
end

select * from dbo.EmpInDept(1)



go
alter function EmpInDept(@Dept int)
returns @t table(DeptName nvarchar(50), NumberofEmp int)
as begin
    if exists(select * from [Departments] where Dnumber = @Dept)
	begin 
	     insert into @t 
		 select D.Dname, count(E.[Id]) from 
         [dbo].[Departments] as D
		 join [dbo].[Employees] as E
		 on E.[DepartmentId] = D.[Dnumber]
		 where D.Dnumber = @Dept
		 group by D.Dname
	end
	return
end

select * from dbo.EmpInDept(2)

------------------------- Day4 -------------------------

-- Computed Column

alter table [dbo].[Student] -- can be created in table creation 
add Age as datediff(year, getdate(), DoB)
 
alter table [dbo].[Student]
drop COLUMN  Age 

alter table [dbo].[Student]
add Age as datediff(year, DoB, getdate())

select datediff(year, DoB, getdate()) from [dbo].[Student]

alter table [dbo].[Student]
drop COLUMN  Age 

select * from [dbo].[Student]

alter table [dbo].[Student]
add Age as datediff(year, DoB, getdate()) persisted -- to save it in hardware, and it use with things not changes more one time

use Company;
go
create function CalcNetSalary(@Salary float)
returns float
as begin 
     declare @net float
     if @Salary <= 5000
	     set @net = @Salary * 0.99
     else if @Salary > 5000 and @Salary < 10000
	     set @net = @Salary * 0.97
	 else
	     set @net = @Salary * 0.95
     return @net     
end

select dbo.CalcNetSalary(3000)

select dbo.CalcNetSalary(9900)

select dbo.CalcNetSalary(11000)

alter table [dbo].[Employees]
add NetSalary as dbo.CalcNetSalary(Salary)

Select * from Employees

-- drop function [dbo].[CalcNetSalary]

use SchoolDatabase;

alter table [dbo].[Degrees]
add constraint DegreesStudentFK foreign key ([StudentID])
references [dbo].[Student]([ID])

alter table [dbo].[Degrees]
add Degree float not null

insert into [dbo].[Degrees] ([StudentID], [Degree])
values (1, 95),
(1,90),
(2, 95),
(2,90),
(2, 95),
(2,90),
(2, 95),
(2,90)

drop table [dbo].[Degrees]

create table Degrees
(
  ID int Primary key identity,
  StudentID int not null,
  Degree float not null,
  constraint DegreesStudentFK foreign key([StudentID])
   references [dbo].[Student]([ID])
)

insert into [dbo].[Degrees] ([StudentID], [Degree])
values (1, 95),
(1,90),
(1, 95),
(1,90),
(2, 95),
(2,90),
(2, 95),
(2,90)

Select * from degrees

go
alter function CalcGPA(@StudentID int)
returns float
as begin
    declare @gpa float
	select @gpa = avg(Degree) * 4 / 100 from dbo.Degrees 
	where @StudentID = StudentID
	return @gpa
end

select dbo.CalcGPA(1)

alter table Student 
add GPACalc as dbo.CalcGPA(ID)

select * from Student

-------------------------------------------------

select Name from Student 

-- Dynamic Sql
declare @col nvarchar(50), @table nvarchar(50)
set @col = 'Name'
set @table = 'Student' 
execute('select '+@col+' from '+@table) -- as eval in js

-- ====
--execute('select Name from Student')

-------------------------------------------------------

-- Transaction:
-- Implicit Transaction
-- insert into Degrees values(13, 50)
-------------------------------------------------------------
-- Query file           log file           Data file
-- insert ------------->begin Tran         
--                           insert ------> actual insert
--                    commit <------------- if done successfully
--                    rollback <-------------if exception
-----------------------------------------------------------------
-- Query file           log file           Data file
-- update ------------->begin Tran         
--                           update ------> actual update
-------------------------------------------------server down
--                           auto rollback
--------------------------------------------------------------
-- Explicit Transaction:
begin transaction
insert into [dbo].[Degrees] values(1, 90)
commit 

select * from Degrees

begin transaction
insert into [dbo].[Degrees] values(1, 90)
rollback 

begin Transaction 
begin try
     insert into Student(ID, Name, DoB, SSN,Phone,GradeID) values(3,'Tran', GETDATE(), '11110000111', '00000000000',3)
     insert into Degrees values(3,85), (3, 90), (3, 85)
	 commit
	 print 'Data Saved'
end try
begin catch 
     rollback
	 Select ERROR_NUMBER(), ERROR_LINE(), ERROR_MESSAGE()
end catch 

select * from Student


begin tran 
	declare @r1 int = 0, @r2 int = 0
	insert into [dbo].[Grades] values('7th G')
	save tran GradeDone -- Save Point
	insert into Student(ID, Name, DoB, SSN,Phone,GradeID) values(3,'Tran', GETDATE(), '11111000111', '00000000000',3) 
	select @r1 = @@ERROR
	insert into Degrees values(3,85), (3, 90), (3, 85)
	select @r2 = @@ERROR
	if @r1 = 0 and @r2 = 0
		commit
	else
		rollback tran GradeDone
		commit tran


delete from Degrees where ID > 8

select * from Degrees
----------------------------------------------

-- Batch: Some Queries may not be related, Don't effect one another
-- declare 
-- create
-- insert 
-- insert
-- Select 
create table t1 (ID int)
insert into t1 values (1), (2)


-- Script: Some queries with go
declare @x int = 10
select @x
go
select @x -- Not work because this is another batch

begin tran 
create table t1(id int)
rollback
----------------------------------------------

-- Views:
-----no Parameters
-----select statement only
-----security
-- Functions: Business Logic, Calc, Security
----- Should return
----- DQL
----- DML Limited to var of type table
----- No DDL

-- Query Execution Cycle:
-- Query -> Check query(parsing) -> Optimization -> Query Tree -> Execution Plan -> Result
-- In calling function in queries top cylce execute every time (Low Performance)


-- Stored Procedure (Concat of Views and functions):
-- Take Parameters
-- DQL & DML
-- Can Return Or Not
-- Can Return more than one value
-- Can have vars & Control of flow
-- Best Performance: With first calling for SP do full cycle then save Execution Plan
-- Keep Securit
-- return int or no return

create procedure getStudents
as begin
	select * from Student
end

exec getStudents


alter procedure getStudents @id int
as begin
	select * from Student 
	where ID = @id
end

exec getStudents 1


create procedure insertDegree @id int, @degree float
as begin
	if exists(select * from Student where ID = @id)
		insert into Degrees values(@id, @degree)
end
-- Passing Parameters by Position
insertDegree 1, 100

-- Passing Parameters by Name
insertDegree @id = 1, @degree = 100


create procedure NoOfExams @id int
as begin
	declare @num int = 0
	select @num = count(*) from Degrees where [StudentID] = @id
	return @num
end


declare @result int
exec @result = NoOfExams 1
select @result

alter procedure FirstStudent @ResultName nvarchar(50) output
as begin
	declare @name nvarchar(50)
	select @name = Name from Student
	where GPACalc = (select max(GPACalc) from Student)
	if @name is not null
	begin
	    set @ResultName = @name
	    return 1
	end
	else  
		return 0
end

go
declare @name nvarchar(50), @result int
exec @result = FirstStudent @name output
if @result = 1
	select @name as 'FirstStudent'
else 
	select 'Not Found' as 'FirstStudent'

CREATE procedure [dbo].[InsertBorrowing] (@MID int, @ISBN varchar(10),@Date Date)
as begin
	if exists(select * from [BorrowActions].[Borrow] 
			  where [ReturnDate] is Null and [MemberID] = @MID)
		select 'not allowed please return borrowed books'
	else
	begin
		begin try
			insert into [BorrowActions].[Borrow] values(@ISBN,@MID,@Date,NULL)
			select 'inserted successfully'
		end try
		begin catch
			select 'failed to insert: ' + ERROR_MESSAGE()
		end catch
	end
end

use [PreLecture]

exec [dbo].[InsertBorrowing] @MID = 2, @ISBN = '123', @Date = '1/26/2022'

insert into [BorrowActions].[Borrow] values('123',2,'1/26/2022',NULL)

----------------------------------------------------------------------

--trigger: special type of procedures that fire automaticly when action happens
----instead of DML
----after | for DML
----DDL Trigger

create trigger [InsertBorrowing] on [BorrowActions].[Borrow]
instead of Insert
as begin
	--2 Temp tables Inserted & deleted
	--inserted containt data will be inserted
	--deleted containt data will be deleted

	declare @MID int, @ISBN varchar(10),@Date Date
	select @MID=MemberID, @ISBN=BookISBN, @Date=BorrowDate from inserted

	if exists(select * from [BorrowActions].[Borrow] 
			  where [ReturnDate] is Null and [MemberID] = @MID)
		select 'not allowed please return borrowed books'
	else
	begin
		begin try
			insert into [BorrowActions].[Borrow] values(@ISBN,@MID,@Date,NULL)
			select 'inserted successfully'
		end try
		begin catch
			select 'failed to insert: ' + ERROR_MESSAGE()
		end catch
	end
end




create trigger UpdateDenied on [BorrowActions].[Borrow]
after update
as begin
	if update([BorrowDate])
	begin
		rollback
		select 'cant update this field'
	end
end



update [BorrowActions].[Borrow]
set [BorrowDate] = '01-16-2022'
where MemberID = 14

------------------------Day5------------------------

-- table --> (Name, ID, SSN 'Social Securty Number', Address) without 
-- Primary Key --> Heap Table 'Data Storted as Inserted', 'When where it scans row by row(table scanning)'
-- Each Table is a data pages (default size: 8kB)

-- Clustered Index(By Default on PK) 'Order Pages by Key(PK)' --> 
-- Searching binary tree

-- When we search about another result(not primary Key) --> row by row
-- there exist somthing like clustered index --> page scanning after
-- use binary search on pages (This somthing called Non-Clustered index)
-- Create it manually on any column and it reflect after delete and 
--  insert and update and created every time



Create Table heap
(
	ID int,
	Name varchar(10),
	SSN char(10) -- Sort data in actual data pages using it
)


insert into heap values(3,'Ali', '1111111111'),
(4,'Moghamed', '1111211111'),
(1,'Mahmoud', '1111111211')

Select * from heap where Name like  'M%'
--Scan Row By Row
-------------------------------------

Create Table Student
(
	ID int Primary Key, -- PK for relation purpos only (Clustered Index)
	Name varchar(10),
	SSN char(10) -- Sort data in actual data pages using it (Non-Clustered Index)
)

--Index: 250 index, 1 Clustered, 249 (non-clustered or unique)
----- Clustered: by default to PK automaticaly no duplication, no null only one
----- Non-Clustered: dev. create it manually on any column, allow duplication, allow null, up to 249
----- Unique: Non-Clustered but not allowing duplication(no duplication)
-- and created automaticaly with unique constraint 

create nonClustered index SSNIndex on Student(SSN)

--Case: ID for relation only, search will be done on SSN
-- 1:
-- Create table without PK
-- set clustered index to SSN
-- alter and set ID PK then engin set non-clustered index to PK
-- 2: 
-- in Creating table set PK non-clustered
-- set clustered index on SSN
-- 3:
-- Drop PK constraint automaticaly index is droped
-- add clustered index to column
-- add PK constraint

alter table [dbo].[Student]
drop constraint [PK__Student__3214EC27D1A72ADC]





Create Table Student2
(
	ID int Primary Key nonclustered, -- (non-Clustered Index for relation purpose)
	Name varchar(10),
	SSN char(10) -- (Clustered Index) for actual search
)


create clustered index SSNSearch on student2(SSN)

-- for Unique index :
create unique index NameUnique on Student2(Name)

-------------------------------------------------------------------
--Cursor:
----Loop on select result set row by row
----When open it locks table
----Load result set in memory for looping
----With each fetch in gets the next row
----At the end Close cursor to unlock table
----And Deallocate memory


Create database PreLecture

create table Member(
	ID int Primary Key,
	Name nvarchar(30),
	Address nvarchar(30),
	Type nvarchar(30),
)


insert into Member values(3,'Ali', '1111111111','1111111111'),
(4,'Moghamed', '1111211111','1111111111'),
(1,'Mahmoud', '1111111211','1111111111')


select * from Member

declare @i int = 0;
while @i < 5
begin
select * from Member
set @i = @i + 1
end

--cursor lock table


declare crs cursor for select [Name], [Type] from Member
for read only
open crs 
declare @Name nvarchar(30), @Type nvarchar(30)
fetch next from crs into @Name, @Type
select @Name, @Type


go
declare crs cursor for select [Name], [Type] from Member
for read only
open crs
declare @Name varchar(50), @Type char(7)
fetch NEXT FROM crs into @Name, @Type
while @@FETCH_STATUS = 0 --0 fetch successfully, 1 fetch fail, 2 fetch finished
begin 
	select @Name, @Type
	fetch NEXT FROM crs into @Name, @Type
end
close crs --stop lock on table
deallocate crs --deallocate result set in memory

create sequence code start with 1 increment by 1

alter table [dbo].[Member]
add MemberCode int 

update [dbo].[Member] set MemberCode = Next value for Code

select * from [dbo].[Member]



declare @missingNumbers table(num int)
declare crs1 cursor for select MemberCode from Member 
for read only
open crs1
declare @current int, @next int
fetch Next from crs1 into @current 
while @@FETCH_STATUS = 0
begin
	fetch next from crs1 into @next 
	if @next != @current + 1
		insert into @missingNumbers values(@current + 1)
	set @current = @next;
end
close crs1
deallocate crs1
select * from @missingNumbers
----------------------------------------------------

--Error Handling
begin try
	insert into [BorrowActions].[Book]
	values(123,'BookX',1,'Dawn',getdate())
end try
begin catch
	select @@ERROR, ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_LINE()
end catch

--custom error
----RaiseError: error number should be stored in sys.messages
--Js: var e = new Error('message'); throw e;
----Throw: fire error on the fly
--Js: throw 'messsage';

--Js: var e = new Error('message');
sp_addmessage @msgnum = 50010, @severity = 16, @msgtext = 'please return borrowed books'
sp_dropmessage 50010
--Js: throw e;
RAISERROR(50010,16,1,'Custom Error')

--Dev 1:
alter procedure [dbo].[InsertBorrowing] (@MID int, @ISBN varchar(10),@Date Date)
as begin
	if exists(select * from [BorrowActions].[Borrow] 
			  where [ReturnDate] is Null and [MemberID] = @MID)
		--select 'not allowed please return borrowed books'
		--RAISERROR(50010,16,1,'please return borrowed books')
		throw 50005, 'please return borrowed books',1
	else
	begin
		begin try
			insert into [BorrowActions].[Borrow] values(@ISBN,@MID,@Date,NULL)
			select 'inserted successfully'
		end try
		begin catch
			--select 'failed to insert: ' + ERROR_MESSAGE()
			--RAISERROR(50010,16,2,'Custom Error')
			throw;
		end catch
	end
end

--Dev 2:
begin try
	exec [InsertBorrowing] @MID=14 , @ISBN = '234', @Date = '1-27-2022'
end try
begin catch
	select ERROR_MESSAGE()
end catch

----------------------------Day6-------------------------

select * from Student
for xml raw

select * from Student
for xml raw('Student')

select * from Student
for xml raw('Student'), ROOT('Students')

select * from Student
for xml raw('Student'), ELEMENTS

select * from Student
for xml raw('Student'), ELEMENTS, ROOT('Students')

select * from Student
order by ID
for xml raw('Student'), ELEMENTS, ROOT('Students')


select Address, Count(ID) from Student
Group by Address
for xml raw('Student'), ELEMENTS, ROOT('Students')


select s.ID as 'StudentID', s.Name as 'StudentName', g.Name as 'GradeName'
from Student as s inner join Grades as g
on s.GradeID = g.ID
for xml raw('Student'), ELEMENTS, ROOT('Students')


select Student.ID as 'StudentID', Student.Name as 'StudentName', Grade.Name as 'GradeName'
from Student as Student inner join Grades as Grade
on Student.GradeID = Grade.ID
for xml auto, ELEMENTS, ROOT('Students')


select ID "@ID", SSN "@SSN" , 
Name "FullName", 
Address "Address"
from Student
for xml path('Student'), ELEMENTS, ROOT('Students')


declare @docs xml = '<Students>
					  <Student ID="1">
						<FullName>Abdullah</FullName>
						<Address>Dakahlia</Address>
					  </Student>
					  <Student ID="2">
						<FullName>Ali </FullName>
						<Address>Dakahlia</Address>
					  </Student>
					  <Student ID="3">
						<FullName>Mohammed</FullName>
						<Address>Dakahlia</Address>
					  </Student>
					</Students>'

declare @documentHandler int 
exec sp_xml_preparedocument @documentHandler output, @docs

select * into StudentXML from OPENXML(@documentHandler, '/Students/Student')
with (
    StudentID int './@ID',
	Address nvarchar(50) './Address'
)

exec sp_xml_removedocument @documentHandler


CREATE XML SCHEMA COLLECTION BookIndex
AS
N'<xs:schema attributeFormDefault="unqualified"
    elementFormDefault="qualified"
    xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xs:element name="index">
        <xs:complexType>
            <xs:sequence>
                <xs:element maxOccurs="unbounded" name="keyword">
                    <xs:complexType>
                        <xs:simpleContent>
                            <xs:extension base="xs:string">
                                <xs:attribute name="page" type="xs:int" use="required" />
                            </xs:extension>
                        </xs:simpleContent>
                    </xs:complexType>
                </xs:element>
            </xs:sequence>
        </xs:complexType>
    </xs:element>
</xs:schema>'

-- to view schema
select XML_SCHEMA_NAMESPACE('dbo','BookIndex')
-- to drop it
drop xml schema collection dbo.BookIndex -- can't be deleted if used with table

create table Books
(
	ISBN char(13) primary key not null,
	Title nvarchar(200) not null,
	BookIndex xml(content dbo.BookIndex) not null
)

Insert into dbo.Books
(ISBN,Title,BookIndex)
VALUES
('1-59059-589-8','Visual C# 2005 Recipes',
CAST('
<index>
    <keyword page="15">AppDomain</keyword>
    <keyword page="319">DataTable</keyword>
    <keyword page="328">DataSet</keyword>
    <keyword page="149">Encrypt</keyword>
    <keyword page="167">File IO</keyword>
    <keyword page="27">GAC</keyword>
    <keyword page="30">Generics</keyword>
</index>' as XML))

select * from Books;


declare @index xml, @dHandler int
select @index = BookIndex from [dbo].[Books]
--select @index
exec sp_xml_preparedocument @dHandler output, @index

select * from OpenXML(@dHandler,'/index/keyword')
with (
	Keyword varchar(50) '.',
	[Page] int './@page'
)
where [Page] > 100

exec sp_xml_removedocument @dHandler

delete from Books

CREATE PRIMARY XML INDEX idx_XML_Primary_Books_BookIndex
ON dbo.Books(BookIndex)--need a clustered index in the table



declare @xml xml(dbo.BookIndex)
set @xml ='<index>
    <keyword page="1">Chapter1</keyword>
    <keyword page="50">Chapter2</keyword>
    <keyword page="100">Chapter3</keyword>
    <keyword page="200">Chapter4</keyword>
    <keyword page="220">Chapter5</keyword>
    <keyword page="379">Chapter6</keyword>
    <keyword page="1919">Chapter7</keyword>
</index>' 
insert into dbo.Books
(ISBN,Title,BookIndex)
VALUES ('1-11111-111-1','SQL Server 2008',@xml)

select * from dbo.Books


-------------------------------------------------------------------------
							/*UnTyped*/ 
						--without Schema
drop table docs
CREATE TABLE docs 
(
	pk int PRIMARY KEY, 
	xCol XML --(content dbo.xmlschemaname)
)
----------------------------------------------
INSERT INTO docs 
VALUES 
(12,'<book genre="security" publicationdate="2002" ISBN="0-7356-1588-2">
   <title>Writing Secure Code</title>
   <author>
      <first-name>Michael</first-name>
      <last-name>Howard</last-name>
   </author>
   <author>
      <first-name>David</first-name>
      <last-name>LeBlanc</last-name>
   </author>
   <price>39.99</price>
</book>')

INSERT INTO docs 
VALUES 
(2,'<book genre="BI" publicationdate="2002" ISBN="0-7358-1588-2">
   <title>Writing BI Code</title>
   <author>
      <first-name>ITI</first-name>
      <last-name>ITI</last-name>
   </author>
   <author>
      <first-name>MCIT</first-name>
      <last-name>MCIT</last-name>
   </author>
   <price>44.99</price>
</book>')

select * from docs
------------------------------------------------------------

--------------------------------Calculated Column
CREATE FUNCTION udf_get_book_ISBN (@xData xml)
RETURNS varchar(20)
WITH SCHEMABINDING
BEGIN
   DECLARE @ISBN  varchar(20)
   SELECT @ISBN 
		 = @xData.value('/book[1]/@ISBN', 'varchar(20)')
   RETURN @ISBN 
END
----------------------------------------------------------------------
ALTER TABLE docs
ADD   ISBN --calculated column name
AS dbo.udf_get_book_ISBN(xCol)
----------------------------------------------------------------------
select * from docs

SELECT pk, xCol
FROM   docs
WHERE  ISBN = '0-7356-1588-2'
--using the new column
----------------------------------------------------------------------
INSERT INTO docs 
VALUES 
(3,'<book genre="testing" publicationdate="2002" ISBN="0-7356-1778-5">
   <title>Writing  Code</title>
   <author>
      <first-name>M</first-name>
      <last-name>H</last-name>
   </author>
   <author>
      <first-name>A</first-name>
      <last-name>B</last-name>
   </author>
   <price>40.99</price>
</book>')

------------------------------------------------------
/*
to retrieve the stored size in bytes of 
the XML instances in the XML column 
*/
SELECT DATALENGTH (xCol)
FROM    docs
-------------------------------------------------------
/*
The first index on an XML column is the 
"primary XML index". Using it, three types of 
secondary XML indexes can be created on the 
XML column to speed up common classes of queries
*/
CREATE PRIMARY XML INDEX idx_xCol 
on docs (xCol)
----------------------------------------------------------
SELECT *
FROM   docs
WHERE  xCol.exist ('/book[@genre = "BI"]')=1
/*
secondary XML index of type PATH is helpful for this workload
*/
------------------------------------------------------------
CREATE XML INDEX idx_xCol_Path 
on docs (xCol)
USING XML INDEX idx_xCol 
FOR PATH
--------------------------------------------------------------------
CREATE XML INDEX idx_xCol_Property 
on docs (xCol)
USING XML INDEX idx_xCol 
FOR PROPERTY
--------------------------------------------------------------------
SELECT xCol
FROM   docs
WHERE  
xCol.exist ('//book/@ISBN[. = "0-7356-1588-2"]') = 1
/*
a partial path is specified using //, so that the lookup based 
on the value of ISBN could use the VALUE index
*/
-------------------------------------------------------------------
CREATE XML INDEX idx_xCol_Value 
on docs (xCol)
USING XML INDEX idx_xCol 
FOR VALUE


----------------------------------------------------------------------
SELECT pk, xCol
FROM   docs
WHERE  xCol.exist ('/book[@ISBN = "0-7356-1588-2"]') = 1



-----------------------------------------------------------------------
 
 CREATE TABLE customerData
 (
        customerDocs xml NOT NULL,
 ) 

INSERT INTO customerData(customerDocs)
       VALUES(N'<?xml version="1.0"?>
       <customers>
              <customer FirstName="Bob" LastName="Hayes" Zipcode="91126" status="current">
                     <order ID="12221" Date="July 1, 2006">Laptop</order>
              </customer>
              <customer FirstName="Judy" LastName="Amelia" Zipcode="23235" status="current">
                     <order ID="12221" Date="April 6, 2006">Workstation</order>
              </customer>
              <customer FirstName="Howard" LastName="Golf" Zipcode="20009" status="past due">
                     <order ID="3331122" Date="December 8, 2005">Laptop</order>
              </customer>
              <customer FirstName="Mary" LastName="Smith" Zipcode="12345" status="current">
                     <order ID="555555" Date="February 22, 2007">Server</order>
              </customer>
       </customers>')
select * from customerData;

--XQuery
--Query language to indentify nodes in XML

--Examples:

--/InvoiceList/Invoice
--All Invoice elements immediately contained within the root InvoiceList element

--(/InvoiceList/Invoice) [2] 
--The second Invoice element within the root InvoiceList element

--(InvoiceList/Invoice/@InvoiceNo) [1]
--The InvoiceNo attribute of the first Invoice element in the root InvoiceList element

--(InvoiceList/Invoice/Customer/text())[1]
--The text of the first Customer element in an Invoice element in the InvoiceList root element

--/InvoiceList/Invoice[@InvoiceNo=1000]
--All Invoice elements in the InvoiceList element that have an InvoiceNo attribute with the value 1000

--Statments
--for 
--Used to iterate through a group of nodes at the same level in an XML document.

--where 
--Used to apply filtering criteria to the node iteration. XQuery includes
--functions such as count that can be used with the where statement.

--return 
--Used to specify the XML returned from within an iteration.

--Query, Value, Exist, Modify and Nodes methods in XQuery

Select customerDocs
from customerData

Select customerDocs.query('/customers/customer')
from customerData 

Select customerDocs.query('(/customers/customer)[1]')
from customerData 

Select customerDocs.query('/customers/customer/order')
from customerData 

Select customerDocs.query('(/customers/customer/order)[1]')
from customerData

Select customerDocs.query('(/customers/customer/@FirtName)[1]')
from customerData

-- FLWOR with LET operator

SELECT customerDocs.query('
       <CustomerOrders> {
       for $i in //customer
       let $name := concat($i/@FirstName, " ", $i/@LastName)
       order by $i/@LastName
       return
              <Customer Name="{$name}">
              {
              $i/order
              }
              </Customer>
       }
       </CustomerOrders>')
FROM customerData




















