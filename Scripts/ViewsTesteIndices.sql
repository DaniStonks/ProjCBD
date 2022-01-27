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
CREATE OR ALTER VIEW view_taxaCrescimento
AS
SELECT schoolYear as 'Ano', dbo.fnCalcularTaxaCrescimento(schoolYear) as 'Taxa de crescimento'
FROM schSchool.SchoolYear
GROUP BY schoolYear
GO

GO
CREATE OR ALTER VIEW view_AlunosNotaMaiorQue15
AS
SELECT schoolYear as 'Ano', dbo.fnCalcularPercentagemNotaMaiorQue15(schoolYear) as 'Percentagem de alunos com nota maior que 15'
FROM schSchool.SchoolYear
GROUP BY schoolYear
GO

GO
CREATE OR ALTER VIEW view_EscolaMelhorMediaAnual
AS
SELECT schoolYear, schoolName, NotaMedia
FROM 
(
	SELECT schoolYear, schoolName, ROUND((AVG(period1Grade+period2Grade+period3Grade)/3), 2) as NotaMedia,
	ROW_NUMBER() OVER (PARTITION BY schoolYear ORDER BY ROUND((AVG(period1Grade+period2Grade+period3Grade)/3), 2) DESC) AS rn
	FROM schLogs.ClosedGrade st
	JOIN schSchool.Subject s ON st.subjectID = s.subjectID
	JOIN schSchool.SchoolYear y ON s.schoolYearID = y.schoolYearID
	JOIN schSchool.Matricula m ON m.studentNumber = st.studentNumber
	JOIN schSchool.School sc ON sc.schoolID = m.schoolID
	WHERE st.subjectID IN (SELECT subjectID FROM schSchool.Subject s
						   JOIN schSchool.SchoolYear sy ON sy.schoolYearID = s.schoolYearID
						   WHERE schoolYear IN (SELECT schoolYear FROM schSchool.SchoolYear))
	GROUP BY schoolName, schoolYear
) a
WHERE rn = 1
GO

--Indice para a view de taxa de crescimento
CREATE NONCLUSTERED INDEX indexCrescimento ON [schLogs].ClosedInscritos
(
	[subjectID]
)

--Indice para view da nota maior que 15
CREATE NONCLUSTERED INDEX indexNota15 ON [schLogs].[ClosedGrade]
(
	[subjectID]
)

CREATE NONCLUSTERED INDEX index15Recom
ON [schLogs].[ClosedGrade] ([subjectID])
INCLUDE ([studentNumber])

SELECT * FROM view_AlunosNotaMaiorQue15
SELECT * FROM view_taxaCrescimento
SELECT * FROM view_EscolaMelhorMediaAnual
