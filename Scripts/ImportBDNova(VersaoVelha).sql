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
--UPDATE schSchool.SchoolYear SET activeYear = 1 WHERE schoolYear = 2019
USE Proj_DB_RS;
/*****************************
   --- Importação dados ---
     ---   de 2017    ---
*****************************/

--Criação de uma tabela temporaria
CREATE TABLE Temp
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
  disciplina NVARCHAR(20)
);

--Carregar os dados para a tabela temporaria
BULK INSERT dbo.Temp
FROM 'C:\Users\Daniel\Desktop\Coisas do ips\2ºAno\1ºSemestre\CBD\Projeto\OldDataset\2017 student-BD.csv'
WITH
(
	FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)

INSERT INTO schStudent.Address
SELECT 'dummyAddress',0,[addressType]
FROM dbo.Temp;

INSERT INTO schStudent.MotherJob
SELECT DISTINCT t.motherJob
FROM Temp t
LEFT JOIN schStudent.MotherJob ON t.studentID != motherJobID
WHERE motherJobID IS NULL;

INSERT INTO schStudent.FatherJob
SELECT DISTINCT t.fatherJob
FROM Temp t
LEFT JOIN schStudent.FatherJob ON t.studentID != fatherJobID
WHERE fatherJobID IS NULL;

INSERT INTO schStudent.FamilySize
SELECT DISTINCT t.familySize
FROM Temp t
LEFT JOIN schStudent.FamilySize ON t.studentID != familySizeID
WHERE familySizeID IS NULL;

INSERT INTO schStudent.Family
SELECT [studentGuardian], [familyStatus],
	   [motherEdu], [fatherEdu],
	   dbo.fnFindFatherJobID(fatherJob),
	   dbo.fnFindMotherJobID(motherJob),
	   dbo.fnFindFamilySizeID(familySize)
FROM dbo.Temp;

BULK INSERT dbo.Temp
FROM 'C:\Users\Daniel\Desktop\Coisas do ips\2ºAno\1ºSemestre\CBD\Projeto\OldDataset\2017 student-CBD.csv'
WITH
(
	FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)
BULK INSERT dbo.Temp
FROM 'C:\Users\Daniel\Desktop\Coisas do ips\2ºAno\1ºSemestre\CBD\Projeto\OldDataset\2017 student-MAT1.csv'
WITH
(
	FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)

--Alterar os dados de forma a poder inseri-los mais facilmente na base de dados
UPDATE Temp
SET schoolSupp = 'Y'
WHERE schoolSupp= 'yes';
UPDATE Temp
SET schoolSupp = 'N'
WHERE schoolSupp = 'no';

UPDATE Temp
SET familySupp = 'Y'
WHERE familySupp = 'yes';
UPDATE Temp
SET familySupp = 'N'
WHERE familySupp = 'no';

UPDATE Temp
SET paidClasses = 'Y'
WHERE paidClasses = 'yes';
UPDATE Temp
SET paidClasses = 'N'
WHERE paidClasses = 'no';

UPDATE Temp
SET extraActivities = 'Y'
WHERE extraActivities = 'yes';
UPDATE Temp
SET extraActivities = 'N'
WHERE extraActivities = 'no';

UPDATE Temp
SET nurserySchool = 'Y'
WHERE nurserySchool = 'yes';
UPDATE Temp
SET nurserySchool = 'N'
WHERE nurserySchool = 'no';

UPDATE Temp
SET higherEdu = 'Y'
WHERE higherEdu = 'yes';
UPDATE Temp
SET higherEdu = 'N'
WHERE higherEdu = 'no';

UPDATE Temp
SET studentNetAccess = 'Y'
WHERE studentNetAccess = 'yes';
UPDATE Temp
SET studentNetAccess = 'N'
WHERE studentNetAccess = 'no';

UPDATE Temp
SET romanticRel = 'Y'
WHERE romanticRel = 'yes';
UPDATE Temp
SET romanticRel = 'N'
WHERE romanticRel = 'no';

--Inserir os dados nas tabelas respectivas
INSERT INTO [schStudent].[Activity]
SELECT DISTINCT [freeTime], [goOutFriends], [extraActivities]
FROM Temp;

