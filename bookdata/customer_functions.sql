--Dang ky nguoi dung 
create procedure create_accounts(a1 character varying , a2 character varying , a3 character varying ,
								 a4 character varying , a5 character varying , a6 character(10) )
language plpgsql 
as $$
begin
	if length(a1) >= 6 and length(a3) >= 6
	then
	begin
		insert into accounts(accountid,cusname,cuspassword,cusaddress,district,phone)
		values (a1,a2,a3,a4,a5,a6);
		insert into shoppingbaskets(accountid,total_orders) values (a1,0);
	end;
	else raise notice 'Create account fail';
	end if;
end;
$$

call create_accounts('duongnx123','nguyen xuan duong','duong123','tp ha noi','ha dong','0912345678');
select * from accounts

--Dang nhap
create or replace function log_in(a1 character varying , a2 character varying)
returns integer 
as $$
begin
	if a2 = (select cuspassword from accounts where accountid = a1)
	then return 1;
	else return 0;
	end if;
end;
$$ language plpgsql;

create procedure customer_login(a1 character varying , a2 character varying)
language plpgsql
as $$
begin
	if (select * from log_in(a1, a2)) = 1
	then raise notice 'login successfully';
	else raise notice 'accountid or password is not correct ';
	end if;
end;
$$

call customer_login('duongnx123','duong123');

--Xem thong tin ca nhan
create or replace function view_information(a1 character varying)
returns table(account_id character varying , full_name character varying , address character varying  , 
			  phone character(10) , shopping_basket_id integer)
as $$
select accountid , cusname , cusaddress , phone , shoppingbasketid 
from accounts natural join shoppingbaskets
where accountid = a1;
$$ language sql;

select * from view_information('duongnx123');

--Chinh sua thong tin ca nhan
---Thay doi mat khau
create procedure change_password(acc_id character varying, old_pass character varying , new_pass character varying)
language plpgsql 
as $$
begin
	if length(new_pass) >= 6 and new_pass != old_pass and (select * from log_in(acc_id, old_pass)) = 1
	then update accounts
	     set cuspassword = new_pass
	     where accountid = acc_id and cuspassword = old_pass;
	else raise notice 'Change unsuccessfully';
	end if;
end;
$$

call change_password('duongnx123','duong11','duong12');
select * from accounts where accountid = 'duongnx123';

---Thay doi so dien thoai
create procedure change_phone(acc_id character varying, acc_pass character varying ,old_phone character(10) , new_phone character(10))
language plpgsql 
as $$
begin
	if length(new_phone) > 0 and length(new_phone) <= 10 and new_phone != old_phone and (select * from log_in(acc_id, acc_pass)) = 1
	then
		update accounts
		set phone = new_phone
		where accountid = acc_id and cuspassword = acc_pass and phone = old_phone;
	else raise notice 'Change unsuccessfully';
	end if;
end;
$$

select * from accounts where accountid = 'duongnx123';
call change_phone('duongnx123','duong12','0912345678','0999999999');


--Xem lich su don hang da thanh toan thanh cong
create or replace function order_history(a1 character varying)
returns table(order_id integer, bookisbn char(10), title character varying , price numeric ,counts int, order_time date, pay_time date)
as $$
select o.orderid , s.bookisbn, b.title, s.price , s.counts, o.ordertime , o.paytime
from orders as o , shoppingbasketbooks as s , books as b
where o.accountid = a1 and o.status = 1 and o.orderid = s.orderid and s.bookisbn = b.bookisbn
$$ language sql;

select * from order_history('datlt123');

--Xem lich su don hang dang duoc giao den
create or replace function order_not_ship(a1 character varying)
returns table(order_id integer, bookisbn char(10), title character varying ,  price numeric ,counts int, order_time date )
as $$
select o.orderid , s.bookisbn, b.title, s.price , s.counts, o.ordertime 
from orders as o , shoppingbasketbooks as s , books as b
where o.accountid = a1 and o.status = 0 and o.orderid = s.orderid and s.bookisbn = b.bookisbn
$$ language sql;

select * from order_not_ship('datlt123');
