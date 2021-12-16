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
CREATE OR ALTER PROCEDURE spRegistarUtilizadorAutenticacao(@password VARCHAR(20), @id INT)
AS
BEGIN
    DECLARE @pwHashed VARCHAR(128) = (SELECT dbo.fnCodificaPassword(@password))
	DECLARE @userEmail VARCHAR(50) = ''
	IF @id IN (SELECT studentNumber FROM schStudent.Student) --se o id for de um estudante sera criado um email para alunos
	BEGIN
		SET @userEmail = CONCAT(@id, '@escola.pt')
	END
	IF  @id IN (SELECT familyID FROM schStudent.Family) --se o id for de um encarregado o email criado será para um encarregado
	BEGIN
		SET @userEmail = CONCAT('guardian', @id, '@escola.pt')
	END

	IF @id IN (SELECT studentNumber FROM schStudent.Acede)
		THROW 50010, 'O utilizador já está registado',1
	IF @id IN (SELECT familyID FROM schStudent.Acede)
		THROW 50010, 'O utilizador já está registado',1

	IF(@userEmail != '')-- apenas faz o registo do utilizador se tiver sido dado um id valido
	BEGIN
		INSERT INTO schStudent.UserAutentication (userEmail, hashPassword)
		VALUES (@userEmail, @pwHashed)

		DECLARE @autId INT = (SELECT autenticationID FROM schStudent.UserAutentication WHERE @userEmail = userEmail) -- vai buscar o ultimo id inserido no UserAutentication
		
		--ira inserir na tabela Acede dependendo se o id for de estudante ou encarregado
		IF (@id>200000000)
		BEGIN
			INSERT INTO schStudent.Acede (studentNumber, familyID, autenticationID)
			VALUES (@id, null, @autId)
		END
		ELSE
		BEGIN
			INSERT INTO schStudent.Acede (studentNumber, familyID, autenticationID)
			VALUES (null, @id, @autId)
		END
	END
END
GO

CREATE OR ALTER PROCEDURE spVerNotasAluno(@email VARCHAR(50), @password VARCHAR(20))
AS
BEGIN
    DECLARE @pwHashed VARCHAR(128) = (SELECT dbo.fnCodificaPassword(@password))

	IF EXISTS(SELECT userEmail, hashPassword FROM schStudent.UserAutentication
			  WHERE userEmail = @email AND hashPassword = @pwHashed)
	BEGIN
		DECLARE @userID INT
		DECLARE @autID INT = (SELECT autenticationID FROM schStudent.UserAutentication
							  WHERE userEmail = @email AND hashPassword = @pwHashed)
		IF(@email LIKE 'guardian%')
		BEGIN
			SET @userID = (SELECT familyID FROM schStudent.Acede WHERE autenticationID = @autID)

			SELECT s.studentNumber, sub.subjectName, g.period1Grade, g.period2Grade, g.period3Grade, g.classFailures, g.subjectAbsences
			FROM schStudent.Family f
			JOIN schStudent.Vive v ON f.familyID = v.familyID
			JOIN schStudent.Student s ON v.studentNumber = s.studentNumber
			JOIN schSchool.Grade g ON g.studentNumber = s.studentNumber
			JOIN schSchool.Subject sub ON g.subjectID = sub.subjectID
			WHERE f.familyID = @userID
		END
		ELSE
		BEGIN
			SET @userID = (SELECT studentNumber FROM schStudent.Acede WHERE autenticationID = @autID)
			
			SELECT s.studentNumber, sub.subjectName, g.period1Grade, g.period2Grade, g.period3Grade, g.classFailures, g.subjectAbsences 
			FROM schStudent.Student s
			JOIN schSchool.Grade g ON s.studentNumber = g.studentNumber
			JOIN schSchool.Subject sub ON g.subjectID = sub.subjectID
			WHERE s.studentNumber = @userID
		END
	END
	ELSE
		THROW 61554, 'O Utilizador não consta na base de dados', 1
END
GO

