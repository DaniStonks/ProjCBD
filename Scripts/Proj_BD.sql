/**************************************************
*	UC: Complemento de Base de Dados	2021/2022
*
*	Projeto
*	Grupo 3
*
*	(Nome)						(Nº Aluno)
*	Daniel Baptista				202001990
*	Rafael Silva				202001553
*	
*	Turma: 2ºL_EI-SW-04			Sala: F356
*
***************************************************/


/*****************************
   --- Criação da BD e ---
   ---   Primary FG    ---
*****************************/
DROP DATABASE IF exists Proj_DB_RS;

CREATE DATABASE Proj_DB_RS
ON
PRIMARY
(NAME = Proj_DB_RS,
 FILENAME='E:\SQL(Uni)\MSSQL15.MSSQLSERVER\MSSQL\DATA\Proj_DB_RS.mdf',
 --FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Proj_DB_RS.mdf',
 SIZE=10MB,
 MAXSIZE=60MB,
 FILEGROWTH=10)
LOG ON
(NAME = Proj_DB_RS_log,
 FILENAME='E:\SQL(Uni)\MSSQL15.MSSQLSERVER\MSSQL\DATA\Proj_DB_RS_log.ldf',
 --FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Proj_DB_RS_log.ldf',
 SIZE=200MB,
 MAXSIZE=600MB,
 FILEGROWTH=100);
 GO 

USE Proj_DB_RS;
GO

/*****************************
--- Criação FG secundarias ---
*****************************/
ALTER DATABASE Proj_DB_RS
ADD FILEGROUP StudentFG;

ALTER DATABASE Proj_DB_RS
ADD FILE
(NAME = Proj_DB_RS_student,
 FILENAME='E:\SQL(Uni)\MSSQL15.MSSQLSERVER\MSSQL\DATA\SchemaStudent.ndf',
 --FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\SchemaStudent.ndf',
 SIZE=100MB,
 MAXSIZE=300MB,
 FILEGROWTH=50MB)
TO FILEGROUP StudentFG;
GO

ALTER DATABASE Proj_DB_RS
ADD FILEGROUP SchoolFG;

ALTER DATABASE Proj_DB_RS
ADD FILE
(NAME = Proj_DB_RS_school,
 FILENAME='E:\SQL(Uni)\MSSQL15.MSSQLSERVER\MSSQL\DATA\SchemaSchool.ndf',
 --FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\SchemaSchool.ndf',
 SIZE=5MB,
 MAXSIZE=15MB,
 FILEGROWTH=2MB)
TO FILEGROUP SchoolFG;
GO

ALTER DATABASE Proj_DB_RS
ADD FILEGROUP IdiomFG;

ALTER DATABASE Proj_DB_RS
ADD FILE
(NAME = Proj_DB_RS_idiom,
 FILENAME='E:\SQL(Uni)\MSSQL15.MSSQLSERVER\MSSQL\DATA\SchemaIdiom.ndf',
 --FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\SchemaIdiom.ndf',
 SIZE=6MB,
 MAXSIZE=18MB,
 FILEGROWTH=3MB)
TO FILEGROUP IdiomFG;
GO

ALTER DATABASE Proj_DB_RS
ADD FILEGROUP LogsFG;

ALTER DATABASE Proj_DB_RS
ADD FILE
(NAME = Proj_DB_RS_logs,
 FILENAME='E:\SQL(Uni)\MSSQL15.MSSQLSERVER\MSSQL\DATA\SchemaLogs.ndf',
 --FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\SchemaLogs.ndf',
 SIZE=100MB,
 MAXSIZE=300MB,
 FILEGROWTH=50MB)
TO FILEGROUP LogsFG;
GO

/*****************************
  --- Criação de Schemas ---
*****************************/
CREATE SCHEMA schStudent
GO

CREATE SCHEMA schSchool
GO

CREATE SCHEMA schLogs
GO

CREATE SCHEMA schIdiom
GO
/*****************************
	--- Entidades PK ---
*****************************/
CREATE TABLE schStudent.Activity
(
  activityID INT IDENTITY(1,1),
  freeTime TINYINT CHECK (freeTime >= 1 AND freeTime <=5),
  goOutFriends TINYINT CHECK (goOutFriends >= 1 AND goOutFriends <=5),
  extraActivities CHAR(1) CHECK (extraActivities = 'Y' OR extraActivities = 'N'),
  PRIMARY KEY (activityID)
)ON StudentFG;