INSERT INTO schStudent.Health
SELECT DISTINCT [dailyAlc],[weeklyAlc],[healthStatus]
FROM Temp;

INSERT INTO schStudent.Coexistence
SELECT DISTINCT [schoolSupp],[familySupp],[romanticRel],[familyRel]
FROM Temp;

INSERT INTO schSchool.SchoolYear
SELECT DISTINCT [schoolYear],1
FROM dbo.Temp;

INSERT INTO schSchool.School
SELECT DISTINCT [schoolName], 'schoolAddress'
FROM dbo.Temp;

INSERT INTO schSchool.Tem
SELECT DISTINCT schoolID, schoolYearID
FROM schSchool.SchoolYear, schSchool.School;

INSERT INTO schStudent.Student
SELECT DISTINCT dbo.fnMakeStudentNumber(studentID), [studentGender],
	   CONVERT(DATE,[studentBDate],103), [studentNetAccess],
	   'dummyFirstName', 'dummyLastName',
	   dbo.fnFindCoexistenceID([schoolSupp], [familySupp], [romanticRel], [familyRel]),
	   dbo.fnFindHealthID([dailyAlc], [weeklyAlc], [healthStatus]),             --estas 3 funções vao usar os dados lidos para buscar os IDs correspondentes nas suas tabelas respectivas
	   dbo.fnFindActivityID([freeTime], [goOutFriends], [extraActivities])
FROM dbo.Temp;

INSERT INTO schSchool.Matricula
SELECT DISTINCT [schoolReason], [higherEdu], [nurserySchool], [schoolTravelTime], dbo.fnFindSchoolID(schoolName, 'schoolAddress'), dbo.fnMakeStudentNumber(studentID)
FROM dbo.Temp;

INSERT INTO schSchool.Subject
SELECT DISTINCT disciplina, schoolYearID
FROM dbo.Temp, schSchool.SchoolYear
WHERE activeYear = 1;

INSERT INTO schSchool.Inscrito
SELECT DISTINCT [weekStudyTime], paidClasses, dbo.fnMakeStudentNumber(studentID), subjectID
FROM dbo.Temp, schSchool.Subject
WHERE subjectID IN (SELECT subjectID FROM schSchool.Subject);

INSERT INTO schSchool.Grade
SELECT [classFailures], [subjectAbsences], [period1Grade], [period2Grade],
	   [period3Grade], subjectID, dbo.fnMakeStudentNumber(studentID)
FROM dbo.Temp
JOIN schSchool.Subject ON disciplina = subjectName;

INSERT INTO schStudent.Vive
SELECT DISTINCT dbo.fnMakeStudentNumber(studentID), studentID, studentID
FROM dbo.Temp;

DROP TABLE Temp;

/*****************************
   --- Importação dados ---
     ---   de 2018    ---
*****************************/

--Criação de uma tabela temporaria
CREATE TABLE Temp
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
  disciplina NVARCHAR(20)
);

--Carregar os dados para a tabela temporaria
BULK INSERT dbo.Temp
FROM 'C:\Users\Daniel\Desktop\Coisas do ips\2ºAno\1ºSemestre\CBD\Projeto\OldDataset\2018 student-BD.csv'
WITH
(
	FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)

INSERT INTO schStudent.Address
SELECT 'dummyAddress',0,[addressType]
FROM dbo.Temp;

INSERT INTO schStudent.MotherJob
SELECT DISTINCT t.motherJob
FROM Temp t
LEFT JOIN schStudent.MotherJob ON t.studentID != motherJobID
WHERE motherJobID IS NULL;

INSERT INTO schStudent.FatherJob
SELECT DISTINCT t.fatherJob
FROM Temp t
LEFT JOIN schStudent.FatherJob ON t.studentID != fatherJobID
WHERE fatherJobID IS NULL;

INSERT INTO schStudent.FamilySize
SELECT DISTINCT t.familySize
FROM Temp t
LEFT JOIN schStudent.FamilySize ON t.studentID != familySizeID
WHERE familySizeID IS NULL;

INSERT INTO schStudent.Family
SELECT [studentGuardian], [familyStatus],
	   [motherEdu], [fatherEdu],
	   dbo.fnFindFatherJobID(fatherJob),
	   dbo.fnFindMotherJobID(motherJob),
	   dbo.fnFindFamilySizeID(familySize)
