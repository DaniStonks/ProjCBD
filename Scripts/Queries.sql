/**************************************************
*	UC: Complemento de Base de Dados	2021/2022
*
*	Projeto
*	Grupo 3
*
*	(Nome)						(N� Aluno)
*	Daniel Baptista				202001990
*	Rafael Silva				202001553
*	
*	Turma: 2�L_EI-SW-04			Sala: F356
*
***************************************************/

/*****
Queries que retornam os mesmos dados
em ambas as bases de dados
*****/

--Total de alunos por escola
SET STATISTICS IO ON
USE OldDataBase;

SELECT schoolName, (COUNT(studentID)/3) as 'Numero de alunos' --A contagem � dividida por 3 pois os alunos s�o reeinseridos na BD por cada disciplina, embora sejam os mesmos
FROM OldTable
GROUP BY schoolName;

USE Proj_DB_RS;

SELECT schoolName, COUNT(st.StudentNumber) as 'Numero de alunos'
FROM schStudent.Student st
JOIN schSchool.Matricula m ON st.studentNumber = m.studentNumber
JOIN schSchool.School s ON m.schoolID = s.schoolID
GROUP BY schoolName;

--Total de alunos por ano letivo
SET STATISTICS IO ON
USE OldDataBase;

SELECT schoolYear, (COUNT(studentID)/3) as 'Numero de alunos' --A contagem � dividida por 3 pois os alunos s�o reeinseridos na BD por cada disciplina, embora sejam os mesmos
FROM OldTable
GROUP BY schoolYear;

USE Proj_DB_RS;

SELECT schoolYear, COUNT(DISTINCT st.StudentNumber) as 'Numero de alunos'
FROM schStudent.Student st
JOIN schLogs.ClosedInscritos i ON st.studentNumber = i.studentNumber
JOIN schSchool.Subject s ON s.subjectID = i.subjectID
JOIN schSchool.SchoolYear sy ON sy.schoolYearID = s.schoolYearID
GROUP BY schoolYear;


--M�dia de notas no ano letivo por escola
SET STATISTICS IO ON
USE OldDataBase;

SELECT schoolName, schoolYear, ROUND((AVG(period1Grade+period2Grade+period3Grade)/3), 2) as 'Nota media'
FROM OldTable
GROUP BY schoolName, schoolYear
ORDER BY schoolYear;

SET STATISTICS IO ON
USE Proj_DB_RS;

SELECT schoolName, schoolYear, ROUND((AVG(g.period1Grade+g.period2Grade+g.period3Grade)/3), 2) as 'Nota media'
FROM schStudent.Student st
JOIN schLogs.ClosedGrade g ON st.studentNumber = g.studentNumber
JOIN schSchool.Subject s ON g.subjectID = s.subjectID
JOIN schSchool.SchoolYear y ON s.schoolYearID = y.schoolYearID
JOIN schSchool.Matricula m ON m.studentNumber = st.studentNumber
JOIN schSchool.School sc ON sc.schoolID = m.schoolID
GROUP BY schoolName, schoolYear
ORDER BY schoolYear;

--M�dia de notas por ano letivo e per�odo letivo por escola
SET STATISTICS IO ON
USE OldDataBase;

SELECT schoolName, schoolYear, ROUND(AVG(period1Grade),2) as 'Notas P1',
	   ROUND(AVG(period2Grade),2) as 'Notas P2', ROUND(AVG(period3Grade),2) as 'Notas P3'
FROM OldTable
GROUP BY schoolName, schoolYear
ORDER BY schoolYear;

USE Proj_DB_RS;

SELECT schoolName, schoolYear, ROUND(AVG(g.period1Grade), 2) as 'Nota P1',
	   ROUND(AVG(g.period2Grade), 2) as 'Nota P2', ROUND(AVG(g.period3Grade), 2) as 'Nota P3'
FROM schStudent.Student st
JOIN schLogs.ClosedGrade g ON st.studentNumber = g.studentNumber
JOIN schSchool.Subject s ON g.subjectID = s.subjectID
JOIN schSchool.SchoolYear y ON s.schoolYearID = y.schoolYearID
JOIN schSchool.Matricula m ON m.studentNumber = st.studentNumber
JOIN schSchool.School sc ON sc.schoolID = m.schoolID
GROUP BY schoolName, schoolYear
ORDER BY schoolYear;