
-- create database thuchanhCSDL;
use thuchanhCSDL;

CREATE TABLE tbl_users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tbl_employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    position VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tbl_orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    employee_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) DEFAULT 0.00,
    status ENUM('Pending', 'Completed', 'Canceled') DEFAULT 'Pending',
    FOREIGN KEY (user_id) REFERENCES tbl_users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (employee_id) REFERENCES tbl_employees(employee_id) ON DELETE SET NULL
);

CREATE TABLE tbl_products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tbl_order_detail (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) GENERATED ALWAYS AS (quantity * unit_price) STORED,
    FOREIGN KEY (order_id) REFERENCES tbl_orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES tbl_products(product_id) ON DELETE CASCADE
);
-- ALTER là một lệnh trong SQL dùng để thay đổi cấu trúc của bảng mà không cần phải xóa và tạo lại bảng

-- Thêm cột order_status vào bảng tbl_orders 
ALTER TABLE tbl_orders 
ADD COLUMN order_status ENUM('Pending', 'Processing', 'Completed', 'Cancelled') DEFAULT 'Pending';

-- Đổi kiểu dữ liệu cột phone trong bảng tbl_users thành VARCHAR(11)
ALTER TABLE tbl_users 
MODIFY COLUMN phone VARCHAR(11);

-- Xóa cột email khỏi bảng tbl_users
ALTER TABLE tbl_users 
DROP COLUMN email;


-- cau 2
INSERT INTO tbl_users (full_name, phone, address) 
VALUES 
('Nguyễn Văn A', '0987654321', 'Hà Nội'),
('Trần Thị B', '0912345678', 'TP. Hồ Chí Minh'),
('Lê Văn C', '0909123456', 'Đà Nẵng'); -- Đây có thể là nhân viên


INSERT INTO tbl_employees (full_name, email, phone, position, salary, hire_date) 
VALUES 
('Lê Văn C', 'levanc@company.com', '0909123456', 'Nhân viên bán hàng', 8000000, '2023-05-10'),
('Hoàng Minh D', 'hoangminhd@company.com', '0911223344', 'Quản lý', 15000000, '2022-08-15'),
('Phạm Thị E', 'phamthie@company.com', '0988112233', 'Kế toán', 12000000, '2021-12-01');


INSERT INTO tbl_products (product_name, description, price, stock_quantity) 
VALUES 
('Laptop Dell', 'Laptop Dell Inspiron 15', 15000000, 10),
('iPhone 14', 'Điện thoại iPhone 14 Pro Max', 28000000, 20),
('Bàn phím cơ', 'Bàn phím cơ RGB', 1200000, 50);


INSERT INTO tbl_orders (user_id, employee_id, total_amount, status, order_status) 
VALUES 
(1, 1, 15000000, 'Pending', 'Processing'),
(2, 2, 28000000, 'Completed', 'Completed'),
(3, NULL, 1200000, 'Pending', 'Pending'); -- Không có nhân viên xử lý


INSERT INTO tbl_order_detail (order_id, product_id, quantity, unit_price) 
VALUES 
(1, 1, 1, 15000000),  -- 1 Laptop Dell
(2, 2, 1, 28000000),  -- 1 iPhone 14
(3, 3, 2, 1200000);   -- 2 Bàn phím cơ

 -- câu 4
 
 select 
	order_id, order_date, total_amount,  status 
from tbl_orders;

-- Viết truy vấn lấy danh sách tên khách hàng đã đặt hàng, không trùng lặp.
select distinct  u.full_name 
from tbl_users u
join tbl_orders o on u.user_id = o.user_id;

-- DISTINCT là từ khóa dùng để loại bỏ các giá trị trùng lặp trong kết quả truy vấn.

-- câu 5
select
	product_name, stock_quantity
from tbl_products join tbl_orders on product_id =  order_id ;

-- Viết truy vấn lấy tổng doanh thu từ từng sản phẩm, sắp xếp theo doanh thu giảm dần.
select
	p.product_name,  SUM(o.quantity * o.unit_price) AS total_revenue
from tbl_order_detail o join tbl_products p on o.product_id = p.product_id group by p.product_name  order by total_revenue desc;


-- câu 6
select 
    u.user_id, u.full_name as customer_name,  
    COUNT(o.order_id) as total_orders -- Đếm số đơn hàng mà mỗi khách hàng đã đặt.
from tbl_users u
left join tbl_orders o on u.user_id = o.user_id
group by u.full_name,u.user_id
order by total_orders desc;
 
 
 select 
    u.user_id, u.full_name as customer_name,  
    COUNT(o.order_id) as total_orders -- Đếm số đơn hàng mà mỗi khách hàng đã đặt.
from tbl_users u
left join tbl_orders o on u.user_id = o.user_id
group by u.full_name,u.user_id having total_orders>2
order by total_orders desc;
 
 
 -- câu 7
 select
	u.full_name, sum(o.total_amount) as total_money
from tbl_users u join tbl_orders o on  u.user_id = o.user_id
group by  u.full_name
limit 2; -- dữ liệu 3 bản ghi

-- 8
select 
	e.full_name , e.position  , COUNT(o.order_id) as total_orders_handled
from tbl_employees e left join tbl_orders o on e.employee_id = o.employee_id -- left join lấy nv 0 đơn hàng
group by e.employee_id,	e.full_name, e.position;

-- 9
select
	full_name, max(o.total_amount) as total_money
from tbl_users u join tbl_orders o on  u.user_id = o.user_id
group by  u.full_name;

-- 10
 select
	p.product_id, p.product_name, p.stock_quantity
from tbl_products p left join tbl_order_detail o on p.product_id = o.product_id where o.order_detail_id is null
group by p.product_id, p.product_name, p.stock_quantity ;