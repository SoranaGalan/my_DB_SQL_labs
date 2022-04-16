create database Netflix
go 
use Netflix
go


create table Genre (
Gid int primary key identity,
genre_description varchar (250) default 'to be announced'
)

create table Content (
Cid int primary key identity,
Title varchar (50) default 'to be announced',
Rating float default 0.0,
Gid int foreign key references Genre (Gid)
)


create table Movie (
Mid int primary key identity,
duration float default 0.0,
Cid int foreign key references Content (Cid)
)

create table TV_Show (
TVid int primary key identity,
no_seasons int default 0,
Cid int foreign key references Content (Cid)
)

create table Subscription (
Sid int primary key identity,
s_type varchar (50) default 'to be decided',
Price float default 0.0,
Date varchar (10),
Cid int foreign key references Content (Cid)
)

create table User_Account (
Uid int primary key identity,
Name varchar (50) default 'to be decided',
Email varchar (50) default 'to be decided',
phone_number varchar,
Date varchar (10),
)

create table UserAccSubscription (
Uid int foreign key references User_Account (Uid),
Sid int foreign key references Subscription (Sid),
constraint pk_UserAccSubscription primary key(Uid, Sid)
)

insert into Genre(genre_description) VALUES ('Dramas')
insert into Genre(genre_description) VALUES ('Drama') 

delete from Genre
where Gid = 1
select * from Genre

insert into Genre(genre_description) VALUES ('Comedy')
insert into Genre(genre_description) VALUES ('Action')
insert into Genre(genre_description) VALUES ('Thriller')
insert into Genre(genre_description) VALUES ('Horror')
select * from Genre

insert into Content(Title, Rating, Gid) VALUES ('Avatar', 8.6, 4)
select * from Content
insert into Content(Title, Rating, Gid) VALUES ('Superbad', 7.8, 3)
insert into Content(Title, Rating, Gid) VALUES ('Interstellar', 8.8, 2)
insert into Content(Title, Rating, Gid) VALUES ('No country for old men', 7.4, 5)
insert into Content(Title, Rating, Gid) VALUES ('The Conjuring', 7.7, 6)
select * from Content
delete from Content
where Cid = 5

UPDATE Content
SET Title='Urzeala Tronurilor'
WHERE Title LIKE 'N%' AND Rating >=0
select * from Content

insert into Movie(duration, Cid) values
(109.32, 2)
insert into Movie(duration, Cid) values
(101.2, 3)
insert into Movie(duration, Cid) values
(91.2, 4)
insert into Movie(duration, Cid) values
(150.1, 6)
insert into Movie(duration, Cid) values
(172, 6)
select * from Movie

delete from Movie
where Mid = 10

insert into TV_Show(no_seasons, Cid) values
(8, 6)
select * from TV_Show


insert into Subscription(s_type, Price, Date, Cid) values
('HD', 10, '30.09.2020', 1)
select * from Subscription
insert into Subscription(s_type, Price, Date, Cid) values
('UHD', 12,'27.01.2019', 2)
insert into Subscription(s_type, Price, Date, Cid) values
('2K', 14,'15.02.2021', 3)
insert into Subscription(s_type, Price, Date, Cid) values
('4K', 16,'17.11.2021', 4)
select * from Subscription


insert into User_Account(Name, Email, date) values
('Andrei Frunza', 'zombioposum@gmail.com','04.01.2001')
select * from User_Account
insert into User_Account(Name, Email, date) values
('Marian', 'zombioposum@gmail.com','25.10.2002')
insert into User_Account(Name, Email, date) values
('Marcel', 'zombioposum@gmail.com','06.01.2003')
insert into User_Account(Name, Email, date) values
('Ana Maria', 'zombioposum@gmail.com','20.01.2003')
insert into User_Account(Name, Email, date) values
('Nicusor', 'zombioposum@gmail.com','21.01.2002')
insert into User_Account(Name, Email, date) values
('Bogdan', 'zombioposum@gmail.com','23.05.2004')
select * from User_Account