FROM dbo.Temp;

BULK INSERT dbo.Temp
FROM 'C:\Users\Daniel\Desktop\Coisas do ips\2ºAno\1ºSemestre\CBD\Projeto\OldDataset\2018 student-CBD.csv'
WITH
(
	FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)
BULK INSERT dbo.Temp
FROM 'C:\Users\Daniel\Desktop\Coisas do ips\2ºAno\1ºSemestre\CBD\Projeto\OldDataset\2018 student-MAT1.csv'
WITH
(
	FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)

--Alterar os dados de forma a poder inseri-los mais facilmente na base de dados
UPDATE Temp
SET schoolSupp = 'Y'
WHERE schoolSupp= 'yes';
UPDATE Temp
SET schoolSupp = 'N'
WHERE schoolSupp = 'no';

UPDATE Temp
SET familySupp = 'Y'
WHERE familySupp = 'yes';
UPDATE Temp
SET familySupp = 'N'
WHERE familySupp = 'no';

UPDATE Temp
SET paidClasses = 'Y'
WHERE paidClasses = 'yes';
UPDATE Temp
SET paidClasses = 'N'
WHERE paidClasses = 'no';

UPDATE Temp
SET extraActivities = 'Y'
WHERE extraActivities = 'yes';
UPDATE Temp
SET extraActivities = 'N'
WHERE extraActivities = 'no';

UPDATE Temp
SET nurserySchool = 'Y'
WHERE nurserySchool = 'yes';
UPDATE Temp
SET nurserySchool = 'N'
WHERE nurserySchool = 'no';

UPDATE Temp
SET higherEdu = 'Y'
WHERE higherEdu = 'yes';
UPDATE Temp
SET higherEdu = 'N'
WHERE higherEdu = 'no';

UPDATE Temp
SET studentNetAccess = 'Y'
WHERE studentNetAccess = 'yes';
UPDATE Temp
SET studentNetAccess = 'N'
WHERE studentNetAccess = 'no';

UPDATE Temp
SET romanticRel = 'Y'
WHERE romanticRel = 'yes';
UPDATE Temp
SET romanticRel = 'N'
WHERE romanticRel = 'no';

--Inserir os dados nas tabelas respectivas
INSERT INTO [schStudent].[Activity]
SELECT DISTINCT t.[freeTime], t.[goOutFriends], t.[extraActivities]
FROM Temp t
LEFT JOIN schStudent.Activity ON t.studentID != activityID
WHERE activityID IS NULL;

INSERT INTO schStudent.Health
SELECT DISTINCT t.[dailyAlc], t.[weeklyAlc], t.[healthStatus]
FROM Temp t
LEFT JOIN schStudent.Health ON t.studentID != healthID
WHERE healthID IS NULL;

INSERT INTO schStudent.Coexistence
SELECT DISTINCT t.[schoolSupp], t.[familySupp], t.[romanticRel], t.[familyRel]
FROM Temp t
LEFT JOIN schStudent.Coexistence ON t.studentID != relationID
WHERE relationID IS NULL;

INSERT INTO schSchool.SchoolYear
SELECT DISTINCT [schoolYear],0
FROM dbo.Temp;

INSERT INTO schSchool.Tem
SELECT DISTINCT schoolID, schoolYearID
FROM schSchool.SchoolYear, schSchool.School
WHERE activeYear = 1;

INSERT INTO schStudent.Student
SELECT DISTINCT dbo.fnMakeStudentNumber(studentID), [studentGender],
	   CONVERT(DATE,[studentBDate],103), [studentNetAccess],
	   'dummyFirstName', 'dummyLastName',
	   dbo.fnFindCoexistenceID([schoolSupp], [familySupp], [romanticRel], [familyRel]),
	   dbo.fnFindHealthID([dailyAlc], [weeklyAlc], [healthStatus]),             --estas 3 funções vao usar os dados lidos para buscar os IDs correspondentes nas suas tabelas respectivas
	   dbo.fnFindActivityID([freeTime], [goOutFriends], [extraActivities])
FROM dbo.Temp;

