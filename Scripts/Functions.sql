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

USE Proj_DB_RS;

GO
CREATE OR ALTER FUNCTION fnCodificaPassword (@password VARCHAR(20))
RETURNS VARCHAR(128)
BEGIN

    RETURN CONVERT(VARCHAR(128),(SELECT HASHBYTES('SHA1', @password)),2)

END
GO

/*
--Criação de funcões de auxilio no import
GO
CREATE OR ALTER FUNCTION fnMakeStudentNumber(@studentID INT)
RETURNS INT AS
BEGIN
    DECLARE @schoolYear INT

	SET @schoolYear = CONVERT(VARCHAR(10), (SELECT schoolYear FROM schSchool.SchoolYear WHERE activeYear = 1))
	SET @studentID = CONVERT(VARCHAR(10), @studentID)

	DECLARE @paddedID VARCHAR(10)
	SET @paddedID = REPLACE(STR(@studentID, 5), SPACE(1), '0')

    RETURN CONVERT(INT, CONCAT(@schoolYear, @paddedID))

END
GO
*/

GO
CREATE OR ALTER FUNCTION fnFindCoexistenceID(@schoolSupp CHAR, @familySupp CHAR, @romanticRel CHAR, @familyRel TINYINT)
RETURNS INT AS
BEGIN

	RETURN (SELECT relationID FROM schStudent.Coexistence
			WHERE @schoolSupp = schoolSupp
			AND @familySupp = familySupp
			AND @romanticRel = romanticRel
			AND @familyRel = familyRel)

END
GO

GO
CREATE OR ALTER FUNCTION fnFindActivityID(@freeTime TINYINT, @goOutFriends TINYINT, @extraActivities CHAR)
RETURNS INT AS
BEGIN

	RETURN (SELECT activityID FROM schStudent.Activity
			WHERE @freeTime = freeTime
			AND @goOutFriends = goOutFriends
			AND @extraActivities = extraActivities)

END
GO

GO
CREATE OR ALTER FUNCTION fnFindHealthID(@dailyAlc TINYINT, @weeklyAlc TINYINT, @healthStatus TINYINT)
RETURNS INT AS
BEGIN

	RETURN (SELECT healthID FROM schStudent.Health
			WHERE @dailyAlc = dailyAlc
			AND @weeklyAlc = weeklyAlc
			AND @healthStatus = healthStatus)

END
GO

GO
CREATE OR ALTER FUNCTION fnFindMotherJobID(@motherJob NVARCHAR(40))
RETURNS INT AS
BEGIN

	RETURN (SELECT motherJobID FROM schStudent.MotherJob
			WHERE @motherJob = motherJob)
END
GO

GO
CREATE OR ALTER FUNCTION fnFindFatherJobID(@fatherJob NVARCHAR(40))
RETURNS INT AS
BEGIN

	RETURN (SELECT fatherJobID FROM schStudent.FatherJob
			WHERE @fatherJob = fatherJob)
END
GO

GO
CREATE OR ALTER FUNCTION fnFindFamilySizeID(@familySize CHAR(4))
RETURNS INT AS
BEGIN

	RETURN (SELECT familySizeID FROM schStudent.FamilySize
			WHERE @familySize = familySize)
END
GO

GO
CREATE OR ALTER FUNCTION fnFindSchoolID(@schoolName VARCHAR(20), @schoolAddress NVARCHAR(70))
RETURNS INT AS
BEGIN

	RETURN (SELECT schoolID FROM schSchool.School
			WHERE @schoolName = schoolName
			AND @schoolAddress = schoolAddress)
END
GO

GO
CREATE OR ALTER FUNCTION fnFindSubjectIDByName(@subjectName NVARCHAR(20))
RETURNS INT AS
BEGIN

	RETURN (SELECT subjectID FROM schSchool.Subject s
			JOIN schSchool.SchoolYear sy ON sy.schoolYearID = s.schoolYearID
			WHERE s.subjectName = @subjectName
			AND activeYear = 1)
END
GO

GO
CREATE OR ALTER FUNCTION fnAutenticarUtilizador(@email VARCHAR(50), @password VARCHAR(128))
RETURNS BIT
BEGIN
	--verifica se o email do utilizador está na base de dados
    IF @email IN (SELECT userEmail FROM schStudent.UserAutentication)
	BEGIN
		--verifica se a password codificada coincide com a presente
		DECLARE @hashPW VARCHAR(128) = (SELECT dbo.fnCodificaPassword(@password))
		IF @hashPW IN (SELECT hashPassword FROM schStudent.UserAutentication WHERE userEmail = @email)
		BEGIN
			RETURN 1
		END
		ELSE
		BEGIN 
			RETURN 0
		END
	END
	
	RETURN 0
END
GO

GO
CREATE OR ALTER FUNCTION fnCalcularNotaFinalAluno(@studentNumber INT, @subjectID INT)
RETURNS INT AS
BEGIN
	DECLARE @finalGrade INT = (SELECT (period1Grade+period2Grade+period3Grade)/3
							   FROM schLogs.ClosedGrade g
							   JOIN schStudent.Student s ON s.studentNumber = g.studentNumber
							   JOIN schSchool.Subject sub ON sub.subjectID = g.subjectID
							   WHERE s.studentNumber = @studentNumber
							   AND g.subjectID = @subjectID)
	RETURN @finalGrade
END
GO

GO
CREATE OR ALTER FUNCTION fnMakeStudentNumber()
RETURNS INT AS
BEGIN
	DECLARE @currentYear INT = CONVERT(VARCHAR(10), (SELECT schoolYear
													 FROM [schSchool].[SchoolYear]
													 WHERE schoolYearID = (SELECT IDENT_CURRENT('schSchool.SchoolYear'))))
	DECLARE @paddedID VARCHAR(10)

	--Se não existir alunos no ano letivo corrente ira gerar o id inicial
	IF NOT EXISTS(SELECT TOP 1 * FROM schStudent.Student WHERE studentNumber LIKE CONCAT(@currentYear, '%'))
	BEGIN
		SET @paddedID = REPLACE(STR('1', 5), SPACE(1), '0')
		RETURN CONVERT(INT, CONCAT(@currentYear, @paddedID))
	END

	DECLARE @id INT = (SELECT TOP 1 studentNumber
					  FROM schStudent.Student
					  ORDER BY studentNumber DESC)

	RETURN @id + 1
END
GO