--create_view 
create view aut_book as
select bookisbn , string_agg(autname,',') as "authorname"
from authors natural join books_authors natural join books 
group by bookisbn ;

create view cat_book as
select bookisbn , string_agg(catname,',')  as "category"
from categories natural join books_categories natural join books
group by bookisbn ;


--chuc nang 1: tim kiem
--tim kiem theo bookisbn

create or replace function search_bookisbn(isbn character varying) 
returns table (bookisbn character (10) , title character varying , 
			   author_name character varying, category character varying, 
			   publisher_name character varying , publishyear date ,price numeric)
as $$ select   bookisbn , title , authorname , category , pubname , publishyear ,price
from publishers natural join books natural join cat_book natural join aut_book   
where bookisbn like concat('%',isbn,'%') $$
language sql;

select * from search_bookisbn('15');


-- Tìm kiếm theo title:
create or replace function search_title(kytu character varying) 
returns table (bookisbn character (10) , title character varying , 
			   author_name character varying, category character varying, 
			   publisher_name character varying , price numeric)
as $$ select   bookisbn , title , authorname , category , pubname , price
from publishers natural join books natural join cat_book natural join aut_book
where lower(title) like concat('%',lower(kytu),'%') $$
language sql;

select * from search_title('harry potter');


-- Tìm kiếm theo author:

create or replace function search_author(kytu character varying) 
returns table (bookisbn character (10) , title character varying , 
			   author_name character varying, category character varying, 
			   publisher_name character varying , price numeric)
as $$ select   bookisbn , title , authorname , category , pubname , price
from publishers natural join books natural join cat_book natural join aut_book   
where lower(authorname) like concat('%',lower(kytu),'%') $$
language sql;

select * from search_author('mary');

-- Tìm kiếm theo category:
create or replace function search_category(kytu character varying) 
returns table (bookisbn character (10), title character varying , 
			   author_name character varying, category character varying, 
			   publisher_name character varying , price numeric)
as $$ select   bookisbn , title , authorname , category , pubname , price
from publishers natural join books natural join cat_book natural join aut_book   
where  category like concat('%',kytu,'%') $$
language sql;

select * from search_category('Comics');

-- Tìm kiếm theo publisher:
create or replace function search_publisher(kytu character varying) 
returns table (bookisbn character (10) , title character varying , 
			   author_name character varying, category character varying, 
			   publisher_name character varying , price numeric)
as $$ select   bookisbn , title , authorname , category , pubname , price
from publishers natural join books natural join cat_book natural join aut_book   
where lower(pubname) like concat('%',lower(kytu),'%') $$
language sql;

select * from search_publisher('Minotaur');

-- Tìm kiếm theo ky tu bat ky(ten sach , tac gia , nha xuat ban):
create or replace function search_test(kytu character varying) 
returns table (bookisbn character (10) , title character varying , 
			   author_name character varying, category character varying, 
			   publisher_name character varying , price numeric)
as $$ select   bookisbn , title , authorname , category , pubname , price
from publishers natural join books natural join cat_book natural join aut_book   
where lower(title) like concat('%',lower(kytu),'%') or lower(pubname) like concat('%',lower(kytu),'%') or 
lower(authorname) like concat('%',lower(kytu),'%') $$
language sql;

select * from search_test('book');

-- Tìm kiếm theo tuổi
create or replace function search_age( kytu integer)
returns table (bookisbn character (10) , title character varying , 
			   author_name character varying, category character varying, 
			   publisher_name character varying , price numeric,age integer)
as $$ select bookisbn , title , authorname , category , pubname , price, age
from publishers natural join books natural join cat_book natural join aut_book 
where age <= kytu 
order by age desc $$
language sql;

select * from search_age(18);

-- Tìm kiếm theo giá từ thấp đến cao
create or replace function search_price_asc( kytu numeric)
returns table (bookisbn character (10) , title character varying , 
			   author_name character varying, category character varying, 
			   publisher_name character varying , price numeric)
as $$ select bookisbn , title , authorname , category , pubname , price
from publishers natural join books natural join cat_book natural join aut_book 
where price <= kytu order by price asc$$
language sql;

select * from search_price_asc(25);

-- tìm kiếm theo giá từ cao đến thấp
create or replace function search_price_desc( kytu numeric)
returns table (bookisbn character (10) , title character varying , 
			   author_name character varying, category character varying, 
			   publisher_name character varying , price numeric)
as $$ select bookisbn , title , authorname , category , pubname , price
from publishers natural join books natural join cat_book natural join aut_book 
where price <= kytu order by price desc $$
language sql;

select * from search_price_desc(25);

-- tìm kiếm sách đang bán chạy
create or replace function search_selling()
returns table(bookisbn character(10) ,title character varying , author_name text,category text,
			publisher_name character varying ,price numeric)
as $$
select bookisbn , title , authorname , category , pubname , price
from publishers natural join books natural join cat_book natural join aut_book natural join 
(select  bookisbn , sum(counts)as "total" from public.shoppingbasketbooks natural join public.orders group by bookisbn) as orders
 order by total desc;
 $$
 language sql;
 
select * from search_selling();