insert into UserAccSubscription(Uid, Sid)values
(1,2),
(1,3),
(2,1),
(2,2),
(2,3),
(3,2),
(3,3)

select * from Genre
select * from Content
select * from Movie
select * from TV_Show
select * from UserAccSubscription
select * from User_Account



-- a. 3 queries with UNION, INTERSECT, EXCEPT (one query per operator);

--UNION
select * from Content
where Title Like 'T%' OR Rating >= 8
-- equivalent
select * from Content
where Title like 'T%'
UNION -- OR - the unique values
select * from Content
where Rating >= 8
--selects the Titles with the name starting with 'T' and the movies that have ratings greater or equal with 8

--INTERSECT
select * from Subscription
where price > 12
INTERSECT
select * from Subscription
where s_type = '4K'
-- selects the subscriptions with a price greater than 12 AND are of type 4K

--EXCEPT
select * from User_Account
EXCEPT
select * from User_Account
where Name Like 'M%' OR Name Like 'N%'
--selects all the User_Account except for the ones that start with the letter 'M' OR 'N'

select Name, Date from User_Account 
order by Name desc
--shows the name and Date of Birth of all Users in decreasing order (ordered by name)



-- b.  4 INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL JOIN

--INNER JOIN
select * from User_Account, UserAccSubscription
where User_Account.Uid = UserAccSubscription.Sid 
--equivalent
select * from User_Account as i, UserAccSubscription as ic
where i.Uid = ic.Sid
--equivalent
select * from User_Account i INNER JOIN UserAccSubscription ic ON
i.Uid = ic.Sid
--selects the User_Account with their id present in the UserAccSubscription table

select * from ((User_Account i INNER JOIN UserAccSubscription ic ON i.Uid = ic.Sid) INNER JOIN Subscription c ON
ic.Sid = c.Cid)
--selects all the User_Accounts which buy a subscription that has at least one Content

--LEFT JOIN
select * from User_Account i LEFT JOIN UserAccSubscription ic ON
i.Uid = ic.Sid
--selects all User_Accounts, and the User_Accounts which have their id in the UserAccSubscription table

--RIGHT JOIN
select * from User_Account i RIGHT JOIN UserAccSubscription ic ON
i.Uid = ic.Sid
--selects all the users that appear in the UserAccSubscription table 

--FULL JOIN
select * from User_Account i FULL JOIN UserAccSubscription ic ON
i.Uid = ic.Sid
-- returns all the records that have a match in the User_Account or UserAccSubscription table


--c. 2 IN and EXISTS
insert into Subscription (s_type, price, date, Cid) values
('4k', 16, '16.04.2021', 4)
select * from Subscription i
where Price > 12 and i.Sid in (Select ic.Sid from UserAccSubscription ic)
-- selects the Subscriptions with a price > 12 that were bought by at least an User

select * from Subscription i
where i.Price < 18 and EXISTS (select * from UserAccSubscription ic where ic.Sid = i.Sid)
--selects the subscriptions with price < 18 which have their id in UserAccSubscription table


--d. 1 query with from subquery
select distinct i.Title, i.Rating
from (select ic.Gid, i.Title, i.Rating
		from Genre ic inner join Content i on ic.Gid = i.Gid
		where i.Rating > 7) i 
order by i.Rating desc
--selects the name and rating of the distinct Contents which have an id appearing in Genre and a rating > 7
--they are showed in the decreasing order of their ratings



-- e. 3 GROUP BY
insert into Subscription(s_type, Price, Date, Cid) values
('HD', 10, '29.09.2020', 1)
select * from Subscription
insert into Subscription(s_type, Price, Date, Cid) values
('UHD', 12,'31.01.2019', 2)
select * from Subscription

select * from UserAccSubscription

select s.s_type
from UserAccSubscription sc inner join Subscription s on s.Sid = sc.Sid
group by s.s_type
--selects the type of the subscription which have their id in the UserAccSubscription tables
--groups them by type




select sum(Rating) from Content
select min(Rating) from Content
select max(Rating) from Content
select avg(Rating) from Content
select count(Rating) from Content