CREATE TABLE schStudent.Health
(
  healthID INT IDENTITY(1,1),
  dailyAlc TINYINT CHECK (dailyAlc >= 1 AND dailyAlc <=5),
  weeklyAlc TINYINT CHECK (weeklyAlc >= 1 AND weeklyAlc <=5),
  healthStatus TINYINT CHECK (healthStatus >= 1 AND healthStatus <=5),
  PRIMARY KEY (healthID)
)ON StudentFG;

CREATE TABLE schStudent.Coexistence
(
  relationID INT IDENTITY(1,1),
  schoolSupp CHAR(1) CHECK (schoolSupp = 'Y' OR schoolSupp = 'N'),
  familySupp CHAR(1) CHECK (familySupp = 'Y' OR familySupp = 'N'),
  romanticRel CHAR(1) CHECK (romanticRel = 'Y' OR romanticRel = 'N'),
  familyRel TINYINT CHECK (familyRel >= 1 AND familyRel <= 5),
  PRIMARY KEY (relationID)
)ON StudentFG;

CREATE TABLE schStudent.Address
(
  addressID INT IDENTITY(1,1),
  address VARBINARY(256),
  addressMain BIT DEFAULT(0),
  addressType CHAR(1) CHECK (addressType = 'U' OR addressType = 'R'),
  PRIMARY KEY (addressID)
)ON StudentFG;

CREATE TABLE schStudent.UserAutentication
(
  autenticationID INT IDENTITY(1,1), 
  userEmail VARCHAR(50) UNIQUE NOT NULL, 
  hashPassword VARCHAR(128) NOT NULL, 
  tokenPassword INT,
  PRIMARY KEY (autenticationID)
)ON StudentFG;

CREATE TABLE schSchool.SchoolYear
(
  schoolYearID INT IDENTITY(1,1),
  schoolYear INT UNIQUE NOT NULL,
  activeYear BIT NOT NULL,
  PRIMARY KEY (schoolYearID)
)ON SchoolFG;

CREATE TABLE schStudent.MotherJob
(
  motherJobID INT IDENTITY(1,1),
  motherJob NVARCHAR(40) NOT NULL,
  PRIMARY KEY (motherJobID)
)ON StudentFG;

CREATE TABLE schStudent.FatherJob
(
  fatherJobID INT IDENTITY(1,1),
  fatherJob NVARCHAR(40) NOT NULL,
  PRIMARY KEY (fatherJobID)
)ON StudentFG;

CREATE TABLE schStudent.FamilySize
(
  familySizeID INT IDENTITY(1,1),
  familySize VARCHAR(4) NOT NULL,
  PRIMARY KEY (familySizeID)
)ON StudentFG;

CREATE TABLE schSchool.School
(
  schoolID INT IDENTITY(1,1),
  schoolName VARCHAR(50) NOT NULL,
  schoolAddress NVARCHAR(70) NOT NULL,
  PRIMARY KEY (schoolID)
)ON SchoolFG;

CREATE TABLE schIdiom.Idiom
(
  idiomID INT IDENTITY (1,1),
  idiomName NVARCHAR(15) NOT NULL,
  PRIMARY KEY (idiomID)
)ON IdiomFG;


/*****************************
	--- Entidades FK ---
*****************************/
CREATE TABLE schStudent.Student
(
  studentNumber INT,
  studentGender CHAR(1) CHECK (studentGender = 'M' OR studentGender = 'F'),
  studentBDate DATE,
  studentNetAccess CHAR(1) CHECK (studentNetAccess = 'Y' OR studentNetAccess = 'N'),
  firstName NVARCHAR(20) NOT NULL,
  lastName NVARCHAR(20) NOT NULL,
  relationID INT,
  healthID INT,
  activityID INT,
  PRIMARY KEY (studentNumber),
)ON StudentFG;

