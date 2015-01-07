create table Account (
	username varchar(30) not null,
	pass varchar(32) not null,
	email varchar(100),
	creationTime datetime not null,
	avatar varchar(200),
	
	primary key(username)
) engine=InnoDB;

create table Recipe (
	idRecipe int not null auto_increment,
	nameRecipe varchar(30) not null,
	typeRecipe varchar(30) not null,
	descriptionRecipe text,
	cuisine varchar(30),
	regionalOrigin varchar(30),
	preparationTime int not null,
	difficultyAuthor int not null,
	difficultyUsers double,
	authorName varchar(30),
	authorLink varchar(300),
	username varchar(30) not null,
	rating double,
	
	primary key(idRecipe),
	foreign key(username) references Account(username)
) engine=InnoDB;

create table Step (
	idStep int not null auto_increment,
	descriptionStep varchar(300) not null,
	timeStep int not null,
	photoStep varchar(200),
	videoStep varchar(200),
	
	primary key(idStep)
) engine=InnoDB;

create table Product (
	nameProduct varchar(30) not null,
	classProduct varchar(30) not null,
	unityOfMeasure varchar(10) not null,
	subclassProduct varchar(30),
	photoProduct varchar(200),
	
	primary key(nameProduct)
) engine=InnoDB;

create table Tool (
	nameTool varchar(30) not null,
	photoTool varchar(200),
	
	primary key(nameTool)
) engine=InnoDB;

create table Ingredient (
	idRecipe int not null,
	nameProduct varchar(30) not null,
	quantity double not null,
	optional boolean not null default false,
	
	primary key(idRecipe, nameProduct),
	foreign key(idRecipe) references Recipe(idRecipe),
	foreign key(nameProduct) references Product(nameProduct)
) engine=InnoDB;

create table ProductAvailability (
	username varchar(30) not null,
	nameProduct varchar(30) not null,
	quantity double not null,
	
	primary key(username, nameProduct),
	foreign key(username) references Account(username),
	foreign key(nameProduct) references Product(nameProduct)
) engine=InnoDB;

create table ToolAvailability (
	username varchar(30) not null,
	nameTool varchar(30) not null,
	
	primary key(username, nameTool),
	foreign key(username) references Account(username),
	foreign key(nameTool) references Tool(nameTool)
) engine=InnoDB;

create table Rating (
	username varchar(30) not null,
	idRecipe int not null,
	commentRating text,
	rating int not null,
	difficulty int,
	
	primary key(username, idRecipe),
	foreign key(username) references Account(username),
	foreign key(idRecipe) references Recipe(idRecipe)
) engine=InnoDB;

create table Sequence (
	idRecipe int not null,
	idStep int not null,
	position int not null,

	primary key(idRecipe, idStep),
	foreign key(idRecipe) references Recipe(idRecipe),
	foreign key(idStep) references Step(idStep)
) engine=InnoDB;

create table ToolSet (
	idRecipe int not null,
	nameTool varchar(30) not null,
	optional boolean not null,

	primary key(idRecipe, nameTool),
	foreign key(idRecipe) references Recipe(idRecipe),
	foreign key(nameTool) references Tool(nameTool)
) engine=InnoDB;

create table Author (
	idRecipe int not null,
	username varchar(30) not null,

	primary key(idRecipe, username),
	foreign key(idRecipe) references Recipe(idRecipe),
	foreign key(username) references Account(username)
) engine=InnoDB;