INSERT INTO schSchool.Matricula
SELECT DISTINCT [schoolReason], [higherEdu], [nurserySchool], [schoolTravelTime], dbo.fnFindSchoolID(schoolName, 'schoolAddress'), dbo.fnMakeStudentNumber(studentID)
FROM dbo.Temp;

INSERT INTO schSchool.Subject
SELECT DISTINCT disciplina, schoolYearID
FROM dbo.Temp, schSchool.SchoolYear
WHERE activeYear = 1;

INSERT INTO schSchool.Inscrito
SELECT DISTINCT [weekStudyTime], paidClasses, dbo.fnMakeStudentNumber(studentID), subjectID
FROM dbo.Temp, schSchool.Subject s
JOIN schSchool.SchoolYear sy ON s.schoolYearID = sy.schoolYearID
WHERE activeYear = 1;

INSERT INTO schSchool.Grade
SELECT [classFailures], [subjectAbsences], [period1Grade], [period2Grade],
	   [period3Grade], s.subjectID, dbo.fnMakeStudentNumber(studentID)
FROM dbo.Temp
JOIN schSchool.Subject s ON disciplina = subjectName
JOIN schSchool.SchoolYear sy ON s.schoolYearID = sy.schoolYearID
WHERE activeYear = 1;

INSERT INTO schStudent.Vive
SELECT DISTINCT dbo.fnMakeStudentNumber(studentID), studentID, studentID
FROM dbo.Temp;

DROP TABLE Temp;

/*****************************
   --- Importação dados ---
     ---   de 2019    ---
*****************************/

--Criação de uma tabela temporaria
CREATE TABLE Temp
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
  disciplina NVARCHAR(20)
);

--Carregar os dados para a tabela temporaria
BULK INSERT dbo.Temp
FROM 'C:\Users\Daniel\Desktop\Coisas do ips\2ºAno\1ºSemestre\CBD\Projeto\OldDataset\2019 student-BD.csv'
WITH
(
	FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)

INSERT INTO schStudent.Address
SELECT 'dummyAddress',0,[addressType]
FROM dbo.Temp;

INSERT INTO schStudent.MotherJob
SELECT DISTINCT t.motherJob
FROM Temp t
LEFT JOIN schStudent.MotherJob ON t.studentID != motherJobID
WHERE motherJobID IS NULL;

INSERT INTO schStudent.FatherJob
SELECT DISTINCT t.fatherJob
FROM Temp t
LEFT JOIN schStudent.FatherJob ON t.studentID != fatherJobID
WHERE fatherJobID IS NULL;

INSERT INTO schStudent.FamilySize
SELECT DISTINCT t.familySize
FROM Temp t
LEFT JOIN schStudent.FamilySize ON t.studentID != familySizeID
WHERE familySizeID IS NULL;

INSERT INTO schStudent.Family
SELECT [studentGuardian], [familyStatus],
	   [motherEdu], [fatherEdu],
	   dbo.fnFindFatherJobID(fatherJob),
	   dbo.fnFindMotherJobID(motherJob),
	   dbo.fnFindFamilySizeID(familySize)
FROM dbo.Temp;

BULK INSERT dbo.Temp
FROM 'C:\Users\Daniel\Desktop\Coisas do ips\2ºAno\1ºSemestre\CBD\Projeto\OldDataset\2019 student-CBD.csv'
WITH
(
	FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)
BULK INSERT dbo.Temp
FROM 'C:\Users\Daniel\Desktop\Coisas do ips\2ºAno\1ºSemestre\CBD\Projeto\OldDataset\2019 student-MAT1.csv'
WITH
(
	FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)

--Alterar os dados de forma a poder inseri-los mais facilmente na base de dados
UPDATE Temp
SET schoolSupp = 'Y'
WHERE schoolSupp= 'yes';
UPDATE Temp
SET schoolSupp = 'N'
WHERE schoolSupp = 'no';

UPDATE Temp
SET familySupp = 'Y'
WHERE familySupp = 'yes';
UPDATE Temp
SET familySupp = 'N'
WHERE familySupp = 'no';

UPDATE Temp
SET paidClasses = 'Y'
WHERE paidClasses = 'yes';
UPDATE Temp
SET paidClasses = 'N'
WHERE paidClasses = 'no';

UPDATE Temp
SET extraActivities = 'Y'
WHERE extraActivities = 'yes';
UPDATE Temp
SET extraActivities = 'N'
WHERE extraActivities = 'no';

