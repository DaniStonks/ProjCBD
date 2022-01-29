USE Proj_DB_RS

GO
CREATE OR ALTER PROCEDURE spEnrollStudent(@studentNumber INT)
AS
BEGIN
	DECLARE @subjectName NVARCHAR(20)
	DECLARE @schoolID INT = (SELECT FLOOR(RAND()*(SELECT COUNT(schoolID) FROM schSchool.School)+1))
	DECLARE @schoolName VARCHAR(50) = (SELECT schoolName FROM schSchool.School
									   WHERE schoolID = @schoolID)
	DECLARE @grade1 FLOAT
	DECLARE @grade2 FLOAT
	DECLARE @grade3 FLOAT

	exec spMatricularAluno 'n','y','y',3, @schoolName, @studentNumber

    DECLARE enrollStudentCursor CURSOR READ_ONLY
    FOR
        SELECT subjectName FROM schSchool.Subject s
		JOIN schSchool.SchoolYear sy ON s.schoolYearID = sy.schoolYearID
		WHERE activeYear = 1;
	
	-- Abrir o cursor
    OPEN enrollStudentCursor

	-- Obter os valores para as variaveis
    FETCH NEXT FROM enrollStudentCursor INTO @subjectName

	-- Um loop para imprimir os resultados
    WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @grade1 = (SELECT FLOOR(RAND()*21))
			SET @grade2 = (SELECT FLOOR(RAND()*21))
			SET @grade3 = (SELECT FLOOR(RAND()*21))

			exec spInscreverAlunos @subjectName, @studentNumber, 'y', 3
			exec spLancarNotas @studentNumber, @subjectName, @grade1, @grade2, @grade3, 0, 0

			-- Obter os proximos valores para as variaveis ate chegar ao fim
			FETCH NEXT FROM enrollStudentCursor INTO @subjectName
		END
    CLOSE enrollStudentCursor
    DEALLOCATE enrollStudentCursor
END
GO

GO
CREATE OR ALTER PROCEDURE spMassCreateStudents
AS
BEGIN
	DECLARE @studentNumber INT
    DECLARE @Contador INT = 0
	DECLARE @Fim INT = (SELECT FLOOR(RAND()*(800-600+1)+600));

	WHILE (@Contador <= @Fim)
	BEGIN
		SET @studentNumber = dbo.fnMakeStudentNumber()

		INSERT INTO 
		schStudent.Student
		(
			studentNumber, studentGender, studentBDate,
			studentNetAccess, firstName, lastName,
			relationID, healthID, activityID
		)
		VALUES
		(
			@studentNumber,
			'F',
			null,
			'Y',
			'PrimeiroNome' + convert(varchar, @Contador),
			'UltimoNome' + convert(varchar, @Contador),
			null,
			null,
			null
		)

		exec spEnrollStudent @studentNumber

		SET @Contador = @Contador + 1
	END
END
GO

GO
CREATE OR ALTER PROCEDURE spCreateSchools
AS
BEGIN
	INSERT INTO 
	schSchool.School(schoolName, schoolAddress)
	VALUES
	('Escola Fernando Pessoa','address')

	INSERT INTO 
	schSchool.School(schoolName, schoolAddress)
	VALUES
	('Escola José Saramago','address')

	INSERT INTO 
	schSchool.School(schoolName, schoolAddress)
	VALUES
	('Escola Eça de Queiros','address')

	INSERT INTO 
	schSchool.School(schoolName, schoolAddress)
	VALUES
	('Escola de Bocage','address')
END
GO

GO
CREATE OR ALTER PROCEDURE spTestSubjects
AS
BEGIN
	DECLARE @currentYear INT

	SET @currentYear = dbo.fnBuscarAnoAberto()

	exec spAddSubjectToYear 'Português', @currentYear
	exec spAddSubjectToYear 'Inglês', @currentYear
	exec spAddSubjectToYear 'Frances', @currentYear
	exec spAddSubjectToYear 'Matemática', @currentYear
	exec spAddSubjectToYear 'Ciências', @currentYear
	exec spAddSubjectToYear 'Físico-química', @currentYear
	exec spAddSubjectToYear 'Educação Visual', @currentYear
	exec spAddSubjectToYear 'TIC', @currentYear
	exec spAddSubjectToYear 'Educação Física', @currentYear
END
GO

--exec spMakeTestYears

GO
CREATE OR ALTER PROCEDURE spMakeTestYears
AS
BEGIN
    DECLARE @Contador INT = 0
	DECLARE @year INT

	exec spCreateSchools

	exec spAbrirAno 1960
	SET @year = dbo.fnBuscarAnoAberto()

	exec spTestSubjects 
	
	WHILE (@Contador <= 60)
	BEGIN
		SET @year = dbo.fnBuscarAnoAberto()
		exec spMassCreateStudents

		exec spFecharAno @year
		SET @year = @year + 1
		exec spAbrirAno @year

		exec spTestSubjects
		exec spInscreverAlunosChumbados
		exec spTestGenerateFailedStudentGrades

		SET @Contador = @Contador + 1
	END
END
GO