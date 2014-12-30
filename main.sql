create database if not exists CustomCooking;
use CustomCooking;

drop table if exists Recipe;
create table Recipe (
	idRecipe integer not null primary key,
	nameRecipe character(30) not null,
	typeRecipe character(30) not null,
	descriptionRecipe text,
	cuisine character(30) not null,
	nationalOrigin character(30),
	regionalOrigin character(30),
	timeRecipe integer not null,
	difficulty integer not null,
	authorName character(30) not null
);

insert into Recipe 
values
	(1,'Sushi','primo','riso con pesce','giappo',null,null,40,2,'tommy'),
	(2,'ceasar salad','contorno',null,'americana',null,null,5,1,'ale'),
	(3,'cannoli siciliani','dolce',null,'siciliana','italia','sicilia',90,3,'fede');

drop table if exists Step;
create table Step (
	idStep integer not null primary key,
	descriptionStep text not null,
	timeStep character(30) not null,
	photoStep text,
	videoStep text
);

insert into Step 
values
	(1,'lavati le mani',1,null,null),
	(2,'prepara riso',5,null,null),
	(3,'pulisci la verdura',10,null,null),
	(4,'infarcisci panna',5,null,null);

drop table if exists Product;
create table Product (
	nameProduct character(30) not null primary key,
	photoProduct character(100)
);

insert into Product 
values
	('riso',null),
	('verdura',null),
	('panna',null);

drop table if exists Tool;
create table Tool (
	nameTool character(30) not null primary key,
	photoTool character(100)
);

insert into Tool 
values
	('hagiri',null),
	('ciotola',null),
	('cucchiaio',null);

drop table if exists UserName;
create table UserName (
	username character(30) not null primary key,
	email character(100)
);

insert into UserName 
values
	('ale',null),
	('tommy',null),
	('fede',null);

drop table if exists Ingredient;
create table Ingredient (
	idRecipe integer not null references Recipe (idRecipe),
	nameProduct integer not null references Product (nameProduct),
	quantity double not null,
	unitOfMeasure character(30) not null
);

insert into Ingredient 
values
	(1,'riso',1,'grammi'),
	(2,'verdura',1,'grammi'),
	(3,'panna',1,'grammi'),
	(3,'riso',2,'grammi');

drop table if exists Availability;
create table Availability (
	username integer not null references UserName (username),
	nameProduct integer not null references Product (nameProduct),
	quantity double not null,
	unitOfMeasure character(30)
);

insert into Availability 
values
	('ale','riso',1,'grammi'),
	('ale','verdura',2,'grammi'),
	('ale','panna',5,'grammi'),
	('fede','riso',6,'grammi');

drop table if exists Rating;
create table Rating (
	username integer not null references UserName (username),
	idRecipe integer not null references Recipe (idRecipe),
	commentRating text,
	rating integer not null
);

insert into Rating 
values
	('ale',1,null,4),
	('ale',2,null,2),
	('fede',3,null,3),
	('fede',1,null,3),
	('tommy',2,null,2),
	('tommy',3,null,3);

drop table if exists Sequence;
create table Sequence (
	idRecipe integer not null references Recipe (idRecipe),
	idStep integer not null references Step (idStep),
	position integer not null
);

insert into Sequence 
values
	(1,1,1),
	(1,3,2),
	(2,1,2),
	(3,2,3);

drop table if exists ToolSet;
create table ToolSet (
	idRecipe integer not null references Recipe (idRecipe),
	nameTool integer not null references Tool (nameTool)
);

drop table if exists Author;
create table Author (
	idRecipe integer not null references Recipe (idRecipe),
	username integer not null references UserName (username)
);

select *
from UserName;

select *
from recipe
where authorName = 'fede';

/* Get the rating of a recipe */
select avg(rating)
from Rating natural join Recipe
where nameRecipe = 'Sushi';

/* Get the possible recipes of a given user */
select Recipe.*
from Recipe, Availability a
where a.username = 'fede' and idRecipe not in (
	select idRecipe
	from Ingredient i 
	where
		i.nameProduct not in (select nameProduct from Availability where username = 'fede') or
		(
			i.nameProduct = a.nameProduct and
			i.unitOfMeasure = a.unitOfMeasure and
			i.quantity > a.quantity)
		);