UPDATE Temp
SET nurserySchool = 'Y'
WHERE nurserySchool = 'yes';
UPDATE Temp
SET nurserySchool = 'N'
WHERE nurserySchool = 'no';

UPDATE Temp
SET higherEdu = 'Y'
WHERE higherEdu = 'yes';
UPDATE Temp
SET higherEdu = 'N'
WHERE higherEdu = 'no';

UPDATE Temp
SET studentNetAccess = 'Y'
WHERE studentNetAccess = 'yes';
UPDATE Temp
SET studentNetAccess = 'N'
WHERE studentNetAccess = 'no';

UPDATE Temp
SET romanticRel = 'Y'
WHERE romanticRel = 'yes';
UPDATE Temp
SET romanticRel = 'N'
WHERE romanticRel = 'no';

--Inserir os dados nas tabelas respectivas
INSERT INTO [schStudent].[Activity]
SELECT DISTINCT t.[freeTime], t.[goOutFriends], t.[extraActivities]
FROM Temp t
LEFT JOIN schStudent.Activity ON t.studentID != activityID
WHERE activityID IS NULL;

INSERT INTO schStudent.Health
SELECT DISTINCT t.[dailyAlc], t.[weeklyAlc], t.[healthStatus]
FROM Temp t
LEFT JOIN schStudent.Health ON t.studentID != healthID
WHERE healthID IS NULL;

INSERT INTO schStudent.Coexistence
SELECT DISTINCT t.[schoolSupp], t.[familySupp], t.[romanticRel], t.[familyRel]
FROM Temp t
LEFT JOIN schStudent.Coexistence ON t.studentID != relationID
WHERE relationID IS NULL;

INSERT INTO schSchool.SchoolYear
SELECT DISTINCT [schoolYear],0
FROM dbo.Temp;

INSERT INTO schSchool.Tem
SELECT DISTINCT schoolID, schoolYearID
FROM schSchool.SchoolYear, schSchool.School
WHERE activeYear = 1;

INSERT INTO schStudent.Student
SELECT DISTINCT dbo.fnMakeStudentNumber(studentID), [studentGender],
	   CONVERT(DATE,[studentBDate],103), [studentNetAccess],
	   'dummyFirstName', 'dummyLastName',
	   dbo.fnFindCoexistenceID([schoolSupp], [familySupp], [romanticRel], [familyRel]),
	   dbo.fnFindHealthID([dailyAlc], [weeklyAlc], [healthStatus]),             --estas 3 funções vao usar os dados lidos para buscar os IDs correspondentes nas suas tabelas respectivas
	   dbo.fnFindActivityID([freeTime], [goOutFriends], [extraActivities])
FROM dbo.Temp;

INSERT INTO schSchool.Matricula
SELECT DISTINCT [schoolReason], [higherEdu], [nurserySchool], [schoolTravelTime], dbo.fnFindSchoolID(schoolName, 'schoolAddress'), dbo.fnMakeStudentNumber(studentID)
FROM dbo.Temp;

INSERT INTO schSchool.Subject
SELECT DISTINCT disciplina, schoolYearID
FROM dbo.Temp, schSchool.SchoolYear
WHERE activeYear = 1;

INSERT INTO schSchool.Inscrito
SELECT DISTINCT [weekStudyTime], paidClasses, dbo.fnMakeStudentNumber(studentID), subjectID
FROM dbo.Temp, schSchool.Subject s
JOIN schSchool.SchoolYear sy ON s.schoolYearID = sy.schoolYearID
WHERE activeYear = 1;

INSERT INTO schSchool.Grade
SELECT [classFailures], [subjectAbsences], [period1Grade], [period2Grade],
	   [period3Grade], s.subjectID, dbo.fnMakeStudentNumber(studentID)
FROM dbo.Temp
JOIN schSchool.Subject s ON disciplina = subjectName
JOIN schSchool.SchoolYear sy ON s.schoolYearID = sy.schoolYearID
WHERE activeYear = 1;

INSERT INTO schStudent.Vive
SELECT DISTINCT dbo.fnMakeStudentNumber(studentID), studentID, studentID
FROM dbo.Temp;

DROP TABLE Temp;