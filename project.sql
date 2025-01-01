-- Creating the database schema
CREATE DATABASE UniversityDB;
USE UniversityDB;

-- Table creation based on ER diagram
CREATE TABLE Grades (
    GradeID INT PRIMARY KEY,
    GradeName VARCHAR(50)
);

CREATE TABLE ClassRooms (
    RoomID INT PRIMARY KEY,
    RoomName VARCHAR(50),
    Capacity INT
);

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DateOfBirth DATE,
    GradeID INT,
    FOREIGN KEY (GradeID) REFERENCES Grades(GradeID)
);

CREATE TABLE Parents (
    ParentID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    ContactInfo VARCHAR(100),
    StudentID INT,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);

CREATE TABLE Course (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    GradeID INT,
    FOREIGN KEY (GradeID) REFERENCES Grades(GradeID)
);

CREATE TABLE StudentClassroom (
    AssignmentID INT PRIMARY KEY,
    StudentID INT,
    RoomID INT,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (RoomID) REFERENCES ClassRooms(RoomID)
);

CREATE TABLE TeacherDepartment (
    TeacherDepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

CREATE TABLE TeacherType (
    TeacherTypeID INT PRIMARY KEY,
    Type VARCHAR(50)
);

CREATE TABLE Teacher (
    TeacherID INT PRIMARY KEY,
    TeacherName VARCHAR(100),
    TeacherDepartmentID INT,
    TeacherTypeID INT,
    CourseID INT,
    FOREIGN KEY (TeacherDepartmentID) REFERENCES TeacherDepartment(TeacherDepartmentID),
    FOREIGN KEY (TeacherTypeID) REFERENCES TeacherType(TeacherTypeID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

CREATE TABLE TeacherJobStartDate (
    TeacherID INT PRIMARY KEY,
    JobStartDate DATE,
    FOREIGN KEY (TeacherID) REFERENCES Teacher(TeacherID)
);

CREATE TABLE TeacherSal (
    TeacherID INT PRIMARY KEY,
    Salary DECIMAL(10,2),
    FOREIGN KEY (TeacherID) REFERENCES Teacher(TeacherID)
);

CREATE TABLE ExamType (
    TypeID INT PRIMARY KEY,
    TypeName VARCHAR(50)
);

CREATE TABLE Exam (
    ExamID INT PRIMARY KEY,
    CourseID INT,
    TeacherID INT,
    TypeID INT,
    Date DATE,
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
    FOREIGN KEY (TeacherID) REFERENCES Teacher(TeacherID),
    FOREIGN KEY (TypeID) REFERENCES ExamType(TypeID)
);

CREATE TABLE ExamResult (
    ResultID INT PRIMARY KEY,
    ExamID INT,
    StudentID INT,
    Score DECIMAL(5,2),
    FOREIGN KEY (ExamID) REFERENCES Exam(ExamID),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);

CREATE TABLE Attendance (
    AttendanceID INT PRIMARY KEY,
    StudentID INT,
    RoomID INT,
    Date DATE,
    Status VARCHAR(20),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (RoomID) REFERENCES ClassRooms(RoomID)
);

-- Sample data insertion
INSERT INTO Grades (GradeID, GradeName) VALUES (1, 'Grade 1'), (2, 'Grade 2');

INSERT INTO ClassRooms (RoomID, RoomName, Capacity) VALUES 
(1, 'Room A', 30), 
(2, 'Room B', 25);

INSERT INTO Students (StudentID, FirstName, LastName, DateOfBirth, GradeID) VALUES 
(1, 'John', 'Doe', '2010-05-15', 1),
(2, 'Jane', 'Smith', '2011-03-22', 2);

INSERT INTO Parents (ParentID, FirstName, LastName, ContactInfo, StudentID) VALUES 
(1, 'Michael', 'Doe', 'michael.doe@example.com', 1),
(2, 'Laura', 'Smith', 'laura.smith@example.com', 2);

INSERT INTO Course (CourseID, CourseName, GradeID) VALUES 
(1, 'Mathematics', 1),
(2, 'Science', 2);

INSERT INTO StudentClassroom (AssignmentID, StudentID, RoomID) VALUES 
(1, 1, 1),
(2, 2, 2);

INSERT INTO TeacherDepartment (TeacherDepartmentID, DepartmentName) VALUES 
(1, 'Mathematics Department'),
(2, 'Science Department');

INSERT INTO TeacherType (TeacherTypeID, Type) VALUES 
(1, 'Full-Time'),
(2, 'Part-Time');

INSERT INTO Teacher (TeacherID, TeacherName, TeacherDepartmentID, TeacherTypeID, CourseID) VALUES 
(1, 'Alice Johnson', 1, 1, 1),
(2, 'Bob Williams', 2, 2, 2);

INSERT INTO TeacherJobStartDate (TeacherID, JobStartDate) VALUES 
(1, '2015-08-01'),
(2, '2018-09-15');

INSERT INTO TeacherSal (TeacherID, Salary) VALUES 
(1, 50000.00),
(2, 35000.00);

INSERT INTO ExamType (TypeID, TypeName) VALUES 
(1, 'Midterm'),
(2, 'Final');

INSERT INTO Exam (ExamID, CourseID, TeacherID, TypeID, Date) VALUES 
(1, 1, 1, 1, '2024-01-15'),
(2, 2, 2, 2, '2024-06-20');

INSERT INTO ExamResult (ResultID, ExamID, StudentID, Score) VALUES 
(1, 1, 1, 85.5),
(2, 2, 2, 90.0);

INSERT INTO Attendance (AttendanceID, StudentID, RoomID, Date, Status) VALUES 
(1, 1, 1, '2024-01-10', 'Present'),
(2, 2, 2, '2024-01-10', 'Absent');

-- Sample queries
-- 1. Fetch all students with their grades
SELECT Students.StudentID, Students.FirstName, Students.LastName, Grades.GradeName
FROM Students
JOIN Grades ON Students.GradeID = Grades.GradeID;

-- 2. Fetch attendance records for a specific student
SELECT Attendance.Date, Attendance.Status, ClassRooms.RoomName
FROM Attendance
JOIN ClassRooms ON Attendance.RoomID = ClassRooms.RoomID
WHERE Attendance.StudentID = 1;

-- 3. Fetch teacher details along with their department and salary
SELECT Teacher.TeacherName, TeacherDepartment.DepartmentName, TeacherSal.Salary
FROM Teacher
JOIN TeacherDepartment ON Teacher.TeacherDepartmentID = TeacherDepartment.TeacherDepartmentID
JOIN TeacherSal ON Teacher.TeacherID = TeacherSal.TeacherID;

-- 4. Fetch exam results for a specific course
SELECT Students.FirstName, Students.LastName, ExamResult.Score
FROM ExamResult
JOIN Students ON ExamResult.StudentID = Students.StudentID
JOIN Exam ON ExamResult.ExamID = Exam.ExamID
WHERE Exam.CourseID = 1;

-- 5. List all courses along with the assigned teacher
SELECT Course.CourseName, Teacher.TeacherName
FROM Course
JOIN Teacher ON Course.CourseID = Teacher.CourseID;

-- 6. Get the average score for each exam
SELECT Exam.ExamID, AVG(ExamResult.Score) AS AverageScore
FROM Exam
JOIN ExamResult ON Exam.ExamID = ExamResult.ExamID
GROUP BY Exam.ExamID;

-- 7. Fetch all students in a specific classroom
SELECT Students.FirstName, Students.LastName, ClassRooms.RoomName
FROM StudentClassroom
JOIN Students ON StudentClassroom.StudentID = Students.StudentID
JOIN ClassRooms ON StudentClassroom.RoomID = ClassRooms.RoomID
WHERE ClassRooms.RoomID = 1;

-- 8. Get the total salary of all teachers in a specific department
SELECT TeacherDepartment.DepartmentName, SUM(TeacherSal.Salary) AS TotalSalary
FROM Teacher
JOIN TeacherDepartment ON Teacher.TeacherDepartmentID = TeacherDepartment.TeacherDepartmentID
JOIN TeacherSal ON Teacher.TeacherID = TeacherSal.TeacherID
WHERE TeacherDepartment.DepartmentName = 'Mathematics Department'
GROUP BY TeacherDepartment.DepartmentName;

-- 9. List all teachers who started their job before 2018
SELECT Teacher.TeacherName, TeacherJobStartDate.JobStartDate
FROM Teacher
JOIN TeacherJobStartDate ON Teacher.TeacherID = TeacherJobStartDate.TeacherID
WHERE TeacherJobStartDate.JobStartDate < '2018-01-01';

-- 10. Fetch all exams scheduled for a specific course along with their type and date
SELECT Exam.ExamID, ExamType.TypeName, Exam.Date
FROM Exam
JOIN ExamType ON Exam.TypeID = ExamType.TypeID
WHERE Exam.CourseID = 1;

-- 11. Fetch total number of students in each grade
SELECT Grades.GradeName, COUNT(Students.StudentID) AS TotalStudents
FROM Grades
LEFT JOIN Students ON Grades.GradeID = Students.GradeID
GROUP BY Grades.GradeName;

-- 12. Fetch all students with their assigned classrooms
SELECT Students.FirstName, Students.LastName, ClassRooms.RoomName
FROM Students
JOIN StudentClassroom ON Students.StudentID = StudentClassroom.StudentID
JOIN ClassRooms ON StudentClassroom.RoomID = ClassRooms.RoomID;

-- 13. Fetch the highest score achieved in each exam
SELECT Exam.ExamID, MAX(ExamResult.Score) AS HighestScore
FROM Exam
JOIN ExamResult ON Exam.ExamID = ExamResult.ExamID
GROUP BY Exam.ExamID;

-- 14. Fetch all exams taken by a specific student
SELECT Exam.ExamID, ExamType.TypeName, Exam.Date
FROM Exam
JOIN ExamResult ON Exam.ExamID = ExamResult.ExamID
JOIN ExamType ON Exam.TypeID = ExamType.TypeID
WHERE ExamResult.StudentID = 1;

-- 15. Fetch teacher names and their assigned courses
SELECT Teacher.TeacherName, Course.CourseName
FROM Teacher
JOIN Course ON Teacher.CourseID = Course.CourseID;

-- 16. Fetch total attendance count for each student
SELECT Students.FirstName, Students.LastName, COUNT(Attendance.AttendanceID) AS AttendanceCount
FROM Students
LEFT JOIN Attendance ON Students.StudentID = Attendance.StudentID
GROUP BY Students.StudentID;

-- 17. Fetch the department with the highest total salary
SELECT TeacherDepartment.DepartmentName, SUM(TeacherSal.Salary) AS TotalSalary
FROM Teacher
JOIN TeacherDepartment ON Teacher.TeacherDepartmentID = TeacherDepartment.TeacherDepartmentID
JOIN TeacherSal ON Teacher.TeacherID = TeacherSal.TeacherID
GROUP BY TeacherDepartment.DepartmentName
ORDER BY TotalSalary DESC
LIMIT 1;

-- 18. Fetch students who have never missed a class
SELECT Students.FirstName, Students.LastName
FROM Students
JOIN Attendance ON Students.StudentID = Attendance.StudentID
WHERE Attendance.Status = 'Present'
GROUP BY Students.StudentID
HAVING COUNT(CASE WHEN Attendance.Status = 'Absent' THEN 1 END) = 0;

-- 19. Fetch the average salary of teachers in each department
SELECT TeacherDepartment.DepartmentName, AVG(TeacherSal.Salary) AS AverageSalary
FROM Teacher
JOIN TeacherDepartment ON Teacher.TeacherDepartmentID = TeacherDepartment.TeacherDepartmentID
JOIN TeacherSal ON Teacher.TeacherID = TeacherSal.TeacherID
GROUP BY TeacherDepartment.DepartmentName;

-- 20. Fetch the list of parents with their children's names
SELECT Parents.FirstName AS ParentFirstName, Parents.LastName AS ParentLastName, Students.FirstName AS StudentFirstName, Students.LastName AS StudentLastName
FROM Parents
JOIN Students ON Parents.StudentID = Students.StudentID;

-- 21. Fetch all students who have not enrolled in any courses
SELECT Students.FirstName, Students.LastName
FROM Students
LEFT JOIN Course ON Students.GradeID = Course.GradeID
WHERE Course.CourseID IS NULL;

-- 22. Fetch the exam types with the count of exams conducted
SELECT ExamType.TypeName, COUNT(Exam.ExamID) AS TotalExams
FROM ExamType
LEFT JOIN Exam ON ExamType.TypeID = Exam.TypeID
GROUP BY ExamType.TypeName;

-- 23. Fetch all teachers with their job start date and salary
SELECT Teacher.TeacherName, TeacherJobStartDate.JobStartDate, TeacherSal.Salary
FROM Teacher
JOIN TeacherJobStartDate ON Teacher.TeacherID = TeacherJobStartDate.TeacherID
JOIN TeacherSal ON Teacher.TeacherID = TeacherSal.TeacherID;

-- 24. Fetch the list of classrooms with their capacities
SELECT ClassRooms.RoomName, ClassRooms.Capacity
FROM ClassRooms;

-- 25. Fetch the youngest student in each grade
SELECT Grades.GradeName, Students.FirstName, Students.LastName, MIN(Students.DateOfBirth) AS YoungestDOB
FROM Grades
JOIN Students ON Grades.GradeID = Students.GradeID
GROUP BY Grades.GradeName;

-- 26. Fetch the course with the most students enrolled
SELECT Course.CourseName, COUNT(Students.StudentID) AS TotalStudents
FROM Course
JOIN Students ON Course.GradeID = Students.GradeID
GROUP BY Course.CourseID
ORDER BY TotalStudents DESC
LIMIT 1;

-- 27. Fetch all students who have taken a specific exam
SELECT Students.FirstName, Students.LastName
FROM ExamResult
JOIN Students ON ExamResult.StudentID = Students.StudentID
WHERE ExamResult.ExamID = 1;

-- 28. Fetch the details of teachers who teach multiple courses
SELECT Teacher.TeacherName, COUNT(DISTINCT Teacher.CourseID) AS CourseCount
FROM Teacher
GROUP BY Teacher.TeacherID
HAVING CourseCount > 1;

-- 29. Fetch the average attendance rate for each classroom
SELECT ClassRooms.RoomName, AVG(CASE WHEN Attendance.Status = 'Present' THEN 1 ELSE 0 END) AS AttendanceRate
FROM ClassRooms
LEFT JOIN Attendance ON ClassRooms.RoomID = Attendance.RoomID
GROUP BY ClassRooms.RoomID;

-- 30. Fetch the names of all teachers who are full-time
SELECT Teacher.TeacherName
FROM Teacher
JOIN TeacherType ON Teacher.TeacherTypeID = TeacherType.TeacherTypeID
WHERE TeacherType.Type = 'Full-Time';

-- 31. Fetch the most popular grade based on the number of students
SELECT Grades.GradeName, COUNT(Students.StudentID) AS StudentCount
FROM Grades
LEFT JOIN Students ON Grades.GradeID = Students.GradeID
GROUP BY Grades.GradeID
ORDER BY StudentCount DESC
LIMIT 1;

-- 32. Fetch the parent contact information for a specific student
SELECT Parents.ContactInfo
FROM Parents
JOIN Students ON Parents.StudentID = Students.StudentID
WHERE Students.StudentID = 1;

-- 33. Fetch all students along with their grades and classroom assignments
SELECT Students.FirstName, Students.LastName, Grades.GradeName, ClassRooms.RoomName
FROM Students
JOIN Grades ON Students.GradeID = Grades.GradeID
LEFT JOIN StudentClassroom ON Students.StudentID = StudentClassroom.StudentID
LEFT JOIN ClassRooms ON StudentClassroom.RoomID = ClassRooms.RoomID;

-- 34. Fetch the total number of exams conducted by each teacher
SELECT Teacher.TeacherName, COUNT(Exam.ExamID) AS TotalExams
FROM Teacher
JOIN Exam ON Teacher.TeacherID = Exam.TeacherID
GROUP BY Teacher.TeacherID;

-- 35. Fetch the list of students with their exam scores sorted by highest to lowest
SELECT Students.FirstName, Students.LastName, ExamResult.Score
FROM ExamResult
JOIN Students ON ExamResult.StudentID = Students.StudentID
ORDER BY ExamResult.Score DESC;

-- 36. Fetch the courses that have never been taught by any teacher
SELECT Course.CourseName
FROM Course
LEFT JOIN Teacher ON Course.CourseID = Teacher.CourseID
WHERE Teacher.TeacherID IS NULL;

-- 37. Fetch the students who have scored below 50 in any exam
SELECT Students.FirstName, Students.LastName, ExamResult.Score
FROM ExamResult
JOIN Students ON ExamResult.StudentID = Students.StudentID
WHERE ExamResult.Score < 50;

-- 38. Fetch the teachers who started their jobs in the last 5 years
SELECT Teacher.TeacherName, TeacherJobStartDate.JobStartDate
FROM Teacher
JOIN TeacherJobStartDate ON Teacher.TeacherID = TeacherJobStartDate.TeacherID
WHERE YEAR(TeacherJobStartDate.JobStartDate) >= YEAR(CURDATE()) - 5;

-- 39. Fetch the highest salary in each department
SELECT TeacherDepartment.DepartmentName, MAX(TeacherSal.Salary) AS HighestSalary
FROM Teacher
JOIN TeacherDepartment ON Teacher.TeacherDepartmentID = TeacherDepartment.TeacherDepartmentID
JOIN TeacherSal ON Teacher.TeacherID = TeacherSal.TeacherID
GROUP BY TeacherDepartment.DepartmentName;

-- 40. Fetch all exams along with the course and teacher details
SELECT Exam.ExamID, Course.CourseName, Teacher.TeacherName, Exam.Date
FROM Exam
JOIN Course ON Exam.CourseID = Course.CourseID
JOIN Teacher ON Exam.TeacherID = Teacher.TeacherID;

-- 41. Fetch the details of students who share the same classroom
SELECT A.StudentID AS Student1ID, B.StudentID AS Student2ID
FROM StudentClassroom A
JOIN StudentClassroom B ON A.RoomID = B.RoomID AND A.StudentID <> B.StudentID
GROUP BY A.StudentID, B.StudentID;

-- 42. Fetch the total number of parents
SELECT COUNT(ParentID) AS TotalParents FROM Parents;


-- 43. Fetch the teacher with the earliest job start date
SELECT Teacher.TeacherName, TeacherJobStartDate.JobStartDate
FROM Teacher
JOIN TeacherJobStartDate ON Teacher.TeacherID = TeacherJobStartDate.TeacherID
ORDER BY TeacherJobStartDate.JobStartDate ASC
LIMIT 1;

-- 44. Find students with the highest score in each exam
SELECT ExamResult.ExamID, Students.FirstName, Students.LastName, MAX(ExamResult.Score) AS MaxScore
FROM ExamResult
JOIN Students ON ExamResult.StudentID = Students.StudentID
GROUP BY ExamResult.ExamID;

-- 45. List the total number of courses offered for each grade
SELECT Grades.GradeName, COUNT(Course.CourseID) AS TotalCourses
FROM Grades
JOIN Course ON Grades.GradeID = Course.GradeID
GROUP BY Grades.GradeName;

-- 46. Fetch teachers earning a salary above the average salary
SELECT Teacher.TeacherName, TeacherSal.Salary
FROM Teacher
JOIN TeacherSal ON Teacher.TeacherID = TeacherSal.TeacherID
WHERE TeacherSal.Salary > (SELECT AVG(Salary) FROM TeacherSal);

-- 47. Find the most populated classroom
SELECT ClassRooms.RoomName, ClassRooms.Capacity
FROM ClassRooms
ORDER BY ClassRooms.Capacity DESC
LIMIT 1;

-- 48. Retrieve the names of parents whose children are in Grade 10
SELECT Parents.FirstName, Parents.LastName
FROM Parents
JOIN Students ON Parents.StudentID = Students.StudentID
JOIN Grades ON Students.GradeID = Grades.GradeID
WHERE Grades.GradeName = 'Grade 10';

-- 49. List all students who are assigned to the same classroom
SELECT sc1.StudentID AS Student1, sc2.StudentID AS Student2, sc1.RoomID
FROM StudentClassroom sc1
JOIN StudentClassroom sc2 ON sc1.RoomID = sc2.RoomID AND sc1.StudentID <> sc2.StudentID
ORDER BY sc1.RoomID;

-- 50. Find all exams conducted by a specific teacher
SELECT Exam.ExamID, Exam.Date, ExamType.TypeName
FROM Exam
JOIN Teacher ON Exam.TeacherID = Teacher.TeacherID
JOIN ExamType ON Exam.TypeID = ExamType.TypeID
WHERE Teacher.TeacherName = 'John Doe';

-- 51. Calculate the total number of exams held for each course
SELECT Course.CourseName, COUNT(Exam.ExamID) AS TotalExams
FROM Course
JOIN Exam ON Course.CourseID = Exam.CourseID
GROUP BY Course.CourseName;

-- 52. Retrieve students who have never been absent
SELECT Students.FirstName, Students.LastName
FROM Students
WHERE Students.StudentID NOT IN (
  SELECT Attendance.StudentID
  FROM Attendance
  WHERE Attendance.Status = 'Absent'
);

-- 53. List all teachers who teach more than three courses
SELECT Teacher.TeacherName, COUNT(Course.CourseID) AS TotalCourses
FROM Teacher
JOIN Course ON Teacher.CourseID = Course.CourseID
GROUP BY Teacher.TeacherName
HAVING COUNT(Course.CourseID) > 3;

-- 54. Fetch the names of teachers who work in the Science department
SELECT Teacher.TeacherName
FROM Teacher
JOIN TeacherDepartment ON Teacher.TeacherDepartmentID = TeacherDepartment.TeacherDepartmentID
WHERE TeacherDepartment.DepartmentName = 'Science';

-- 55. Find the total attendance percentage for each student
SELECT Students.StudentID, Students.FirstName, Students.LastName,
  (SUM(CASE WHEN Attendance.Status = 'Present' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS AttendancePercentage
FROM Attendance
JOIN Students ON Attendance.StudentID = Students.StudentID
GROUP BY Students.StudentID;

-- 56. Retrieve the name of the student with the highest average score across all exams
SELECT Students.FirstName, Students.LastName, AVG(ExamResult.Score) AS AvgScore
FROM ExamResult
JOIN Students ON ExamResult.StudentID = Students.StudentID
GROUP BY Students.StudentID
ORDER BY AvgScore DESC
LIMIT 1;

-- 57. List all grades along with the number of students in each grade
SELECT Grades.GradeName, COUNT(Students.StudentID) AS TotalStudents
FROM Grades
JOIN Students ON Grades.GradeID = Students.GradeID
GROUP BY Grades.GradeName;

-- 58. Find the classroom with the highest attendance rate
SELECT ClassRooms.RoomName, AVG(CASE WHEN Attendance.Status = 'Present' THEN 1 ELSE 0 END) AS AttendanceRate
FROM Attendance
JOIN ClassRooms ON Attendance.RoomID = ClassRooms.RoomID
GROUP BY ClassRooms.RoomName
ORDER BY AttendanceRate DESC
LIMIT 1;

-- 59. Fetch all courses that have no students enrolled
SELECT Course.CourseName
FROM Course
LEFT JOIN Students ON Course.CourseID = Students.CourseID
WHERE Students.StudentID IS NULL;

-- 60. Retrieve all students who share the same first name as their parent
SELECT Students.FirstName, Students.LastName
FROM Students
JOIN Parents ON Students.StudentID = Parents.StudentID
WHERE Students.FirstName = Parents.FirstName;

-- 61. List all exams along with their average score
SELECT Exam.ExamID, ExamType.TypeName, AVG(ExamResult.Score) AS AverageScore
FROM Exam
JOIN ExamResult ON Exam.ExamID = ExamResult.ExamID
JOIN ExamType ON Exam.TypeID = ExamType.TypeID
GROUP BY Exam.ExamID, ExamType.TypeName;

-- 62. Find the names of students who have been absent more than 5 times
SELECT Students.FirstName, Students.LastName, COUNT(Attendance.AttendenceID) AS AbsenceCount
FROM Attendance
JOIN Students ON Attendance.StudentID = Students.StudentID
WHERE Attendance.Status = 'Absent'
GROUP BY Students.StudentID
HAVING COUNT(Attendance.AttendenceID) > 5;

-- 63. Retrieve the department with the highest number of teachers
SELECT TeacherDepartment.DepartmentName, COUNT(Teacher.TeacherID) AS TotalTeachers
FROM TeacherDepartment
JOIN Teacher ON TeacherDepartment.TeacherDepartmentID = Teacher.TeacherDepartmentID
GROUP BY TeacherDepartment.DepartmentName
ORDER BY TotalTeachers DESC
LIMIT 1;

-- 64. Find students who have scored above 90 in any exam
SELECT DISTINCT Students.FirstName, Students.LastName
FROM Students
JOIN ExamResult ON Students.StudentID = ExamResult.StudentID
WHERE ExamResult.Score > 90;

-- 65. Fetch the total salary expense for each department
SELECT TeacherDepartment.DepartmentName, SUM(TeacherSal.Salary) AS TotalSalaryExpense
FROM TeacherDepartment
JOIN Teacher ON TeacherDepartment.TeacherDepartmentID = Teacher.TeacherDepartmentID
JOIN TeacherSal ON Teacher.TeacherID = TeacherSal.TeacherID
GROUP BY TeacherDepartment.DepartmentName;

-- 66. List all courses that are taught by more than one teacher
SELECT Course.CourseName, COUNT(DISTINCT Teacher.TeacherID) AS TotalTeachers
FROM Course
JOIN Teacher ON Course.CourseID = Teacher.CourseID
GROUP BY Course.CourseName
HAVING COUNT(DISTINCT Teacher.TeacherID) > 1;

-- 67. Retrieve the name of the teacher with the highest salary
SELECT Teacher.TeacherName, TeacherSal.Salary
FROM Teacher
JOIN TeacherSal ON Teacher.TeacherID = TeacherSal.TeacherID
ORDER BY TeacherSal.Salary DESC
LIMIT 1;

-- 68. Fetch the names of all students along with their grades and courses
SELECT Students.FirstName, Students.LastName, Grades.GradeName, Course.CourseName
FROM Students
JOIN Grades ON Students.GradeID = Grades.GradeID
JOIN Course ON Students.CourseID = Course.CourseID;

-- 69. Find the total number of parents associated with each grade
SELECT Grades.GradeName, COUNT(DISTINCT Parents.ParentID) AS TotalParents
FROM Grades
JOIN Students ON Grades.GradeID = Students.GradeID
JOIN Parents ON Students.StudentID = Parents.StudentID
GROUP BY Grades.GradeName;

-- 70. Retrieve the attendance percentage for each classroom
SELECT ClassRooms.RoomName, (SUM(CASE WHEN Attendance.Status = 'Present' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS AttendancePercentage
FROM Attendance
JOIN ClassRooms ON Attendance.RoomID = ClassRooms.RoomID
GROUP BY ClassRooms.RoomName;



-- 71. List all exams taken by students from a specific grade (e.g., Grade 10)
SELECT Exams.ExamID, Exams.Date, ExamType.TypeName
FROM Exams
JOIN ExamResult ON Exams.ExamID = ExamResult.ExamID
JOIN Students ON ExamResult.StudentID = Students.StudentID
JOIN Grades ON Students.GradeID = Grades.GradeID
WHERE Grades.GradeName = 'Grade 10';

-- 72. Find students who have taken more than 5 exams
SELECT Students.FirstName, Students.LastName, COUNT(ExamResult.ExamID) AS ExamCount
FROM ExamResult
JOIN Students ON ExamResult.StudentID = Students.StudentID
GROUP BY Students.StudentID
HAVING COUNT(ExamResult.ExamID) > 5;

-- 73. Fetch details of courses that belong to a specific department
SELECT Course.CourseName, TeacherDepartment.DepartmentName
FROM Course
JOIN Teacher ON Course.CourseID = Teacher.CourseID
JOIN TeacherDepartment ON Teacher.TeacherDepartmentID = TeacherDepartment.TeacherDepartmentID
WHERE TeacherDepartment.DepartmentName = 'Mathematics';

-- 74. List the average salary of teachers by department
SELECT TeacherDepartment.DepartmentName, AVG(TeacherSal.Salary) AS AvgSalary
FROM TeacherDepartment
JOIN Teacher ON Teacher.TeacherDepartmentID = TeacherDepartment.TeacherDepartmentID
JOIN TeacherSal ON Teacher.TeacherID = TeacherSal.TeacherID
GROUP BY TeacherDepartment.DepartmentName;

-- 75. Retrieve the names of teachers who have been working for more than 10 years
SELECT Teacher.TeacherName, TeacherJobStartDate.JobStartDate
FROM Teacher
JOIN TeacherJobStartDate ON Teacher.TeacherID = TeacherJobStartDate.TeacherID
WHERE TIMESTAMPDIFF(YEAR, TeacherJobStartDate.JobStartDate, CURDATE()) > 10;

-- 76. Fetch the details of classrooms that have hosted more than 100 students cumulatively
SELECT ClassRooms.RoomName, COUNT(StudentClassroom.StudentID) AS TotalStudents
FROM ClassRooms
JOIN StudentClassroom ON ClassRooms.RoomID = StudentClassroom.RoomID
GROUP BY ClassRooms.RoomName
HAVING COUNT(StudentClassroom.StudentID) > 100;

-- 77. Find teachers who are assigned to teach multiple grades
SELECT DISTINCT Teacher.TeacherName
FROM Teacher
JOIN Course ON Teacher.CourseID = Course.CourseID
JOIN Grades ON Course.GradeID = Grades.GradeID
GROUP BY Teacher.TeacherID
HAVING COUNT(DISTINCT Grades.GradeID) > 1;

-- 78. Retrieve students who have never enrolled in a course
SELECT Students.FirstName, Students.LastName
FROM Students
LEFT JOIN Course ON Students.CourseID = Course.CourseID
WHERE Students.CourseID IS NULL;

-- 79. List the details of the highest-scoring student for each course
SELECT Course.CourseName, Students.FirstName, Students.LastName, MAX(ExamResult.Score) AS HighestScore
FROM Course
JOIN Exams ON Course.CourseID = Exams.CourseID
JOIN ExamResult ON Exams.ExamID = ExamResult.ExamID
JOIN Students ON ExamResult.StudentID = Students.StudentID
GROUP BY Course.CourseID;

-- 80. Fetch details of parents whose children scored below 50 in any exam
SELECT Parents.FirstName, Parents.LastName, Students.FirstName AS ChildName, ExamResult.Score
FROM Parents
JOIN Students ON Parents.StudentID = Students.StudentID
JOIN ExamResult ON Students.StudentID = ExamResult.StudentID
WHERE ExamResult.Score < 50;
