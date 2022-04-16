use Netflix
go

--a. Implement a stored procedure for the INSERT operation on 2 tables in 1->n relationship; the 
--   procedure’s parameters should describe the entities / relationships in the tables; the procedure 
--   should use at least 2 user-defined functions to validate certain parameters.


-- Function to check if the input is an integer between 0 and 100
create function checkInt(@n int) 
returns int as
begin
	declare @check int = 0
	if @n>=0 and @n<=100
		set @check=1
	else
		set @check=0
	return @check
end
go

-- Function to check if the input is a float between 0 and 10
create function checkFloat(@x float) 
returns int as
begin
	declare @check int = 0
	if @x>=0 and @x<=10
		set @check=1
	else
		set @check=0
	return @check
end
go

-- Function to check if the input is a varchar(50)

create function checkVarchar(@x varchar(50)) 
returns bit as
begin
	declare @b bit
	if @x like '[a-z]%[a-z]'
		set @b=1
	else
		set @b=0
	return @b
end
go

drop function checkInt
drop function checkFloat
drop function checkVarchar

-- ADD a new object of type Content into the table Content

create or alter procedure addContent
@title varchar(50),
@rating float
--@gid int
as
begin
	if(dbo.checkVarchar(@title) != 1)
	begin
		print 'Invalid title! Could not add record to table!'
		return -1
	end

	else if (dbo.checkFloat(@rating) != 1)
	begin
		print 'Invalid float for rating of this title! Could not add record to table!'
		return -1
	end
/*
	else if (dbo.checkInt(@gid) != 1)
	begin
		print 'Invalid integer gid of tis title! Could not add record to table!'
		return -1
	end
	*/
	else
	begin
		insert into Content(Title, Rating) VALUES (@title, @rating)
		declare @newGid int = (select top 1 Gid from Genre order by Gid desc)
		insert into Content(Gid) values (@newGid)
		print 'Content added successfully!'
		select * from Content
		select * from Genre
	end
end

exec addContent 'IT', 9.5
exec addContent 'Naruto Shippuden', 10
exec addContent 'Boruto', 0
select * from Genre
--OBS! gid este restrictionat si de Gid din Genre
--Pentru a avea un gid valabil, acesta trebuie sa fie egal un un Gid din Genre, nu conteaza care 
drop procedure addContent


-- b. Create a view that extract data from at least 4 tables and write a SELECT on the view that returns 
--    useful information for a potential user.
-- Description of the view below: Create a view that displays the Title and Genre of the Content and the
-- Price of the Subscription and the name of the User_Account.
select * from Genre
select * from Content
select * from Movie
select * from TV_Show
select * from UserAccSubscription
select * from User_Account
select * from Subscription

create view View6
as
	select g.genre_description, c.Title, s.Price, u.Name, us.Sid, us.Uid
	from Genre g inner join Content c on g.Gid=c.Gid 
	inner join Subscription s on s.Cid=c.Cid
	inner join UserAccSubscription us on us.Sid=s.Sid
	inner join User_Account u on u.Uid=us.Uid
	--where Name like 'A%'
go
select * from View6

-- c. Implement a trigger for a table, for INSERT, UPDATE or/and DELETE; the trigger will 
--    introduce in a log table, the following data: the date and the time of the triggering statement, the 
--    trigger type (INSERT / UPDATE / DELETE), the name of the affected table and the number of 
--    added / modified / removed records.

-- Table Logs: the place where we keep track of the changes brought upon the table Content
create table Logs (
lid int primary key identity,
TriggerDate Date,
TriggerType varchar(50),
NameAffectedTable varchar(50),
NoAMDRows int
)
drop table Logs

-- 1. Trigger for INSERT:
create trigger Add_Titles on Content for insert 
as
begin
	insert into Logs values(getdate(), 'INSERT', 'Content', @@ROWCOUNT)
end
go
drop trigger Add_Titles

select * from Content
insert into Content values ('Titanic2', 7, 3)
select * from Content

select * from Logs

-- 2. Trigger for UPDATE:
create trigger Update_Titles on Content for update
as
begin
	insert into Logs values(getdate(), 'UPDATE', 'Content', @@ROWCOUNT)
end
go
--drop trigger Update_Titles

select * from Content
update Content
set Title = 'GOT'
where Rating > 9.9
select * from Content

select * from Logs

-- 3. Trigger for DELETE:
create trigger Delete_Titles on Content for delete
as
begin
	insert into Logs values(getdate(), 'DELETE', 'Content', @@ROWCOUNT)
end
go
--drop trigger Delete_Titles

select * from Content
delete from Content
where Title like 'Naruto%'
select * from Content

select * from Logs

-- d) Write queries on 2 different tables such that their execution plans contain 
--    the following operators in the execution plan (in WHERE, ORDER BY, 
--    JOIN’s clauses): 
--    i) clustered index scan;
--    ii) clustered index seek;
--    iii) nonclustered index scan;
--    iv) nonclustered index seek;
--    v) key lookup

if exists (select name from sys.indexes where name='NewNonClusteredIndex')
	drop index NewNonClusteredIndex on Content
go
create nonclustered index NewNonClusteredIndex on Content(Title)
go

-- here we have the nonclustered index seek
if exists (select name from sys.indexes where name='NonClusteredIndexOnRating')
	drop index NonClusteredIndexOnRating on Content
go
create nonclustered index NonClusteredIndexOnRating on Content(Rating)
go

select * from Content order by Rating

-- here appear the key lookup (clustered) and the nonclustered index scan
select * from Content order by Title
select * from Content where Rating >5


--  we have here the clustered index scan
select Gid, Avg(Rating) as AverageRating
from Content 
where Rating >= 5
group by Gid 
having Avg(Rating)>5 
order by Gid



-- check all the indexes
select * from sys.indexes