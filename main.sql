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
drop table if exists Account;

create table Recipe (
	idRecipe integer not null auto_increment,
	nameRecipe varchar(30) not null,
	typeRecipe varchar(30) not null,
	descriptionRecipe text,
	cuisine varchar(30),
	regionalOrigin varchar(30),
	timeRecipe integer not null,
	difficulty integer not null,
	authorName varchar(30) not null,
    rating double,
    
    primary key(idRecipe)
);

create table Step (
	idStep integer not null auto_increment,
	descriptionStep varchar(300) not null,
	timeStep int not null,
	photoStep varchar(200),
	videoStep varchar(200),
    
    primary key(idStep)
);

create table Product (
	nameProduct varchar(30) not null,
	photoProduct varchar(200),
    
    primary key(nameProduct)
);

create table Tool (
	nameTool varchar(30) not null,
	photoTool varchar(200),
    
    primary key(nameTool)
);

create table Account (
	username varchar(30) not null,
    pass varchar(32) not null,
	email varchar(100),
    creationTime datetime,
    
    primary key(username)
);

create table Ingredient (
	idRecipe integer not null,
	nameProduct varchar(30) not null,
	quantity double not null,
    optional boolean not null default false,
    
    primary key(idRecipe, nameProduct),
    foreign key(idRecipe) references Recipe(idRecipe),
    foreign key(nameProduct) references Product(nameProduct)
);

create table ProductAvailability (
	username varchar(30) not null,
	nameProduct varchar(30) not null,
	quantity double not null,
    
    primary key(username, nameProduct),
    foreign key(username) references Account(username),
    foreign key(nameProduct) references Product(nameProduct)
);

create table ToolAvailability (
	username varchar(30) not null,
	nameTool varchar(30) not null,
    
    primary key(username, nameTool),
    foreign key(username) references Account(username),
    foreign key(nameTool) references Tool(nameTool)
);

create table Rating (
	username varchar(30) not null,
	idRecipe integer not null,
	commentRating text,
	rating integer not null,
    
    primary key(username, idRecipe),
    foreign key(username) references Account(username),
    foreign key(idRecipe) references Recipe(idRecipe)
);

create table Sequence (
	idRecipe integer not null,
	idStep integer not null,
	position integer not null,

	primary key(idRecipe, idStep),
    foreign key(idRecipe) references Recipe(idRecipe),
    foreign key(idStep) references Step(idStep)
);

create table ToolSet (
	idRecipe integer not null,
	nameTool varchar(30) not null,
    optional boolean not null,

	primary key(idRecipe, nameTool),
    foreign key(idRecipe) references Recipe(idRecipe),
    foreign key(nameTool) references Tool(nameTool)
);

create table Author (
	idRecipe integer not null,
	username varchar(30) not null,

	primary key(idRecipe, username),
    foreign key(idRecipe) references Recipe(idRecipe),
    foreign key(username) references Account(username)
);

/* Stored Procedures */
DELIMITER $

drop procedure if exists addAuthor $
create procedure addAuthor(in username varchar(30), pass varchar(30), email varchar(30))
comment 'Add an author'
begin
	insert into Account values (username, md5(pass), email, now());
end $

drop procedure if exists addProduct $
create procedure addProduct(in nameProduct varchar(30), photoProduct varchar(200))
comment 'Add a product'
begin
	insert into Product values (nameProduct, photoProduct);
end $

drop procedure if exists addTool $
create procedure addTool(in nameTool varchar(30), photoTool varchar(200))
comment 'Add a tool'
begin
	insert into Tool values (nameTool, photoTool);
end $

drop procedure if exists addIngredient $
create procedure addIngredient(in idRecipe integer, nameProduct varchar(30), quantity double, optional boolean)
comment 'Add an ingredient'
begin
	insert into Ingredient values (idRecipe, nameProduct, quantity, optional);
end $

