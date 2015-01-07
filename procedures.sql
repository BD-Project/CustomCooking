/* Stored Procedures */
DELIMITER $

drop procedure if exists addAuthor $
create procedure addAuthor(in username varchar(30), pass varchar(30), email varchar(30), avatar varchar(200))
language sql
sql security invoker
comment 'Add an author'
begin
	insert into Account
		values (username, md5(pass), email, now(), avatar);
end $

drop procedure if exists addProduct $
create procedure addProduct(in nameProduct varchar(30), classProduct varchar(30), unityOfMeasure varchar(10), subclassProduct varchar(30), photoProduct varchar(200))
language sql
sql security invoker
comment 'Add a product'
begin
	insert into Product values (nameProduct, classProduct, unityOfMeasure, subclassProduct, photoProduct);
end $

drop procedure if exists addTool $
create procedure addTool(in nameTool varchar(30), photoTool varchar(200))
language sql
sql security invoker
comment 'Add a tool'
begin
	insert into Tool values (nameTool, photoTool);
end $

drop procedure if exists addIngredient $
create procedure addIngredient(in idRecipe integer, nameProduct varchar(30), quantity double, optional boolean)
language sql
sql security invoker
comment 'Add an ingredient'
begin
	insert into Ingredient values (idRecipe, nameProduct, quantity, optional);
end $

drop procedure if exists addAvailability $
create procedure addAvailability(in username varchar(30), nameProduct varchar(30), quantity double)
language sql
sql security invoker
comment 'Add an availability'
begin
	insert into ProductAvailability values (username, nameProduct, quantity);
end $

drop procedure if exists addStep $
create procedure addStep(in descriptionStep varchar(300), timeStep int, photoStep varchar(200), videoStep varchar(200))
language sql
sql security invoker
comment 'Create a step'
begin
	if isStepUnique(descriptionStep) then
		insert
			into Step (descriptionStep, timeStep, photoStep, videoStep)
			values (descriptionStep, timeStep, photoStep, videoStep);
	end if;
end $

drop procedure if exists insertStep $
create procedure insertStep(in idRecipe integer, idStep integer, position integer)
language sql
sql security invoker
comment 'Insert a step in a sequence'
begin
	insert into Sequence values (idRecipe, idStep, position);
end $

drop procedure if exists createRecipe $
create procedure createRecipe(in nameRecipe varchar(30), typeRecipe varchar(30), descriptionRecipe text, 
	cuisine varchar(30), regionalOrigin varchar(30), difficulty integer, username varchar(30))
language sql
sql security invoker
comment 'Create a recipe'
begin
	insert into Recipe (nameRecipe, typeRecipe, descriptionRecipe, cuisine, regionalOrigin, preparationTime, difficultyAuthor, username) 
		values (nameRecipe, typeRecipe, descriptionRecipe, cuisine, regionalOrigin, 0, difficultyAuthor, username);
end $

drop procedure if exists rateRecipe $
create procedure rateRecipe(in username varchar(30), idRecipe int, commentRating text, rating int, difficulty int)
language sql
sql security invoker
comment 'Rate a recipe'
begin
	insert into Rating values (username, idRecipe, commentRating, rating, difficulty);
end $

/* Get the possible recipes for a given user accordingly by time, difficulty and avaiability, ordered by rating */
drop procedure if exists getRecipes $
create procedure getRecipes(in timeMin int, timeMax int, diffMin int, diffMax int, username varchar(30))
language sql
sql security invoker
comment 'Get the recipes'
begin
	select Recipe.*
	from Recipe
	where
		preparationTime between timeMin and timeMax and
		(
			(difficultyAuthor between diffMin and diffMax) or
			(difficultyUsers between diffMin and diffMax)
		) and
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

DELIMITER ;