CREATE TABLE schStudent.Family
(
  familyID INT NOT NULL IDENTITY(1,1),
  familyGuardian VARCHAR(20) NOT NULL,
  familyStatus CHAR(1) CHECK (familyStatus = 'T' OR familyStatus = 'A'),
  motherEdu TINYINT CHECK (motherEdu >= 0 AND motherEdu <= 4),
  fatherEdu TINYINT CHECK (fatherEdu >= 0 AND fatherEdu <= 4),
  fatherJobID INT NOT NULL,
  motherJobID INT NOT NULL,
  familySizeID INT NOT NULL,
  PRIMARY KEY (familyID)
)ON StudentFG;

CREATE TABLE schSchool.Grade
(
  gradeID INT IDENTITY(1,1),
  classFailures TINYINT CHECK (classFailures >= 0 AND classFailures <= 4),
  subjectAbsences TINYINT CHECK (subjectAbsences >= 0 AND subjectAbsences <= 93),
  period1Grade FLOAT CHECK (period1Grade >= 0 AND period1Grade <= 20),
  period2Grade FLOAT CHECK (period2Grade >= 0 AND period2Grade <= 20),
  period3Grade FLOAT CHECK (period3Grade >= 0 AND period3Grade <= 20),
  subjectID INT NOT NULL,
  studentNumber INT NOT NULL,
  PRIMARY KEY (gradeID),
)ON SchoolFG

CREATE TABLE schSchool.Subject
(
  subjectID INT IDENTITY(1,1),
  subjectName NVARCHAR(20) NOT NULL,
  schoolYearID INT NOT NULL,
  PRIMARY KEY (SubjectID)
)ON SchoolFG;

/*****************************
 ---- Chaves Estrangeiras ----
******************************/
ALTER TABLE schStudent.Student ADD FOREIGN KEY (relationID) 
REFERENCES schStudent.Coexistence(relationID)
ON DELETE NO ACTION
ON UPDATE CASCADE;

ALTER TABLE schStudent.Student ADD FOREIGN KEY (healthID) 
REFERENCES schStudent.Health(healthID)
ON DELETE NO ACTION
ON UPDATE CASCADE;

ALTER TABLE schStudent.Student ADD FOREIGN KEY (activityID)
REFERENCES schStudent.Activity(activityID)
ON DELETE NO ACTION
ON UPDATE CASCADE;

ALTER TABLE schSchool.Grade ADD FOREIGN KEY (subjectID) 
REFERENCES schSchool.Subject(subjectID)
ON DELETE NO ACTION
ON UPDATE CASCADE;

ALTER TABLE schSchool.Grade ADD FOREIGN KEY (studentNumber) 
REFERENCES schStudent.Student(studentNumber)
ON DELETE NO ACTION
ON UPDATE CASCADE;

ALTER TABLE schSchool.Subject ADD FOREIGN KEY (schoolYearID) 
REFERENCES schSchool.SchoolYear(schoolYearID)
ON DELETE NO ACTION
ON UPDATE CASCADE;

ALTER TABLE schStudent.Family ADD FOREIGN KEY (fatherJobID) 
REFERENCES schStudent.FatherJob(fatherJobID)
ON DELETE NO ACTION
ON UPDATE CASCADE;

ALTER TABLE schStudent.Family ADD FOREIGN KEY (motherJobID) 
REFERENCES schStudent.MotherJob(motherJobID)
ON DELETE NO ACTION
ON UPDATE CASCADE;

ALTER TABLE schStudent.Family ADD FOREIGN KEY (familySizeID) 
REFERENCES schStudent.FamilySize(familySizeID)
ON DELETE NO ACTION
ON UPDATE CASCADE;

-----
-----

/*****************************
 --- Entidades Associação ---
******************************/
CREATE TABLE schSchool.Inscrito
(
  weekStudyTime TINYINT,
  paidClasses CHAR(1) CHECK (paidClasses = 'Y' OR paidClasses = 'N'),
  studentNumber INT NOT NULL,
  subjectID INT NOT NULL,
  PRIMARY KEY (studentNumber, subjectID),
  FOREIGN KEY (studentNumber) REFERENCES schStudent.Student(studentNumber),
  FOREIGN KEY (subjectID) REFERENCES schSchool.Subject(subjectID)
)ON SchoolFG;

