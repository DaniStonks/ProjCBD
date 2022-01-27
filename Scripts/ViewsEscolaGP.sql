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

/**************************************
 * Views de informação dos estudantes *
 **************************************/
GO
CREATE OR ALTER VIEW schStudent.view_studentsInformationGP
AS
SELECT stu.studentNumber as 'Numero Estudante', CONCAT(stu.firstName, ' ' ,stu.lastName) as 'Nome Estudante', 
		stu.studentBDate as 'Data Nascimento', stu.studentGender as 'Genero Estudante', stu.studentNetAccess as 'Acesso Internet'
FROM [schStudent].[Student] stu
JOIN schSchool.Matricula m ON stu.studentNumber = m.studentNumber
JOIN schSchool.School s ON m.schoolID = s.schoolID
WHERE schoolName = 'GP'
GO

GO
CREATE OR ALTER VIEW	
AS
SELECT CONCAT(stu.firstName, ' ' ,stu.lastName) as 'Nome Estudante', h.healthStatus as 'Estado de Saude', 
			h.dailyAlc as 'Alcool Diario', h.weeklyAlc as 'Alcool Semanal' 
FROM [schStudent].[Student] stu
JOIN [schStudent].[Health] h ON stu.healthID = h.healthID
JOIN schSchool.Matricula m ON stu.studentNumber = m.studentNumber
JOIN schSchool.School s ON m.schoolID = s.schoolID
WHERE schoolName = 'GP'
GO

GO
CREATE OR ALTER VIEW schStudent.view_studentActivitiesGP
AS
SELECT stu.studentNumber as 'Numero', CONCAT(stu.firstName, ' ' ,stu.lastName) as 'Nome Estudante', a.extraActivities as 'Atividades Extra', a.freeTime as 'Tempo Livre', 
			a.goOutFriends as 'Sair com Amigos', i.weekStudyTime as 'Tempo Estudo Semanal'
FROM [schStudent].[Student] stu
	JOIN [schStudent].[Activity] a ON stu.activityID = a.activityID
	JOIN [schSchool].[Inscrito] i ON stu.studentNumber = i.studentNumber
	JOIN schSchool.Matricula m ON stu.studentNumber = m.studentNumber
	JOIN schSchool.School s ON m.schoolID = s.schoolID
WHERE schoolName = 'GP'
GO

GO
CREATE OR ALTER VIEW schStudent.view_studentFamilyInformationGP
AS
SELECT CONCAT(stu.firstName, ' ' ,stu.lastName) as 'Nome Estudante', f.familyGuardian as 'Encarregado Educacao',
			fs.familySize as 'Tamanho da Familia', f.familyStatus as 'Estado familiar', a.address as 'Morada', a.addressType 'Tipo Morada'
FROM [schStudent].[Student] stu
	JOIN [schStudent].[Vive] v ON stu.studentNumber = v.studentNumber
	JOIN [schStudent].[Family] f ON v.familyID = f.familyID
	JOIN [schStudent].[Address] a ON v.addressID = a.addressID
	JOIN schStudent.FamilySize fs ON f.familySizeID = fs.familySizeID
	JOIN schSchool.Matricula m ON stu.studentNumber = m.studentNumber
	JOIN schSchool.School s ON m.schoolID = s.schoolID
WHERE schoolName = 'GP'
GO

/*******************************
 * Views de notas e inscrições *
 *******************************/
GO
CREATE OR ALTER VIEW schSchool.view_studentGradesGP
AS
SELECT CONCAT(stu.firstName, ' ' ,stu.lastName) as 'Nome Estudante', stu.studentNumber as 'Numero Estudante', subjectName as 'Disciplina',
period1Grade as 'Nota 1ºPeriodo', period2Grade as 'Nota 2ºPeriodo', period3Grade as 'Nota 3ºPeriodo', classFailures as 'Negativas na Disciplina'
FROM [schStudent].[Student] stu
	JOIN [schSchool].[Grade] g ON stu.studentNumber = g.studentNumber
	JOIN schSchool.Subject sub ON g.subjectID = sub.subjectID
	JOIN schSchool.Matricula m ON stu.studentNumber = m.studentNumber
	JOIN schSchool.School s ON m.schoolID = s.schoolID
WHERE schoolName = 'GP'
GO

GO
CREATE OR ALTER VIEW schSchool.view_studentInscritosGP
AS
SELECT CONCAT(stu.firstName, ' ' ,stu.lastName) as 'Nome Estudante', stu.studentNumber as 'Numero Estudante',
subjectName as 'Disciplina', weekStudyTime as 'Tempo de estudo semanal', paidClasses as 'Aulas pagas'
FROM [schStudent].[Student] stu
	JOIN schSchool.Inscrito i ON i.studentNumber = stu.studentNumber
	JOIN schSchool.Subject sub ON i.subjectID = sub.subjectID
	JOIN schSchool.Matricula m ON stu.studentNumber = m.studentNumber
	JOIN schSchool.School s ON m.schoolID = s.schoolID
WHERE schoolName = 'GP'
GO

/*********************************
 * Views de informação da escola *
 *********************************/
GO
CREATE OR ALTER VIEW schSchool.view_schoolYearInformationGP
AS
SELECT schy.schoolYear as 'Ano Letivo', schy.activeYear as 'Ano ativo?', s.subjectName as 'Disciplinas'
FROM [schSchool].[SchoolYear] schy
	JOIN [schSchool].[Subject] s ON schy.schoolYearID = s.schoolYearID
	JOIN schSchool.Contem c ON c.schoolYearID = schy.schoolYearID
	JOIN schSchool.School sc ON c.schoolID = sc.schoolID
WHERE schoolName = 'GP'
GO

/**********************
 * Views de historico *
 **********************/
GO
CREATE OR ALTER VIEW schLogs.view_logGradesGP
AS
SELECT cg.studentNumber as 'Numero de estudante', subjectName as 'Disciplina', period1Grade as 'Nota 1ºPeriodo',
period2Grade as 'Nota 2ºPeriodo', period3Grade as 'Nota 3ºPeriodo', classFailures as 'Negativas na Disciplina',
classFailures as 'Faltas'
FROM schLogs.ClosedGrade cg
	JOIN [schSchool].[Subject] s ON cg.subjectID = s.subjectID
	JOIN schSchool.Matricula m ON cg.studentNumber = m.studentNumber
	JOIN schSchool.School sc ON m.schoolID = sc.schoolID
WHERE schoolName = 'GP'
GO

GO
CREATE OR ALTER VIEW schLogs.view_logInscritosGP
AS
SELECT ci.studentNumber as 'Numero de estudante', subjectName as 'Disciplina', weekStudyTime as 'Tempo de estudo semanal',
paidClasses as 'Aulas pagas'
FROM schLogs.ClosedInscritos ci
	JOIN [schSchool].[Subject] s ON ci.subjectID = s.subjectID
	JOIN schSchool.Matricula m ON ci.studentNumber = m.studentNumber
	JOIN schSchool.School sc ON m.schoolID = sc.schoolID
WHERE schoolName = 'GP'
GO

