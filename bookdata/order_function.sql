--Dat hang (them sach vao gio hang) sau khi khach xac nhan mua hang
create procedure order_books(a1 integer , a2 character varying , a3 integer)
language plpgsql
as $$
begin
	if a2 not in (select bookisbn from shoppingbasketbooks where shoppingbasketid = a1 and status = 0)
	then
		insert into shoppingbasketbooks(shoppingbasketid,bookisbn,counts,status) values (a1,a2,a3,0);
		update shoppingbasketbooks
		set counts = a3 , price = a3 * (select price from books where bookisbn = a2)
		where shoppingbasketid = a1 and bookisbn = a2 and status= 0 ; 
	end if;
end;
$$

--Xem gio hang cua minh vua moi chon mua

create or replace function view_shoppingbasketbooks(a1 integer) 
returns table (bookISBN character(10) , title character varying , price numeric , counts integer)
as $$
select s.bookisbn , b.title , s.price , s.counts
from shoppingbasketbooks as s , books as b
where s.shoppingbasketid = a1 and s.status = 0 and s.bookisbn = b.bookisbn $$
language sql;

--Thay doi so luong sach muon mua
create procedure change_book_count(a1 integer , a2 character(10) , a3 integer)
language sql
as $$
update shoppingbasketbooks
set counts = a3 , price = a3 * (select price from books where bookisbn = a2)
where shoppingbasketid = a1 and bookisbn = a2 and status= 0 ; 
delete from shoppingbasketbooks where counts = 0;
$$

--Huy gio hang cua minh 
create procedure delete_sbb(a1 integer)
language sql
as $$
delete from shoppingbasketbooks
where shoppingbasketid = a1 and status = 0;
$$

--Xem tong tien truoc khi thanh toan
create or replace function view_total_price(a1 integer)
returns numeric 
as $$
select sum(price) from shoppingbasketbooks
where shoppingbasketid = a1 and status = 0
group by shoppingbasketid $$
language sql;

--Thanh toan
create procedure pay_order(a1 character varying)
language sql
as $$
	insert into orders(accountID,status) values (a1,0);
$$

--Sau khi nguoi dung da thanh toan tien va nhan hang , admin se xac nhan don hang da duoc giao thanh cong bang ham pay_confirm(trong file manager_fuctions)

--Tao data cho bang orders 
call public.order_books(45,'2476338036',5);
call public.order_books(45,'2903221804',5);
call public.order_books(45,'3992439763',5);
call public.pay_order('anhdk123');
call public.pay_confirm(1);

call public.order_books(50, '503507377 ', 1);
call public.pay_order('huongct123');
call public.pay_confirm(2);

call public.order_books(41, '8582347480 ', 1);
call public.order_books(41, '8691118954 ', 1);
call public.pay_order('thaodtt123');
call public.pay_confirm(3);

call public.order_books(5, '503507377', 1);
call public.pay_order('lampv123');
call public.pay_confirm(4);

call public.order_books(11, '503507377', 1);
call public.order_books(11, '3264303698', 2);
call public.pay_order('muoivt123');
call public.pay_confirm(5);

call public.order_books(21, '4593420989 ', 1);
call public.pay_order('thaolt123');
call public.pay_confirm(6);

call public.order_books(1, '1266155198 ', 1);
call public.order_books(1, '3346870588 ', 1);
call public.pay_order('phongnb123');
call public.pay_confirm(7);

call public.order_books(2, '503507377', 1);
call public.pay_order('ngattb123');
call public.pay_confirm(8);

call public.order_books(26, '6589582815 ', 2);
call public.pay_order('ducdq123');
call public.pay_confirm(9);

call public.order_books(31, '8193575083 ', 2);
call public.order_books(31, '9635605633', 2);
call public.order_books(31, '223125172  ', 2);
call public.pay_order('thoanlt123');
call public.pay_confirm(10);

call public.order_books(40, '715557173  ', 2);
call public.pay_order('chinq123');
call public.pay_confirm(11);

call public.order_books(25, '503507377 ', 7);
call public.pay_order('thoavt123');
call public.pay_confirm(12);

call public.order_books(32, '9124539422 ', 1);
call public.pay_order('quept123');
call public.pay_confirm(13);

call public.order_books(4, '5873856370 ', 1);
call public.order_books(4, '6216971077 ', 1);
call public.order_books(4, '7531616165 ', 3);
call public.pay_order('handt123');
call public.pay_confirm(14);

call public.order_books(10, '2982119218',9);
call public.pay_order('thoant123');
call public.pay_confirm(15);

call public.order_books(46, '2476338036 ', 1);
call public.pay_order('vobv123');
call public.pay_confirm(16);

call public.order_books(33, '2476338036 ', 1);
call public.order_books(33, '5604168866 ', 1);
call public.pay_order('huept123');
call public.pay_confirm(17);

call public.order_books(42, '9635605633 ', 3);
call public.pay_order('diepnt123');
call public.pay_confirm(18);

call public.order_books(26, '6589582815 ', 2);
call public.pay_order('ducdq123');
call public.pay_confirm(19);