drop procedure if exists addAvailability $
create procedure addAvailability(in username varchar(30), nameProduct varchar(30), quantity double)
comment 'Add an availability'
begin
	insert into ProductAvailability values (username, nameProduct, quantity);
end $

drop procedure if exists createRecipe $
create procedure createRecipe(in nameRecipe varchar(30), typeRecipe varchar(30), descriptionRecipe text, 
	cuisine varchar(30), regionalOrigin varchar(30), timeRecipe integer, difficulty integer, authorName varchar(30))
comment 'Create a recipe'
begin
	insert into Recipe (nameRecipe, typeRecipe, descriptionRecipe, cuisine, regionalOrigin, timeRecipe, difficulty, authorName) 
		values (nameRecipe, typeRecipe, descriptionRecipe, cuisine, regionalOrigin, timeRecipe, difficulty, authorName);
end $

drop procedure if exists rateRecipe $
create procedure rateRecipe(in username varchar(30), idRecipe int, commentRating text, rating int)
comment 'Rate a recipe'
begin
	insert into Rating values (username, idRecipe, commentRating, rating);
end $

drop procedure if exists createStep $
create procedure createStep(in descriptionStep text, timeStep int, photoStep varchar(200), videoStep varchar(200))
comment 'Create a step'
begin
	insert into Step (descriptionStep, timeStep, photoStep, videoStep) values (descriptionStep, timeStep, photoStep, videoStep);
end $

/* Get the possible recipes for a given user accordingly by time, difficulty and avaiability, ordered by rating */
drop procedure if exists getRecipes $
create procedure getRecipes(in timeMin int, timeMax int, diffMin int, diffMax int, username varchar(30))
begin
	select Recipe.*
	from Recipe
	where
		timeRecipe between timeMin and timeMax and
		difficulty between diffMin and diffMax and
		idRecipe not in (
			select idRecipe
			from Ingredient i 
			where
				i.optional = false and
				not exists (
					select *
					from ProductAvailability a
					where 
						a.username = username and 
						i.nameProduct = a.nameProduct and
						i.quantity <= a.quantity))
	order by rating desc;
end $

/* Automatically update the overall rating of a recipe. */
drop trigger if exists updateRating $
create trigger updateRating
after insert on Rating
for each row
begin
	declare overallRating double;
    
	select avg(rating) into overallRating
	from Rating
	where idRecipe = new.idRecipe;
	
    update Recipe
    set rating = overallRating
	where idRecipe = new.idRecipe;
end $

DELIMITER ;

/* Testing */
call createAuthor("tommy", "HakunaMatata", "tommy@studio.unibo.it");
call createAuthor("alex", "AvadaKedavra", "alex@studio.unibo.it");

select * from Account;

call createRecipe('Sushi', 'I course', 'Rice and fish', 'Japonese', null, 40, 2, 'tommy');
call createRecipe('Ceasar Salad', 'III course', null, 'American', null, 15, 1, 'alex');
call createRecipe('Seitan', 'II course', 'A vegan "meat" made with soy', null, null, 45, 3,'tommy');

call rateRecipe("alex", 1, "A wonderful dish!", 4);

select rating from Recipe where idRecipe = 1;

call rateRecipe("tommy", 1, "A dreadful dish!", 1);

select rating from Recipe where idRecipe = 1;

call getRecipes(0, 40, 0, 4, "alex");

call createStep('Wash the rice many times', 10, null, null);
call createStep('Boil the water', 12, null, null);
call createStep('Cut the vegetables at Julienne', 5, null, null);

call addProduct('Rice', null);
call addProduct('Cocumber', null);
call addProduct('Salmon roe', null);

call addTool('hagiri',null);

call addIngredient(1, 'Rice', 100, false);
call addIngredient(1, 'Cocumber', 3, false);
call addIngredient(1, 'Salmon roe', 25, true);

call addAvailability('alex', 'Rice', 100);
call addAvailability('alex', 'Cocumber', 4);
call addAvailability('tommy', 'Rice', 500);