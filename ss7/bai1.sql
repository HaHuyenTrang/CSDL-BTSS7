-- create database session7;
use session7;

create table Categories (
	category_id int primary key,
    category_name varchar(255)
);

create table Books (
	book_id int primary key,
    title varchar(255),
    author varchar(255),
    publication_year int,
    available_quantity int,
    category_id int,
    foreign key(category_id) references Categories(category_id)
);

create table Readers (
	reader_id int primary key,
    name varchar(255),
    phone_number varchar(15),
    email varchar(255)
);

create table Borrowing  (
	borrow_id int primary key,
    reader_id int,
    foreign key(reader_id) references Readers(reader_id),
    book_id int,
    foreign key(book_id) references Books(book_id),
    borrow_date date,
    due_date date
);

create table Returning (
	return_id int primary key,
    borrow_id int,
    foreign key(borrow_id) references Borrowing(borrow_id),
    return_date date
);

create table Fines (
	fine_id int primary key,
    return_id int,
    foreign key(return_id) references Returning(return_id),
    fine_amount decimal(10, 2)
);

-- Thêm dữ liệu vào bảng Categories (Thể loại sách)
INSERT INTO Categories (category_id, category_name) VALUES
(1, 'Toán'),
(2, 'Tiếng Anh'),
(3, 'Văn');

-- Thêm dữ liệu vào bảng Books (Sách)
INSERT INTO Books (book_id, title, author, publication_year, available_quantity, category_id) VALUES
(1, 'Math', 'HTrang', 1971, 5, 1),
(2, 'English', 'HTrang', 2013, 3, 2),
(3, 'literature', 'HTrang', 2008, 4, 3);

-- Thêm dữ liệu vào bảng Readers (Độc giả)
INSERT INTO Readers (reader_id, name, phone_number, email) VALUES
(1, 'Nguyễn Văn A', '0123456789', 'a@example.com'),
(2, 'Trần Thị B', '0987654321', 'b@example.com'),
(3, 'Lê Văn C', '0369852147', 'c@example.com');

-- Thêm dữ liệu vào bảng Borrowing (Mượn sách)
INSERT INTO Borrowing (borrow_id, reader_id, book_id, borrow_date, due_date) VALUES
(1, 1, 1, '2024-02-01', '2024-02-15'),
(2, 2, 2, '2024-02-05', '2024-02-19'),
(3, 3, 3, '2024-02-10', '2024-02-24');

-- Thêm dữ liệu vào bảng Returning (Trả sách)
INSERT INTO Returning (return_id, borrow_id, return_date) VALUES
(1, 1, '2024-02-14'),
(2, 2, '2024-02-18'),
(3, 3, '2024-02-25');

-- Thêm dữ liệu vào bảng Fines (Tiền phạt)
INSERT INTO Fines (fine_id, return_id, fine_amount) VALUES
(1, 1, 0.00),
(2, 2, 0.00),
(3, 3, 50000.00);

update Readers
set name = 'HTrang', email = 'HTrang@gmail.com'
where reader_id = 1;


delete from Borrowing where book_id = 2;
delete from Books where book_id = 1;