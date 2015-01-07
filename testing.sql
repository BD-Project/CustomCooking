/* Testing */
call addAuthor("tommy", "password1", "tommy@studio.unibo.it", null);
call addAuthor("alex", "password2", "alex@studio.unibo.it", null);

select * from Account;

call createRecipe('Sushi', 'I course', 'Rice and fish', 'Japonese', null, 2, 'tommy');
call createRecipe('Ceasar Salad', 'III course', null, 'American', null, 1, 'alex');
call createRecipe('Seitan', 'II course', 'A vegan "meat" made with soy', null, null, 3,'tommy');

call rateRecipe("alex", 1, "A wonderful dish!", 4, 1);
select * from Recipe where idRecipe = 1;
call rateRecipe("tommy", 1, "A dreadful dish!", 1, 3);
select * from Recipe where idRecipe = 1;

call getRecipes(0, 40, 0, 4, "alex");

call addStep('Wash the rice many times', 10, null, null);
call addStep('Boil the water', 12, null, null);
call addStep('Cut the vegetables at Julienne', 5, null, null);

select count(*) from Step;
call addStep('Cut the vegetables at Julienne', 5, null, null);
select count(*) from Step;

select preparationTime from Recipe where idRecipe = 1;
call insertStep(1, 1, 1);
call insertStep(1, 2, 2);
select preparationTime from Recipe where idRecipe = 1;

call addProduct('Rice', 'Cereal', 'gr', null, null);
call addProduct('Cocumber', 'Vegetable', 'gr', null, null);
call addProduct('Salmon roe', 'Fish', 'gr', null, null);

call addTool('hagiri',null);

call addIngredient(1, 'Rice', 100, false);
call addIngredient(1, 'Cocumber', 3, false);
call addIngredient(1, 'Salmon roe', 25, true);

call addAvailability('alex', 'Rice', 100);
call addAvailability('alex', 'Cocumber', 4);
call addAvailability('tommy', 'Rice', 500);