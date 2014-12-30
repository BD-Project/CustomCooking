create database if not exists CustomCooking;
use CustomCooking;

drop table if exists Rating;
drop table if exists ToolAvailability;
drop table if exists ProductAvailability;
drop table if exists Ingredient;
drop table if exists ToolSet;
drop table if exists Author;
drop table if exists Sequence;
drop table if exists Step;
drop table if exists Recipe;
drop table if exists Product;
drop table if exists Tool;
drop table if exists UserName;

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

create table Product (
	nameProduct character(30) not null primary key,
	photoProduct character(100)
);

insert into Product 
values
	('riso',null),
	('verdura',null),
	('panna',null);

create table Tool (
	nameTool character(30) not null primary key,
	photoTool character(100)
);

insert into Tool 
values
	('hagiri',null),
	('ciotola',null),
	('cucchiaio',null);

create table UserName (
	username character(30) not null primary key,
	email character(100)
);

insert into UserName 
values
	('ale',null),
	('tommy',null),
	('fede',null);

create table Ingredient (
	idRecipe integer not null,
	nameProduct character(30) not null,
	quantity double not null,
    optional boolean not null default false,
    
    primary key(idRecipe, nameProduct),
    foreign key(idRecipe) references Recipe(idRecipe),
    foreign key(nameProduct) references Product(nameProduct)
);

insert into Ingredient 
values
	(1,'riso',1,false),
	(2,'verdura',1,false),
	(3,'panna',1,false);

create table ProductAvailability (
	username character(30) not null,
	nameProduct character(30) not null,
	quantity double not null,
    
    primary key(username, nameProduct),
    foreign key(username) references UserName(username),
    foreign key(nameProduct) references Product(nameProduct)
);

insert into ProductAvailability 
values
	('ale','riso',10),
	('ale','verdura',20),
	('ale','panna',50),
	('fede','riso',6);

create table ToolAvailability (
	username character(30) not null,
	nameTool character(30) not null,
    
    primary key(username, nameTool),
    foreign key(username) references UserName(username),
    foreign key(nameTool) references Tool(nameTool)
);

create table Rating (
	username character(30) not null,
	idRecipe integer not null,
	commentRating text,
	rating integer not null,
    
    primary key(username, idRecipe),
    foreign key(username) references UserName(username),
    foreign key(idRecipe) references Recipe(idRecipe)
);

insert into Rating 
values
	('ale',1,null,4),
	('ale',2,null,2),
	('fede',3,null,3),
	('fede',1,null,3),
	('tommy',2,null,2),
	('tommy',3,null,3);

create table Sequence (
	idRecipe integer not null,
	idStep integer not null,
	position integer not null,

	primary key(idRecipe, idStep),
    foreign key(idRecipe) references Recipe(idRecipe),
    foreign key(idStep) references Step(idStep)
);

insert into Sequence 
values
	(1,1,1),
	(1,3,2),
	(2,1,2),
	(3,2,3);

create table ToolSet (
	idRecipe integer not null,
	nameTool character(30) not null,
    optional boolean not null,

	primary key(idRecipe, nameTool),
    foreign key(idRecipe) references Recipe(idRecipe),
    foreign key(nameTool) references Tool(nameTool)
);

create table Author (
	idRecipe integer not null,
	username character(30) not null,

	primary key(idRecipe, username),
    foreign key(idRecipe) references Recipe(idRecipe),
    foreign key(username) references UserName(username)
);

/* Get the rating of a recipe */
select avg(rating)
from Rating natural join Recipe
where nameRecipe = 'Sushi';

/* Get the possible recipes of a given user */
select *
from Recipe
where idRecipe not in (
	select idRecipe
	from Ingredient i 
	where
		i.nameProduct not in (select nameProduct from ProductAvailability where username = 'fede') or
        i.quantity > (
			select a.quantity
            from ProductAvailability a
            where 
				a.username = 'fede' and 
                i.nameProduct = a.nameProduct));
                
select *
from Recipe
where idRecipe not in (
	select idRecipe
	from Ingredient i 
	where not exists (
		select *
        from ProductAvailability a
        where 
			a.username = 'ale' and 
			i.nameProduct = a.nameProduct and
            i.quantity <= a.quantity));

/* Get the possible recipes for a given user accordingly by time, difficulty and avaiability, ordered by rating */
select Recipe.*, avg(rating) as AverageRating
from Recipe natural join Rating
where
	timeRecipe <= 100 and
	difficulty <= 100 and
	idRecipe not in (
	select idRecipe
	from Ingredient i 
	where
		i.optional = false and
		not exists (
			select *
			from ProductAvailability a
			where 
				a.username = 'tommy' and 
				i.nameProduct = a.nameProduct and
				i.quantity <= a.quantity))
group by idRecipe
order by avg(rating) desc;