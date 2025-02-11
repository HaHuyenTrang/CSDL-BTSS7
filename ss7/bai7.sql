-- Tạo bảng Student
CREATE TABLE Student (
    RN INT PRIMARY KEY,
    Name VARCHAR(20),
    Age TINYINT
);

-- Tạo bảng Test
CREATE TABLE Test (
    TestID INT PRIMARY KEY,
    Name VARCHAR(20)
);

-- Tạo bảng StudentTest
CREATE TABLE StudentTest (
    RN INT,
    TestID INT,
    Date DATETIME,
    Mark FLOAT,
    PRIMARY KEY (RN, TestID, Date),
    FOREIGN KEY (RN) REFERENCES Student(RN),
    FOREIGN KEY (TestID) REFERENCES Test(TestID)
);

INSERT INTO Student (RN, Name, Age) VALUES
(1, 'Nguyen Hong Ha', 20),
(2, 'Truong Ngoc Anh', 30),
(3, 'Tuan Minh', 25),
(4, 'Dan Truong', 22);

INSERT INTO Test (TestID, Name) VALUES
(1, 'EPC'),
(2, 'DWMX'),
(3, 'SQL1'),
(4, 'SQL2');

INSERT INTO StudentTest (RN, TestID, Date, Mark) VALUES
(1, 1, '2006-07-17', 8),
(1, 2, '2006-07-18', 5),
(1, 3, '2006-07-19', 7),
(2, 1, '2006-07-17', 7),
(2, 3, '2006-07-19', 4),
(3, 3, '2006-07-19', 2),
(3, 4, '2006-07-18', 10),
(4, 4, '2006-07-18', 1);

-- 1. Thêm ràng buộc CHECK cho cột Age trong bảng Student (Giới hạn giá trị từ 15 đến 55)
ALTER TABLE Student
ADD CONSTRAINT chk_age CHECK (Age BETWEEN 15 AND 55);

-- 2. Thêm giá trị mặc định cho cột Mark trong bảng StudentTest (Mặc định là 0)
ALTER TABLE StudentTest
ALTER COLUMN Mark SET DEFAULT 0;

-- 3. Thêm khóa chính (RN, TestID) cho bảng StudentTest
ALTER TABLE StudentTest
DROP CONSTRAINT StudentTest_pkey;  -- Xóa khóa chính cũ (nếu có)
ALTER TABLE StudentTest
ADD PRIMARY KEY (RN, TestID);

-- 4. Thêm ràng buộc duy nhất (UNIQUE) cho cột Name trong bảng Test
ALTER TABLE Test
ADD CONSTRAINT unique_test_name UNIQUE (Name);

-- 5. Xóa ràng buộc duy nhất trên cột Name trong bảng Test
ALTER TABLE Test
DROP CONSTRAINT unique_test_name;


-- Cập nhật cột Name với điều kiện tuổi
UPDATE Student
SET Name = CASE 
              WHEN Age > 20 THEN 'Old ' + Name
              WHEN Age <= 20 THEN 'Young ' + Name
           END;

-- Xóa tất cả các môn học chưa có bất kỳ sinh viên nào thi
DELETE FROM Test 
WHERE TestID NOT IN (SELECT DISTINCT TestID FROM StudentTest);

--  Xóa thông tin điểm thi của sinh viên có điểm < 5
DELETE FROM StudentTest
WHERE Mark < 5;

 -- Hiển thị danh sách sinh viên với xếp hạng theo điểm trung bình
SELECT s.RN, s.Name, s.Age, AVG(st.Mark) AS AverageMark,
       RANK() OVER (ORDER BY AVG(st.Mark) DESC) AS Ranking
FROM Student s
JOIN StudentTest st ON s.RN = st.RN
GROUP BY s.RN, s.Name, s.Age
ORDER BY Ranking;


-- Hiển thị các sinh viên có tên bắt đầu bằng 'T' và điểm trung bình > 4.5
SELECT s.Name, s.Age, AVG(st.Mark) AS AverageMark
FROM Student s
JOIN StudentTest st ON s.RN = st.RN
WHERE s.Name LIKE 'T%' 
GROUP BY s.RN, s.Name, s.Age
HAVING AVG(st.Mark) > 4.5;

