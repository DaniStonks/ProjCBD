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

/************
 * EscolaMS *
 ************/
EXECUTE AS USER = 'EscMS'
SELECT * FROM schStudent.view_studentsInformationMS;
REVERT

--Erro pois não tem permissões para ver dados de outras escolas.
EXECUTE AS USER = 'EscMS'
SELECT * FROM schLogs.view_logGradesGP;
REVERT

--Erro pois EscolaMS não tem permissões para apagar registos de logs
EXECUTE AS USER = 'EscMS'
DELETE FROM schLogs.ClosedGrade WHERE subjectID = 1;
REVERT

--Sucesso pois pode adicionar registos
EXECUTE AS USER = 'EscMS'
INSERT INTO schSchool.School
VALUES('Escola escola1', '1morada')
REVERT


/************
 * EscolaGP *
 ************/
EXECUTE AS USER = 'EscGP'
SELECT * FROM schStudent.view_studentsInformationMS;
REVERT

--Erro pois não tem permissões para ver dados de outras escolas.
EXECUTE AS USER = 'EscGP'
SELECT * FROM schLogs.view_logGradesMS;
REVERT

--Erro pois EscolaMS não tem permissões para apagar registos de logs
EXECUTE AS USER = 'EscMS'
DELETE FROM schLogs.ClosedGrade WHERE subjectID = 1;
REVERT

--Sucesso pois pode adicionar registos
EXECUTE AS USER = 'EscGP'
INSERT INTO schSchool.School
VALUES('Escola escola2', 'morada2')
REVERT


/****************
 * UtilizadorGP *
 ****************/
EXECUTE AS USER = 'UserGP'
SELECT * FROM schStudent.view_studentsInformationGP;
REVERT

--Erro pois não tem permissões para ver dados de outras escolas.
EXECUTE AS USER = 'UserGP'
SELECT * FROM schLogs.view_logGradesMS;
REVERT

--Erro pois UtilizadorGP não tem permissões para apagar registos de logs
EXECUTE AS USER = 'UserGP'
DELETE FROM schLogs.ClosedGrade WHERE subjectID = 1;
REVERT

--Erro pois UtilizadorGP não tem permissões para adicionar registos
EXECUTE AS USER = 'UserGP'
INSERT INTO schSchool.SchoolYear
VALUES(2239, 1)
REVERT


/****************
 * UtilizadorMS *
 ****************/
EXECUTE AS USER = 'UserMS'
SELECT * FROM schStudent.view_studentsInformationMS;
REVERT

--Erro pois não tem permissões para ver dados de outras escolas.
EXECUTE AS USER = 'UserMS'
SELECT * FROM schLogs.view_logGradesGP;
REVERT

--Erro pois UtilizadorMS não tem permissões para apagar registos de logs
EXECUTE AS USER = 'UserMS'
DELETE FROM schLogs.ClosedGrade WHERE subjectID = 1;
REVERT

--Erro pois UtilizadorMS não tem permissões para adicionar registos
EXECUTE AS USER = 'UserMS'
INSERT INTO schSchool.SchoolYear
VALUES(2039, 1)
REVERT

/*****************
 * Administrador *
 *****************/
 --Executa tudo com sucesso pois tem acesso a toda a informação
EXECUTE AS USER = 'Admins'
SELECT * FROM schStudent.view_studentsInformationMS;
REVERT

EXECUTE AS USER = 'Admins'
SELECT * FROM schStudent.view_studentsInformationGP;
REVERT

EXECUTE AS USER = 'Admins'
DELETE FROM schLogs.ClosedGrade WHERE studentNumber = 201700001;
REVERT

EXECUTE AS USER = 'Admins'
INSERT INTO schSchool.SchoolYear
VALUES(2039, 1)
REVERT