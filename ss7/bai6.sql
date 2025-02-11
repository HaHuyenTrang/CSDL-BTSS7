create table Employeess (
	employee_id int primary key,
    name varchar(255),
    dob date,
    department_id int,
    foreign key (department_id) references  departments(department_id)
);

create table departmentss(
    department_id int primary key,
    department_name varchar(255) not null,
    location varchar(255)
);

create table projectss (
    project_id int primary key,
    project_name varchar(255) not null,
    start_date date,
    end_date date
);

create table timesheetss (
    timesheet_id int primary key,
    employee_id int,
    project_id int,
    work_date date not null,
    hours_worked decimal(5,2) not null,
    foreign key (employee_id) references employees(employee_id),
    foreign key (project_id) references projects(project_id)
);

create table workreportss (
    report_id int primary key,
    employee_id int,
    report_date date not null,
    work_content text not null,
    foreign key (employee_id) references employees(employee_id)
);


-- Insert sample data into Departments table
INSERT INTO Departmentss (department_id, department_name, location) VALUES
(1, 'IT', 'Building A'),
(2, 'HR', 'Building B'),
(3, 'Finance', 'Building C');
-- Insert sample data into Employees table
INSERT INTO Employeess (employee_id, name, dob, department_id) VALUES
(1, 'Alice Williams', '1985-06-15', 1),
(2, 'Bob Johnson', '1990-03-22', 2),
(3, 'Charlie Brown', '1992-08-10', 1),
(4, 'David Smith', '1988-11-30', NULL);
-- Insert sample data into Projects table
INSERT INTO Projectss (project_id, project_name, start_date, end_date) VALUES
(1, 'Project A', '2025-01-01', '2025-12-31'),
(2, 'Project B', '2025-02-01', '2025-11-30');
-- Insert sample data into WorkReports table
INSERT INTO WorkReportss (report_id, employee_id, report_date, report_content) VALUES
(1, 1, '2025-01-31', 'Completed initial setup for Project A.'),
(2, 2, '2025-02-10', 'Completed HR review for Project A.'),
(3, 3, '2025-01-20', 'Worked on debugging and testing for Project A.'),
(4, 4, '2025-02-05', 'Worked on financial reports for Project B.'),
(5, 1, '2025-02-15', 'No report submitted.');
-- Insert sample data into Timesheets table
INSERT INTO Timesheetss (timesheet_id, employee_id, project_id, work_date, hours_worked) VALUES
(1, 1, 1, '2025-01-10', 8),
(2, 1, 2, '2025-02-12', 7),
(3, 2, 1, '2025-01-15', 6),
(4, 3, 1, '2025-01-20', 8),
(5, 4, 2, '2025-02-05', 5);


-- 1. Lấy tên nhân viên và phòng ban của họ, sắp xếp theo tên nhân viên
select e.name, d.department_name
from employees e
left join departments d on e.department_id = d.department_id
order by e.name;

-- 2. Lấy tên nhân viên và lương của các nhân viên có lương trên 5000, sắp xếp theo lương giảm dần
select name, salary
from employees
where salary > 5000
order by salary desc;

-- 3. Lấy tên nhân viên và tổng số giờ làm việc của mỗi nhân viên
select e.name, coalesce(sum(t.hours_worked), 0) as total_hours
from employees e
left join timesheets t on e.employee_id = t.employee_id
group by e.name;

-- 4. Lấy tên phòng ban và lương trung bình của các nhân viên trong phòng ban đó
select d.department_name, round(avg(e.salary), 2) as avg_salary
from employees e
join departments d on e.department_id = d.department_id
group by d.department_name;

-- 5. Lấy tên dự án và tổng số giờ làm việc cho mỗi dự án, chỉ tính những báo cáo công việc trong tháng 2 năm 2025
select p.project_name, sum(t.hours_worked) as total_hours
from timesheets t
join projects p on t.project_id = p.project_id
where extract(year from t.work_date) = 2025 and extract(month from t.work_date) = 2
group by p.project_name;

-- 6. Lấy tên nhân viên, tên dự án và tổng số giờ làm việc cho mỗi nhân viên trong từng dự án
select e.name, p.project_name, sum(t.hours_worked) as total_hours
from employees e
join timesheets t on e.employee_id = t.employee_id
join projects p on t.project_id = p.project_id
group by e.name, p.project_name;

-- 7. Lấy tên phòng ban và số lượng nhân viên trong mỗi phòng ban, chỉ lấy các phòng ban có hơn 1 nhân viên
select d.department_name, count(e.employee_id) as num_employees
from employees e
join departments d on e.department_id = d.department_id
group by d.department_name
having count(e.employee_id) > 1;

-- 8. Lấy thông tin ngày báo cáo, tên nhân viên và nội dung báo cáo của 2 báo cáo, bắt đầu từ bản ghi thứ 2, sắp xếp theo ngày báo cáo giảm dần
select wr.report_date, e.name, wr.work_content
from workreports wr
left join employees e on wr.employee_id = e.employee_id
order by wr.report_date desc
limit 2 offset 1;

-- 9. Lấy ngày báo cáo, tên nhân viên và số lượng báo cáo được gửi vào mỗi ngày, chỉ lấy báo cáo không có giá trị NULL trong nội dung và báo cáo được gửi trong khoảng thời gian từ '2025-01-01' đến '2025-02-01'
select wr.report_date, e.name, count(*) as report_count
from workreports wr
join employees e on wr.employee_id = e.employee_id
where wr.work_content is not null
and wr.report_date between '2025-01-01' and '2025-02-01'
group by wr.report_date, e.name;

-- 10. Lấy thông tin về nhân viên, dự án, giờ làm việc, và số tiền lương của nhân viên (lương = giờ làm việc * mức lương), chỉ lấy nhân viên có tổng số giờ làm việc lớn hơn 5, sắp xếp theo tổng lương
select e.name, p.project_name, sum(t.hours_worked) as total_hours, round(sum(t.hours_worked * e.salary), 2) as total_salary
from employees e
join timesheets t on e.employee_id = t.employee_id
join projects p on t.project_id = p.project_id
group by e.name, p.project_name
having sum(t.hours_worked) > 5
order by total_salary desc;

