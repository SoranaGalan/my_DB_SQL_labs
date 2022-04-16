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