CREATE TABLE schStudent.Vive
(
  studentNumber INT NOT NULL,
  familyID INT NOT NULL,
  addressID INT NOT NULL,
  FOREIGN KEY (studentNumber) REFERENCES schStudent.Student(studentNumber),
  FOREIGN KEY (addressID) REFERENCES schStudent.Address(addressID),
  FOREIGN KEY(familyID) REFERENCES schStudent.Family(familyID)
)ON StudentFG;

CREATE TABLE schStudent.Acede
(
  studentNumber INT,
  familyID INT,
  autenticationID INT NOT NULL,
  FOREIGN KEY (studentNumber) REFERENCES schStudent.Student(studentNumber),
  FOREIGN KEY(autenticationID) REFERENCES schStudent.Userautentication(autenticationID),
  FOREIGN KEY(familyID) REFERENCES schStudent.Family(familyID)
)ON StudentFG;

CREATE TABLE schSchool.Matricula
(
  schoolReason VARCHAR(20),
  higherEdu CHAR(1),
  nurserySchool CHAR(1),
  schoolTravelTime TINYINT,
  schoolID INT NOT NULL,
  studentNumber INT NOT NULL,
  PRIMARY KEY (studentNumber),
  FOREIGN KEY (studentNumber) REFERENCES schStudent.Student(studentNumber),
  FOREIGN KEY(schoolID) REFERENCES schSchool.School(schoolID),
)ON SchoolFG;

CREATE TABLE schSchool.Contem
(
  schoolID INT NOT NULL,
  schoolYearID INT NOT NULL,
  PRIMARY KEY (schoolID, schoolYearID),
  FOREIGN KEY (schoolYearID) REFERENCES schSchool.SchoolYear(schoolYearID),
  FOREIGN KEY(schoolID) REFERENCES schSchool.School(schoolID),
)ON SchoolFG;

CREATE TABLE schIdiom.TranslationFamily
(
  translation VARCHAR(25) NOT NULL,
  idiomID INT NOT NULL,
  familyID INT NOT NULL,
  FOREIGN KEY (idiomID) REFERENCES schIdiom.Idiom(idiomID),
  FOREIGN KEY(familyID) REFERENCES schStudent.Family(familyID)
)ON IdiomFG

CREATE TABLE schIdiom.TranslationMJob
(
  translation VARCHAR(25) NOT NULL,
  idiomID INT NOT NULL,
  motherJobID INT NOT NULL,
  FOREIGN KEY (idiomID) REFERENCES schIdiom.Idiom(idiomID),
  FOREIGN KEY(motherJobID) REFERENCES schStudent.MotherJob(motherJobID)
)ON IdiomFG

CREATE TABLE schIdiom.TranslationFJob
(
  translation VARCHAR(25) NOT NULL,
  idiomID INT NOT NULL,
  fatherJobID INT NOT NULL,
  FOREIGN KEY (idiomID) REFERENCES schIdiom.Idiom(idiomID),
  FOREIGN KEY(fatherJobID) REFERENCES schStudent.FatherJob(fatherJobID)
)ON IdiomFG


/*****************************
	--- Entidades Log ---
*****************************/

CREATE TABLE schLogs.ClosedGrade
(
  gradeLogID INT IDENTITY (1,1),
  classFailures TINYINT CHECK (classFailures >= 0 AND classFailures <= 4),
  subjectAbsences TINYINT CHECK (subjectAbsences >= 0 AND subjectAbsences <= 93),
  period1Grade FLOAT CHECK (period1Grade >= 0 AND period1Grade <= 20),
  period2Grade FLOAT CHECK (period2Grade >= 0 AND period2Grade <= 20),
  period3Grade FLOAT CHECK (period3Grade >= 0 AND period3Grade <= 20),
  subjectID INT NOT NULL,
  studentNumber INT NOT NULL,
  logDate DATETIME NOT NULL
)ON LogsFG

CREATE TABLE schLogs.ClosedInscritos
(
  inscritosLogID INT IDENTITY (1,1),
  weekStudyTime TINYINT,
  paidClasses CHAR(1) CHECK (paidClasses = 'Y' OR paidClasses = 'N'),
  studentNumber INT NOT NULL,
  subjectID INT NOT NULL,
  logDate DATETIME NOT NULL
)ON LogsFG;

CREATE TABLE schLogs.LogsPassword
(
  userEmail VARCHAR(50),
  emailEvent CHAR(1)
)ON LogsFG;
