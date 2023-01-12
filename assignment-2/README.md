Assignment - 2
=====================================

Creating the Database and tables
------------------
```
CREATE SCHEMA university;

USE university;
```
### Creating Department Table
```
CREATE TABLE department(
    department_name VARCHAR(255) PRIMARY KEY NOT NULL,
    building VARCHAR(255) NOT NULL,
    budget INT NOT NULL
);
```
### Creating Course Table
```
CREATE TABLE course(
    course_id VARCHAR(10) PRIMARY KEY NOT NULL,
    course_title VARCHAR(255) NOT NULL,
    department_name VARCHAR(255) NOT NULL,
    credits INT NOT NULL,
    FOREIGN KEY (department_name) REFERENCES department(department_name)
);
```
### Creating Section Table
```
CREATE TABLE section(
    course_id VARCHAR(10) NOT NULL,
    sec_id INT NOT NULL,
    semester VARCHAR(255) NOT NULL,
    year INT NOT NULL,
    building VARCHAR(255) NOT NULL,
    room_number INT NOT NULL,
    time_slot_id VARCHAR(255) NOT NULL,
    FOREIGN KEY (course_id) REFERENCES course(course_id)
);
```
### Creating Instructor Table
```
CREATE TABLE instructor(
    instructor_id INT PRIMARY KEY NOT NULL,
    instructor_name VARCHAR(255) NOT NULL,
    department_name VARCHAR(255) NOT NULL,
    salary INT NOT NULL,
    FOREIGN KEY (department_name) REFERENCES department(department_name)
);
```
### Creating Department Table
```
CREATE TABLE teaches(
    instructor_id INT NOT NULL,
    course_id VARCHAR(255) NOT NULL,
    sec_id INT NOT NULL,
    semester VARCHAR(255) NOT NULL,
    teaching_id INT NOT NULL,
    year INT NOT NULL,
    FOREIGN KEY (instructor_id) REFERENCES instructor(instructor_id)
);
```
### Creating Student Table
```
CREATE TABLE student(
    student_id INT PRIMARY KEY NOT NULL,
    student_name VARCHAR(255) NOT NULL,
    department_name VARCHAR(255) NOT NULL,
    total_cred INT NOT NULL,
    FOREIGN KEY (department_name) REFERENCES department(department_name)
);
```
Populating the tables 
------------------
### Department Table
```
INSERT INTO department(department_name, building, budget)
VALUES ('Biology','Watson',90000),
        ('Computer Science','Taylor',10000),
        ('Electrical Engineering','Taylor',85000),
        ('Finance','Painter',120000),
        ('History','Painter',50000),
        ('Music','Packard',80000),
        ('Physics','Watson',70000);
```
![image](https://user-images.githubusercontent.com/28438716/212067488-175197fa-9548-4ee4-990b-2177627d61f7.png)

### Course Table
```
INSERT INTO course(course_id, course_title, department_name, credits)
VALUES ('BIO-101','Intro to Biology','Biology',4),
        ('BIO-301','Genetics','Biology',4),
        ('BIO-399','Computation Biology','Biology',3),
        ('CS-101','Intro to Computer Science','Computer Science',4),
        ('CS-190','Game Design','Computer Science',4),
        ('CS-315','Robotics','Computer Science',3),
        ('CS-319','Image Processing','Computer Science',3),
        ('CS-347','Database system concepts','Computer Science',3),
        ('EE-181','Intro to Digital Systems','Electrical Engineering',3),
        ('FIN-201','Investment Banking','Finance',3),
        ('HIS-351','World History','History',3);
```
![image](https://user-images.githubusercontent.com/28438716/212067745-556ffc39-f38c-4b45-adef-a6e23ce1cab4.png)

### Section Table
```
INSERT INTO section(course_id, sec_id, semester, year, building, room_number, time_slot_id) 
VALUES ('BIO-101',1,'Summer',2009,'Painter',514,'B'),
        ('BIO-301',1,'Summer',2010,'Painter',514,'A'),
        ('CS-101',1,'Fall',2009,'Packard',101,'H'),
        ('CS-190',1,'Spring',2010,'Packard',101,'F'),
        ('CS-315',2,'Spring',2009,'Taylor',3128,'E'),
        ('CS-319',1,'Spring',2010,'Taylor',3128,'A'),
        ('CS-319',1,'Spring',2010,'Watson',120,'D'),
        ('CS-347',2,'Spring',2010,'Watson',100,'B');
```
![image](https://user-images.githubusercontent.com/28438716/212067910-be2af6ef-6385-4fba-9afe-dbfc2312f602.png)

### Instructor Table
```
INSERT INTO instructor(instructor_id, instructor_name, department_name, salary)
VALUES (10101,'Srinivasan','Computer Science',65000),
        (12121,'Wu','Finance',90000),
        (15151,'Mozart','Music',40000),
        (22222,'Einstein','Physics',95000),
        (32343,'El Said','History',60000),
        (33456,'Gold','Physics',87000),
        (45565,'Katz','Computer Science',75000),
        (145236,'Califeri','History',62000);
```
![image](https://user-images.githubusercontent.com/28438716/212068135-2c239507-088b-46b1-a6b7-bce2111d66f6.png)

### Teaches Table
```
INSERT INTO teaches(teaching_id, instructor_id, course_id, sec_id, semester, year)
VALUES (15,10101,'CS-101',1,'Fall',2009),
        (16,10101,'CS-315',1,'Spring',2010),
        (17,10101,'CS-347',1,'Fall',2009),
        (18,12121,'FIN-201',1,'Spring',2010),
        (19,145236,'HIS-351',1,'Spring',2010),
        (20,45565,'CS-101',1,'Spring',2010);
```
![image](https://user-images.githubusercontent.com/28438716/212068305-5e4df07f-5069-4d59-8098-1ae27a393627.png)

### Student Table
```
INSERT INTO student(student_id, student_name, department_name, total_cred)
VALUES (128,'Zhang','Computer Science',102),
        (12345,'Mu','Computer Science',30),
        (15637,'Jafar','Computer Science',26),
        (21478,'Feud','History',94),
        (35416,'Rangf','Computer Science',62),
        (44215,'John','History',80),
        (98214,'Ali','Computer Science',74),
        (98564,'Zill','Finance',84);
```
![image](https://user-images.githubusercontent.com/28438716/212068414-5047892b-7a27-40a4-90b8-95bb2023f7d3.png)

Assignments
-----------------------
**1. Find the names of all instructors in the History department**
```
SELECT instructor_name
FROM instructor
JOIN department
	ON department.department_name = instructor.department_name
WHERE instructor.department_name = 'History';
```
![1](https://user-images.githubusercontent.com/28438716/212069083-3b66dca4-7039-446d-886f-838fde650293.png)

**2. Find the instructor ID and department name of all instructors associated with a department with budget of greater than $95,000**
```
SELECT instructor_id, instructor.department_name
FROM instructor
JOIN department
	ON department.department_name = instructor.department_name
WHERE department.budget > 95000;
```
![2](https://user-images.githubusercontent.com/28438716/212069112-56aca415-a967-474e-a8ca-2f72b4884c84.png)

**3. Find the names of all instructors in the Comp. Sci. department together with the course titles of all the courses that the instructors teach**
```
SELECT instructor.instructor_name, course.course_title
FROM teaches
JOIN course
	ON teaches.course_id = course.course_id
JOIN instructor
	ON teaches.instructor_id = instructor.instructor_id
WHERE course.department_name = 'Computer Science';
```
![3](https://user-images.githubusercontent.com/28438716/212069129-f729a11b-6b9b-4b8c-bd78-cf4e927a7945.png)

**4. Find the names of all students who have taken the course title of “Game Design”**
```
SELECT 
    student.student_name
FROM
    student
        JOIN
    department ON student.department_name = department.department_name
        JOIN
    course ON course.department_name = department.department_name
WHERE
    course_title = 'Game Design';
```
![4](https://user-images.githubusercontent.com/28438716/212069154-cac49084-a041-4347-9faf-02f905d75bae.png)

**5. For each department, find the maximum salary of instructors in that department. You may assume that every department has at least one instructor.**
```
SELECT department_name, MAX(salary)
FROM instructor
GROUP BY department_name;
```
![5](https://user-images.githubusercontent.com/28438716/212069175-97f1b89a-0b21-4c29-bd75-1cea97e58d10.png)

**6. Find the lowest, across all departments, of the per-department maximum salary computed by the preceding query**
```
SELECT department_name, salary
FROM instructor
WHERE salary
	IN (
		SELECT MAX(salary)
		FROM instructor
		GROUP BY department_name
	)
ORDER BY salary
LIMIT 1;
```
![6](https://user-images.githubusercontent.com/28438716/212069195-1cca0857-068f-4cc5-b786-ea0ca1bcc1d0.png)



