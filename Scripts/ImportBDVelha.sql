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

CREATE DATABASE OldDataBase;
USE OldDataBase;

CREATE TABLE OldTable
(
  studentID INT,
  schoolName CHAR(2),
  schoolYear INT,
  studentGender CHAR(1),
  studentBDate VARCHAR(20),
  addressType CHAR(1),
  familySize CHAR(3),
  familyStatus CHAR(1),
  motherEdu TINYINT,
  fatherEdu TINYINT,
  motherJob NVARCHAR(15),
  fatherJob NVARCHAR(15),
  schoolReason VARCHAR(20),
  studentGuardian VARCHAR(10),
  schoolTravelTime TINYINT,
  weekStudyTime TINYINT,
  classFailures TINYINT,
  schoolSupp CHAR(3),
  familySupp CHAR(3),
  paidClasses CHAR(3),
  extraActivities CHAR(3),
  nurserySchool CHAR(3),
  higherEdu CHAR(3),
  studentNetAccess CHAR(3),
  romanticRel CHAR(3),
  familyRel TINYINT,
  freeTime TINYINT,
  goOutFriends TINYINT,
  dailyAlc TINYINT,
  weeklyAlc TINYINT,
  healthStatus TINYINT,
  subjectAbsences TINYINT,
  period1Grade FLOAT,
  period2Grade FLOAT,
  period3Grade FLOAT,
  disciplina VARCHAR(20)
);

BULK INSERT OldTable
FROM 'C:\Users\Daniel\Desktop\Coisas do ips\2ºAno\1ºSemestre\CBD\Projeto\OldDataset\2017 student-BD.csv'
WITH
(
	FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)

BULK INSERT OldTable
FROM 'C:\Users\Daniel\Desktop\Coisas do ips\2ºAno\1ºSemestre\CBD\Projeto\OldDataset\2017 student-CBD.csv'
WITH
(
	FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)

BULK INSERT OldTable
FROM 'C:\Users\Daniel\Desktop\Coisas do ips\2ºAno\1ºSemestre\CBD\Projeto\OldDataset\2017 student-MAT1.csv'
WITH
(
	FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)

BULK INSERT OldTable
FROM 'C:\Users\Daniel\Desktop\Coisas do ips\2ºAno\1ºSemestre\CBD\Projeto\OldDataset\2018 student-BD.csv'
WITH
(
	FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)

BULK INSERT OldTable
FROM 'C:\Users\Daniel\Desktop\Coisas do ips\2ºAno\1ºSemestre\CBD\Projeto\OldDataset\2018 student-CBD.csv'
WITH
(
	FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)

BULK INSERT OldTable
FROM 'C:\Users\Daniel\Desktop\Coisas do ips\2ºAno\1ºSemestre\CBD\Projeto\OldDataset\2018 student-MAT1.csv'
WITH
(
	FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)

BULK INSERT OldTable
FROM 'C:\Users\Daniel\Desktop\Coisas do ips\2ºAno\1ºSemestre\CBD\Projeto\OldDataset\2019 student-BD.csv'
WITH
(
	FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)

BULK INSERT OldTable
FROM 'C:\Users\Daniel\Desktop\Coisas do ips\2ºAno\1ºSemestre\CBD\Projeto\OldDataset\2019 student-CBD.csv'
WITH
(
	FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)

BULK INSERT OldTable
FROM 'C:\Users\Daniel\Desktop\Coisas do ips\2ºAno\1ºSemestre\CBD\Projeto\OldDataset\2019 student-MAT1.csv'
WITH
(
	FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)