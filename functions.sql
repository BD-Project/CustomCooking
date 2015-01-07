/* Functions */
DELIMITER $

create function isStepUnique(description varchar(300)) returns boolean
begin
	return (select count(*) from Step where descriptionStep = description) = 0;
end $

DELIMITER ;