call public.order_books(20, '2356723536 ', 1);
call public.order_books(20, '3992439763 ', 1);
call public.order_books(20, '2505799350 ', 1);
call public.pay_order('hanhnt123');
call public.pay_confirm(20);

call public.order_books(24, '4593420989 ', 1);
call public.pay_order('duyenpt123');
call public.pay_confirm(21);

call public.order_books(36, '3057976484 ', 1);
call public.order_books(36, '2982119218 ', 1);
call public.order_books(36, '3040617435 ', 1);
call public.order_books(36, '5145922612 ', 1);
call public.pay_order('hienvt123');
call public.pay_confirm(22);

call public.order_books(6, '4508379923', 1);
call public.order_books(6, '5604168866', 1);
call public.pay_order('vylt123');
call public.pay_confirm(23);

call public.order_books(3, '5753450202 ', 2);
call public.pay_order('nhungttt123');
call public.pay_confirm(24);

call public.order_books(49, '3040617435 ', 1);
call public.pay_order('phuonghlh123');
call public.pay_confirm(25);

call public.order_books(45, '1751745627 ', 1);
call public.order_books(45, '2356723536 ', 1);
call public.pay_order('anhdk123');
call public.pay_confirm(26);

call public.order_books(37, '5753450202 ', 1);
call public.order_books(37, '3685407392 ', 1);
call public.pay_order('phuongtb123');
call public.pay_confirm(27);

call public.order_books(20, '2356723536 ', 1);
call public.order_books(20, '3992439763 ', 1);
call public.order_books(20, '2505799350 ', 1);
call public.pay_order('hanhnt123');
call public.pay_confirm(28);

call public.order_books(18, '5146431353 ', 1);
call public.pay_order('hieutq123');
call public.pay_confirm(29);

call public.order_books(15, '9824113274 ', 1);
call public.order_books(15, '5146431353 ', 1);
call public.pay_order('phuongvt123');
call public.pay_confirm(30);

call public.order_books(13, '503507377 ', 1);
call public.pay_order('lannn123');
call public.pay_confirm(31);

call public.order_books(12, '388775696  ', 1);
call public.order_books(12, '5145922612 ', 1);
call public.order_books(12, '6216971077 ', 1);
call public.order_books(12, '6757658100 ', 1);
call public.order_books(12, '8582347480 ', 1);
call public.pay_order('theuct123');
call public.pay_confirm(32);

call public.order_books(34, '5827079618 ', 1);
call public.pay_order('trangktt123');
call public.pay_confirm(33);

call public.order_books(48, '2982119218 ', 2);
call public.pay_order('phuongnt123');
call public.pay_confirm(34);

call public.order_books(23, '5753450202 ', 4);
call public.pay_order('hanghtt123');
call public.pay_confirm(35);

call public.order_books(16, '5146431353 ', 1);
call public.pay_order('vanvt123');
call public.pay_confirm(36);

call public.order_books(7, '1311251456', 5);
call public.pay_order('thuydt123');
call public.pay_confirm(37);

call public.order_books(39, '7232734107', 1);
call public.pay_order('lienmt123');
call public.pay_confirm(38);

call public.order_books(43, '9124539422 ', 1);
call public.pay_order('nhannt123');
call public.pay_confirm(39);

call public.order_books(27, '6589582815 ', 1);
call public.pay_order('ngoanlt123');
call public.pay_confirm(40);

call public.order_books(17, '5146431353 ', 2);
call public.pay_order('bangvt123');
call public.pay_confirm(41);

call public.order_books(38, '6589582815 ', 1);
call public.pay_order('thuanlv123');
call public.pay_confirm(42);

call public.order_books(30, '715557173 ', 1);
call public.pay_order('longhv123');
call public.pay_confirm(43);

call public.order_books(28, '6589582815 ', 5);
call public.pay_order('nhiemnt123');
call public.pay_confirm(44);

call public.order_books(9, '2476338036', 1);
call public.pay_order('hanhlt123');
call public.pay_confirm(45);

call public.order_books(8, '1751745627', 1);
call public.pay_order('namnn123');
call public.pay_confirm(46);

call public.order_books(14, '9635605633 ',2);
call public.pay_order('hant123');
call public.pay_confirm(47);


call public.order_books(19, '1266155198 ', 1);
call public.pay_order('thonghv123');
call public.pay_confirm(48);

call public.order_books(22, '6216971077 ', 3);
call public.pay_order('thuypt123');
call public.pay_confirm(49);

call public.order_books(29, '503507377 ', 1);
call public.pay_order('hoant123');
call public.pay_confirm(50);

call public.order_books(30, '715557173 ', 1);
call public.pay_order('longhv123');
call public.pay_confirm(51);



update orders 
set ordertime = '2020-01-06' , paytime = '2020-01-07'
where orderid = 1;

update orders 
set ordertime = '2020-02-06' , paytime = '2020-02-08'
where orderid = 2;

update orders 
set ordertime = '2020-02-18' , paytime = '2020-02-19'
where orderid = 3;

