 --Them sach moi vao kho hang
create procedure add_new_book(a1 character(10), a2 character varying , a3 date , a4 numeric , a5 integer , a6 character(7) , a7 integer)
as $$
begin
	if a6 in (select publisherid from publishers)
	then 
		begin
		insert into books(bookisbn,title,publishyear,price,age,publisherid) values (a1, a2 , a3 , a4 , a5 , a6);
		insert into warehouses(bookisbn,bookcount) values (a1,a7);
		end;
	else 
		begin
		insert into publishers(publisherid) values (a6);
		insert into books(bookisbn,title,publishyear,price,age,publisherid) values (a1, a2 , a3 , a4 , a5 , a6);
		insert into warehouses(bookisbn,bookcount) values (a1,a7);
		end;
	end if;
end;
$$ language plpgsql ;

call add_new_book('9999999999','Re-Zero','2015-10-20',15,16,'#8950e2',50);
call add_new_book('1234567890','Re-Life','2017-10-20',15,16,'#123456',50);
call update_publishers_infomation('#123456','NXB Kim Dong','Ha Noi','0912345678');
call add_new_book('1919191919','Kimetsu No Yaiba (Demon Slayer)','2016-02-19',18,16,'#400925',50);

select * from books where bookisbn = '1919191919'


--Cap nhat cac thong tin khac cua nha xuat ban

create procedure update_publishers_infomation(a1 character(7), a2 character varying , a3 character varying , a4 character(10))
as $$
update publishers
set pubname = a2 , pubaddress = a3 , phone = a4
where publisherid = a1;
$$ language sql;

--Cap nhat the loai cho sach moi neu the loai ton tai

create procedure update_category(a1 character(10) , a2 character(4))
as $$
insert into books_categories(bookisbn,categoryid) values (a1,a2);
$$ language sql;

call update_category('1919191919','#695');
call update_category('1919191919','#d8e');
call update_category('1919191919','#999');

select * from categories

--Cap nhat tac gia cho sach moi neu tac gia ton tai

create procedure update_author(a1 character(10) , a2 character(11))
as $$
insert into books_authors(bookisbn,authorid) values (a1,a2);
$$ language sql;

call update_author('1919191919','012345678-9');

select * from search_bookisbn('1919191919');

--Them the loai moi

create procedure add_new_category(a1 character(4) , a2 character varying)
as $$
insert into categories (categoryid , catname) values (a1,a2);
$$ language sql;

call add_new_category('#999','Action');

--Them tac gia moi 

create procedure add_new_author(a1 character(11) , a2 character varying , a3 character varying , a4 character(10))
as $$
insert into authors(authorid, autname , autaddress , phone) values (a1,a2,a3,a4);
$$ language sql;

call add_new_author('012345678-9','Gotouge Koyoharu','Japan','0123456789');

--Xem lich su don hang cua cua hang

create or replace function view_orders() 
returns table (order_id integer , account_id character varying, total_price numeric , 
			   order_time date , pay_time date , status integer)
language sql
as $$
select orderid , accountid , total_price , ordertime , paytime , status
from orders ;
$$

--Cap nhat so luong sach cua mot dau sach
create procedure add_book_number(a1 character(10) , a2 integer)
as $$
update warehouses
set bookcount = bookcount + a2
where bookisbn = a1
$$ language sql;

select * from warehouses;
call add_book_number('3057976484',15);
select * from view_orders()

--Xac nhan nguoi dung da thanh toan 
create procedure pay_confirm(a1 integer)
language sql
as $$
update orders
set status = 1 , payTime = current_date
where orderid = a1 and status = 0;

update shoppingbaskets
set total_orders = total_orders + (select total_price from orders
								   where orderid = a1)
where accountid = (select accountid from orders
				   where orderid = a1);
$$

call pay_confirm(54);

select * from orders
select * from shoppingbaskets where accountid = 'anhdk123';
select * from warehouses

--Xac nhan nguoi dung huy thanh toan 
---Xac nhan don hang bi huy
create procedure not_pay_cconfirm(a1 integer)
language sql
as $$
update orders
set status = -1
where orderid = a1 and status = 0;
$$

---Xem lai order ma bi huy
create or replace function view_order_cancel(a1 integer)
returns table(shoppingbasket_id integer , bookisbn character(10) , counts integer)
language sql
as $$
select shoppingbasketid , bookisbn , counts
from shoppingbasketbooks
where orderid = a1;
$$

---Cap nhat lai so luong sach bi huy
create procedure update_book_cancel(a1 character(10) , a2 integer)
language sql
as $$
update warehouses
set booksale = booksale - a2 
where bookisbn = a1;
$$

--Xem tong doanh thu cua moi thang theo nam 
create or replace function view_total_price_per_month(a1 integer) 
returns table (months double precision , total_prices numeric)
as $$
	select e.months , sum(e.total_price)
	from (select total_price , date_part('month',paytime) as months
		  from orders
		  where status = 1 and extract(year from paytime)::integer = a1) as e
	group by e.months
$$ language sql;

select * from view_total_price_per_month(2020);

--Xem so luong sach ban theo thang
create or replace function topselling(a1 integer,a2 integer)
returns table( title character varying , author_name character varying ,total bigint)
as $$
select  title , authorname ,total
from publishers natural join books natural join cat_book natural join aut_book natural join 
(select  bookisbn, sum(counts)as "total" from public.shoppingbasketbooks natural join 
( select * from orders where extract (month from paytime):: integer = a1 and extract (years from paytime):: integer= a2) as orders group by bookisbn) as neworders
 order by total desc;
 $$
 language sql;
 
select * from topselling(1,2020);




