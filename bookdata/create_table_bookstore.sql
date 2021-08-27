create table accounts (
	accountID character varying primary key,
	cusName character varying,
	cusPassword character varying,
	phone character(10),
	cusAddress character varying,
	district character varying
);

create table publishers(
	publisherID character(7) primary key,
	pubName character varying,
	pubAddress character varying,
	phone character(10)
);

create table authors(
	authorID character(11) primary key,
	autName character varying,
	autAddress character varying,
	phone character(10)
);

create table categories(
	categoryID character(4) primary key,
	catName character varying 
);

create table books(
	bookISBN character(10) primary key,
	title character varying,
	publishYear date,
	price numeric,
	age integer,
	publisherid character(7),
	foreign key (publisherid) references publishers(publisherid)
);

create table warehouses(
	bookisbn character(10) primary key,
	bookcount integer check(bookcount > 0),
	booksale integer check(booksale >= 0 and booksale <= bookcount),
	foreign key (bookisbn) references books(bookisbn)
);


create table shoppingBaskets(
	shoppingBasketID serial primary key,
	accountID character varying,
	total_orders numeric,
	foreign key (accountID) references accounts(accountID)
);

create table orders(
	orderID serial primary key,
	accountID character varying,
	total_price numeric,
	orderTime date default current_date,
	payTime date,
	status integer check(status = 0 or status = 1 or status = -1),
	foreign key (accountID) references accounts(accountID)
);

create table shoppingBasketBooks(
	shoppingBasketID integer,
	bookISBN character(10),
	orderID integer,
	counts integer,
	price  numeric,
	status integer check (status = 0 or status = 1 or status = -1),
	foreign key (shoppingBasketID) references shoppingBaskets(shoppingBasketID),
	foreign key (bookISBN) references books(bookISBN),
	foreign key (orderID) references orders(orderID)
);


create table books_authors(
	bookisbn character(10),
	authorid character(11),
	primary key (bookisbn , authorid),
	foreign key (bookisbn) references books(bookisbn),
	foreign key (authorid) references authors(authorid)
);

create table books_categories(
	bookisbn character(10),
	categoryid character(4),
	primary key (bookisbn , categoryid),
	foreign key (bookisbn) references books(bookisbn),
	foreign key (categoryid) references categories(categoryid)
);


