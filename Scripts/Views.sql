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
CREATE OR ALTER VIEW view_studentsInformation
AS
SELECT stu.studentNumber as 'Numero Estudante', CONCAT(stu.firstName, ' ' ,stu.lastName) as 'Nome Estudante', 
		stu.studentBDate as 'Data Nascimento', stu.studentGender as 'Genero Estudante', stu.studentNetAccess as 'Acesso Internet'
FROM [schStudent].[Student] stu
GO

GO
CREATE OR ALTER VIEW view_studentsHealthStatus
AS
SELECT CONCAT(stu.firstName, ' ' ,stu.lastName) as 'Nome Estudante', h.healthStatus as 'Estado de Saude', 
			h.dailyAlc as 'Alcool Diario', h.weeklyAlc as 'Alcool Semanal' 
FROM [schStudent].[Student] stu
	JOIN [schStudent].[Health] h ON stu.healthID = h.healthID
GO

GO
CREATE OR ALTER VIEW view_studentActivities
AS
SELECT CONCAT(stu.firstName, ' ' ,stu.lastName) as 'Nome Estudante', a.extraActivities as 'Atividades Extra', a.freeTime as 'Tempo Livre', 
			a.goOutFriends as 'Sair com Amigos', i.weekStudyTime as 'Tempo Estudo Semanal'
FROM [schStudent].[Student] stu
	JOIN [schStudent].[Activity] a ON stu.activityID = a.activityID
	JOIN [schSchool].[Inscrito] i ON stu.studentNumber = i.studentNumber
GO

GO
CREATE OR ALTER VIEW view_studentGrades
AS
SELECT CONCAT(stu.firstName, ' ' ,stu.lastName) as 'Nome Estudante', g.period1Grade as 'Nota 1ºPeriodo', 
			g.period2Grade as 'Nota 2ºPeriodo', g.period3Grade as 'Nota 3ºPeriodo', g.classFailures as 'Negativas na Disciplina'
FROM [schStudent].[Student] stu
	JOIN [schSchool].[Grade] g ON stu.studentNumber = g.studentNumber
GO

GO
CREATE OR ALTER VIEW view_studentFamilyInformation
AS
SELECT CONCAT(stu.firstName, ' ' ,stu.lastName) as 'Nome Estudante', f.familyGuardian as 'Encarregado Educacao',
			fs.familySize as 'Tamanho da Familia', f.familyStatus as 'Estado familiar', a.address as 'Morada', a.addressType 'Tipo Morada'
FROM [schStudent].[Student] stu
	JOIN [schStudent].[Vive] v ON stu.studentNumber = v.studentNumber
	JOIN [schStudent].[Family] f ON v.familyID = f.familyID
	JOIN [schStudent].[Address] a ON v.addressID = a.addressID
	JOIN schStudent.FamilySize fs ON f.familySizeID = fs.familySizeID
GO

GO
CREATE OR ALTER VIEW view_schoolYearInformation
AS
SELECT schy.schoolYear as 'Ano-Letivo', schy.activeYear as 'Ano ativo?', s.subjectName as 'Disciplinas'
FROM [schSchool].[SchoolYear] schy
	JOIN [schSchool].[Subject] s ON schy.schoolYearID = s.schoolYearID
GO