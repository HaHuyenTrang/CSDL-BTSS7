use session7;

create table customer (
    cid int primary key,
    name varchar(25),
    cage tinyint
);

insert into customer (cid, name, cage) values
(1, 'Minh Quan', null),
(2, 'Ngoc Oanh', 20),
(3, 'Hong Ha', 50);

create table orders (
    oid int primary key,
    cid int,
    odate datetime,
    ototalprice int,
    foreign key (cid) references customer(cid)
);

insert into orders (oid, cid, odate, ototalprice) values
(1, 1, '2006-03-21', null),
(2, 1, '2006-03-23', null),
(3, 2, '2006-03-16', null);

create table product (
    pid int primary key,
    pname varchar(25),
    pprice int
);

insert into product (pid, pname, pprice) values
(1, 'may giat', 3),
(2, 'tu lanh', 5),
(3, 'dieu hoa', 7),
(4, 'quat', 3),
(5, 'bep dien', 2);

create table orderdetail (
    oid int,
    pid int,
    oqty int,
    foreign key (oid) references orders(oid),
    foreign key (pid) references product(pid)
);

insert into orderdetail (oid, pid, oqty) values
(1, 1, 3),
(1, 3, 7),
(1, 4, 2),
(2, 1, 5),
(2, 3, 3);


-- 1. Hiển thị danh sách hóa đơn, sắp xếp theo ngày tháng giảm dần:
select oid, cid, odate, ototalprice
from orders
order by odate desc;

-- 2. Hiển thị tên và giá của sản phẩm có giá cao nhất:
select pname, pprice
from product
where pprice = (select max(pprice) from product);

-- 3. Hiển thị danh sách khách hàng đã mua hàng và sản phẩm họ đã mua:
select customer.name as cname, product.pname
from customer
join orders on customer.cid = orders.cid
join orderdetail on orders.oid = orderdetail.oid
join product on orderdetail.pid = product.pid;

--  4. Hiển thị những khách hàng chưa mua bất kỳ sản phẩm nào:


