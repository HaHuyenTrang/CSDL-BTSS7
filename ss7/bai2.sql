
create table Departments (
	department_id int primary key,
    department_name varchar(255),
    location varchar(255)
);

create table Employees (
	employee_id int primary key,
    name varchar(255),
    dod date,
    department_id int,
    foreign key(department_id) references Departments(department_id),
    salary decimal(10, 2)
);

create table Projects (
	project_id int primary key,
    project_name varchar(255),
    start_date date,
    end_date date
);


create table Timesheets (
	timesheet_id int primary key,
    employee_id int,
    foreign key(employee_id) references Employees(employee_id),
    project_id int,
    foreign key(project_id) references Projects(project_id),
    work_date date,
    hours_worked decimal(5, 2)
);


create table WorkReports (
	report_id int primary key,
    employee_id int,
    foreign key(employee_id) references Employees(employee_id),
    report_date date,
    report_content text
);

-- Thêm dữ liệu vào bảng Departments (Phòng ban)
INSERT INTO Departments (department_id, department_name, location) VALUES
(1, 'IT', 'Hà Nội'),
(2, 'Kinh doanh', 'Nha Trang'),
(3, 'Giám đốc', 'Đà Nẵng');

-- Thêm dữ liệu vào bảng Employees (Nhân viên)
INSERT INTO Employees (employee_id, name, dod, department_id, salary) VALUES
(1, 'Nguyễn Văn A', '1990-05-10', 1, 15000000),
(2, 'Trần Thị B', '1995-10-20', 2, 12000000),
(3, 'Lê Văn C', '1988-11-30', 3, 18000000);

-- Thêm dữ liệu vào bảng Projects (Dự án)
INSERT INTO Projects (project_id, project_name, start_date, end_date) VALUES
(1, 'Thiết kế', '2024-01-01', '2024-06-30'),
(2, 'chức năng', '2024-02-15', '2024-09-15'),
(3, 'giao diện', '2024-03-10', '2024-12-31');

-- Thêm dữ liệu vào bảng Timesheets (Chấm công)
INSERT INTO Timesheets (timesheet_id, employee_id, project_id, work_date, hours_worked) VALUES
(1, 1, 1, '2024-02-10', 8.00),
(2, 2, 2, '2024-02-11', 7.00),
(3, 3, 3, '2024-02-12', 9.50);

-- Thêm dữ liệu vào bảng WorkReports (Báo cáo công việc)
INSERT INTO WorkReports (report_id, employee_id, report_date, report_content) VALUES
(1, 1, '2024-06-10', 'Hoàn thành thiết kế giao diện trang quản lý khách hàng.'),
(2, 2, '2024-06-11', 'phân tích chức năng'),
(3, 3, '2024-06-12', 'Hoàn thành giao diện.');


update Projects
set project_name = 'Lập trình ứng dụng web'
where project_id = 1;

delete from Timesheets where employee_id = 1;
delete from WorkReports where employee_id = 1;
delete from Employees where employee_id = 1;