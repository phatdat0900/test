--He thong xac nhan nguoi dung mua hang
create or replace function after_pay() returns trigger as $trigger_after_pay$
begin
	update shoppingbasketbooks
	set orderID = new.orderID
	where shoppingbasketID = (select shoppingbasketID from shoppingbaskets
							 where shoppingbaskets.accountID = new.accountID)
		 and  status = 0;
	
	update shoppingbasketbooks
	set status = 1
	where shoppingbasketID = (select shoppingbasketID from shoppingbaskets
							  where shoppingbaskets.accountID = new.accountID)
		 and  status = 0;
		 
	delete from orders
	where total_price is null;
	
	return new;
end;
$trigger_after_pay$ language plpgsql;

create trigger trigger_after_pay after insert on orders
for each row execute procedure after_pay();

--He thong cap nhat tong tien cho moi order
create or replace function update_total_price() returns trigger as $trigger_total_price$
begin
	update orders
	set total_price = (select sum(price) from shoppingbasketbooks
					   where orders.orderID = shoppingbasketbooks.orderID and shoppingbasketbooks.status = 1
					   group by orderID);
	return new;
end;
$trigger_total_price$ language plpgsql;

create trigger trigger_total_price after update on shoppingbasketbooks
for each row execute procedure update_total_price();


--He thong cap nhat lai so luong sach ban ra trong kho khi nguoi dung xac nhan thanh toan
create or replace function book_count() returns trigger as $trigger_book_count$
begin
	update warehouses
	set booksale = (select sum(counts) from shoppingbasketbooks
					where warehouses.bookisbn = shoppingbasketbooks.bookisbn and shoppingbasketbooks.status = 1
					group by bookisbn);				
	return new;
end;
$trigger_book_count$ language plpgsql;

create trigger trigger_book_count after update on shoppingbasketbooks
for each row execute procedure book_count();

--He thong kiem tra tu dong kiem tra:
---Sau khi tao tai khoan
create or replace function insert_account() returns trigger as $trigger_insert_account$
begin
	if length(new.accountid) < 6 or length(new.cuspassword) < 6 then
		rollback;
	end if;
end;
$trigger_insert_account$ language plpgsql;

create trigger trigger_insert_account after insert on accounts
for each row execute procedure insert_account();

---Sau khi thay doi mat khau
create or replace function change_pass() returns trigger as $trigger_change_pass$
begin
	if new.cuspassword = old.cuspassword or length(new.cuspassword) < 6 then
		rollback;
	end if;
end;
$trigger_change_pass$ language plpgsql;

create trigger trigger_change_pass after update on accounts
for each row execute procedure change_pass();


---Sau khi thay doi so dien thoai
create or replace function change_phonenum() returns trigger as $trigger_change_phonenum$
begin
	if new.phone = old.phone or length(new.cuspassword) != 10 then
		rollback;
	end if;
end;
$trigger_change_phonenum$ language plpgsql;

create trigger trigger_change_phonenum after update on accounts
for each row execute procedure change_phonenum();