update orders 
set ordertime = '2020-03-01' , paytime = '2020-03-02'
where orderid = 4;

update orders 
set ordertime = '2020-03-09' , paytime = '2020-03-10'
where orderid = 5;

update orders 
set ordertime = '2020-02-24' , paytime = '2020-03-25'
where orderid = 6;

update orders 
set ordertime = '2020-03-30' , paytime = '2020-04-01'
where orderid = 7;

update orders 
set ordertime = '2020-03-30' , paytime = '2020-03-31'
where orderid = 8;

update orders 
set ordertime = '2020-04-04' , paytime = '2020-04-05'
where orderid = 9;

update orders 
set ordertime = '2020-04-11' , paytime = '2020-04-12'
where orderid = 10;

update orders 
set ordertime = '2020-04-23' , paytime = '2020-04-25'
where orderid = 11;

update orders 
set ordertime = '2020-04-30' , paytime = '2020-05-02'
where orderid = 12;

update orders 
set ordertime = '2020-05-01' , paytime = '2020-05-02'
where orderid = 13;

update orders 
set ordertime = '2020-05-10' , paytime = '2020-05-11'
where orderid = 14;

update orders 
set ordertime = '2020-05-10' , paytime = '2020-05-11'
where orderid = 15;

update orders 
set ordertime = '2020-05-21' , paytime = '2020-05-22'
where orderid = 16;

update orders 
set ordertime = '2020-05-29' , paytime = '2020-06-01'
where orderid = 17;

update orders 
set ordertime = '2020-06-13' , paytime = '2020-06-14'
where orderid = 18;

update orders 
set ordertime = '2020-06-20' , paytime = '2020-06-21'
where orderid = 19;

update orders 
set ordertime = '2020-06-25' , paytime = '2020-06-26'
where orderid = 20;

update orders 
set ordertime = '2020-07-01' , paytime = '2020-07-02'
where orderid = 21;

update orders 
set ordertime = '2020-07-04' , paytime = '2020-07-05'
where orderid = 22;

update orders 
set ordertime = '2020-07-28' , paytime = '2020-07-29'
where orderid = 23;

update orders 
set ordertime = '2020-08-05' , paytime = '2020-08-06'
where orderid = 24;

update orders 
set ordertime = '2020-08-17' , paytime = '2020-08-18'
where orderid = 25;

update orders 
set ordertime = '2020-08-22' , paytime = '2020-08-24'
where orderid = 26;

update orders 
set ordertime = '2020-09-16' , paytime = '2020-09-17'
where orderid = 27;

update orders 
set ordertime = '2020-09-22' , paytime = '2020-09-23'
where orderid = 28;

update orders 
set ordertime = '2020-09-29' , paytime = '2020-09-30'
where orderid = 29;

update orders 
set ordertime = '2020-10-01' , paytime = '2020-10-02'
where orderid = 30;

update orders 
set ordertime = '2021-10-06' , paytime = '2021-10-07'
where orderid = 31;

update orders 
set ordertime = '2020-10-31' , paytime = '2020-11-02'
where orderid = 32;

update orders 
set ordertime = '2020-11-09' , paytime = '2020-11-10'
where orderid = 33;

update orders 
set ordertime = '2020-11-10' , paytime = '2020-11-11'
where orderid = 34;

update orders 
set ordertime = '2020-11-19' , paytime = '2020-11-20'
where orderid = 35;

update orders 
set ordertime = '2020-11-21' , paytime = '2020-11-22'
where orderid = 36;

update orders 
set ordertime = '2020-11-21' , paytime = '2020-11-23'
where orderid = 37;

update orders 
set ordertime = '2020-11-25' , paytime = '2020-11-26'
where orderid = 38;

update orders 
set ordertime = '2020-11-26' , paytime = '2020-11-27'
where orderid = 39;

update orders 
set ordertime = '2020-11-29' , paytime = '2020-12-01'
where orderid = 40;

update orders 
set ordertime = '2020-12-01' , paytime = '2020-12-02'
where orderid = 41;

update orders 
set ordertime = '2021-12-05' , paytime = '2021-12-06'
where orderid = 42;

update orders 
set ordertime = '2020-12-06' , paytime = '2020-12-08'
where orderid = 43;

update orders 
set ordertime = '2020-12-15' , paytime = '2020-12-17'
where orderid = 44;

update orders 
set ordertime = '2022-12-19' , paytime = '2020-12-20'
where orderid = 45;

update orders 
set ordertime = '2020-12-27' , paytime = '2020-12-28'
where orderid = 46;

update orders 
set ordertime = '2020-12-29' , paytime = '2020-12-30'
where orderid = 47;

update orders 
set ordertime = '2021-01-01' , paytime = '2021-01-02'
where orderid = 47;

update orders 
set ordertime = '2021-01-01' , paytime = '2021-01-03'
where orderid = 49;

update orders 
set ordertime = '2021-01-03' , paytime = '2021-01-04'
where orderid = 50;

update orders 
set ordertime = '2021-01-05' , paytime = '2021-01-06'
where orderid = 51;