GO
CREATE OR ALTER PROCEDURE spInscreverAlunos(@subjectName NVARCHAR(20), @studentNumber INT, @paidClasses CHAR(1), @weekStudyTime TINYINT)
AS
BEGIN
    --Verificar se o aluno existe
    IF @studentNumber IN (SELECT studentNumber FROM [schStudent].[Student]) 
    BEGIN
        DECLARE @subjectID INT = (SELECT sub.subjectId FROM schSchool.Subject sub
								  JOIN schSchool.SchoolYear sy ON sub.schoolYearID = sy.schoolYearID
                                  WHERE @subjectName = sub.subjectName AND activeYear = 1)
        --Verificar se o aluno ja se encontra na disciplina
        IF @studentNumber NOT IN (SELECT studentNumber FROM [schSchool].[Inscrito]
                                  WHERE subjectId = @subjectID)
        BEGIN 
			--ira inscrever o aluno na disciplina correta e tambem ira criar um registo de avaliações correspondente
            INSERT INTO schSchool.Inscrito([weekStudyTime], [paidClasses], [studentNumber], [subjectID])
            VALUES (@weekStudyTime, @paidClasses, @studentNumber, @subjectID)

			INSERT INTO schSchool.Grade([subjectID], [studentNumber])
            VALUES (@subjectID, @studentNumber)
        END
		ELSE
			THROW 61554, 'O Aluno já se encontra inscrito na disciplina', 1
    END
	ELSE
		THROW 61555, 'O Aluno não consta na base de dados', 1
END
GO

GO
CREATE OR ALTER PROCEDURE spMudarPassword(@email VARCHAR(50), @password VARCHAR(20), @newPassword VARCHAR(128), @newPassword2 VARCHAR(128))
AS
BEGIN
	IF(@newPassword != @newPassword2)
	BEGIN
		THROW 50005, 'As passwords não coincidem', 1
	END
	IF(@newPassword = @password)
	BEGIN
		THROW 50006, 'A nova password é igual a antiga', 1
	END
    
	IF(dbo.fnAutenticarUtilizador(@email, @password) = 1)
	BEGIN
		SET @newPassword = (SELECT dbo.fnCodificaPassword(@newPassword2)) --codifica a nova password
		UPDATE schStudent.UserAutentication SET hashPassword = @newPassword WHERE userEmail = @email
	END
	ELSE
		THROW 50007, 'O dados inseridos não existem', 1
	END
GO

GO
CREATE OR ALTER PROCEDURE spCriarTokenPassword(@email VARCHAR(50))
AS
BEGIN
    --Verificar se o email inserido existe
    IF @email IN (SELECT userEmail FROM schStudent.UserAutentication) 
    BEGIN
        DECLARE @token INT = (SELECT FLOOR(RAND()*(9999999-1000000+1))+1000000) --vai gerar um token com 7 digitos
		UPDATE schStudent.UserAutentication SET tokenPassword = @token WHERE userEmail = @email
    END
	ELSE
		THROW 500010, 'O email inseridos não existe na base de dados', 1
END
GO

GO
CREATE OR ALTER PROCEDURE spMudarPasswordToken(@email VARCHAR(50), @token INT, @newPassword VARCHAR(128), @newPassword2 VARCHAR(128))
AS
BEGIN
	IF(@newPassword != @newPassword2)
	BEGIN
		THROW 50005, 'As passwords não coincidem', 1
	END
    
	IF @email IN (SELECT userEmail FROM schStudent.UserAutentication) 
	BEGIN
		IF @token IN (SELECT tokenPassword FROM schStudent.UserAutentication WHERE userEmail = @email)
		BEGIN
			SET @newPassword = (SELECT dbo.fnCodificaPassword(@newPassword2)) --codifica a nova password
			UPDATE schStudent.UserAutentication SET tokenPassword = NULL, hashPassword = @newPassword WHERE userEmail = @email
		END
		ELSE
		BEGIN
			THROW 50009, 'O token inserido não existe', 1
		END
	END
	ELSE
		THROW 50008, 'O email inserido não está registado', 1
	END
GO

GO
CREATE OR ALTER PROCEDURE spLancarNotas(@studentNumber INT, @subjectName VARCHAR(20), @grade1 FLOAT, @grade2 FLOAT, @grade3 FLOAT)
AS
BEGIN
	--Verificar se o aluno existe
    IF @studentNumber IN (SELECT studentNumber FROM [schStudent].[Student]) 
    BEGIN
        DECLARE @subjectID INT = (SELECT sub.subjectId FROM schSchool.Subject sub
								  JOIN schSchool.SchoolYear sy ON sub.schoolYearID = sy.schoolYearID
                                  WHERE @subjectName = sub.subjectName AND activeYear = 1)
        --Verificar se o aluno esta inscrito na disciplina
        IF @studentNumber IN (SELECT studentNumber FROM [schSchool].[Inscrito]
                                WHERE subjectId = @subjectID)
        BEGIN
			UPDATE schSchool.Grade SET period1Grade = @grade1, period2Grade = @grade2 , period3Grade = @grade3
			WHERE subjectID = @subjectID AND studentNumber = @studentNumber
		END
		ELSE
			THROW 61556, 'O Aluno não se encontra inscrito na disciplina', 1
    END
	ELSE
		THROW 61555, 'O Aluno não consta na base de dados', 1
END
GO
