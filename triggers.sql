/* Triggers */
DELIMITER $

/* Automatically update the overall rating of a recipe. */
drop trigger if exists updateRating $
create trigger updateRating
after insert on Rating
for each row
begin
	declare overallRating double;
    declare overallDifficulty double;
    
	select avg(rating) into overallRating
	from Rating
	where idRecipe = new.idRecipe;
    
	update Recipe
    set rating = overallRating
	where idRecipe = new.idRecipe;
    
    if (new.difficulty != null) then
		select avg(difficulty) into overallDifficulty
		from Rating
		where idRecipe = new.idRecipe;
        
		update Recipe
		set difficultyUsers = overallDifficulty
		where idRecipe = new.idRecipe;
    end if;
end $

/* Automatically update the overall time needed for a recipe. */
drop trigger if exists updateTime $
create trigger updateTime
after insert on Sequence
for each row
begin
	declare overallTime int;
    
	select sum(timeStep) into overallTime
	from Sequence natural join Step
	where idRecipe = new.idRecipe;
	
    update Recipe
    set preparationTime = overallTime
	where idRecipe = new.idRecipe;
end $

DELIMITER ;