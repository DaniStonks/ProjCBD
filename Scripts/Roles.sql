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

/**********************
 * ROLE ADMINISTRADOR *
 **********************/
GO
CREATE ROLE Administrador AUTHORIZATION dbo;

GRANT ALTER ON SCHEMA::schIdiom TO Administrador;
GRANT CONTROL ON SCHEMA::schIdiom TO Administrador;
GRANT SELECT ON SCHEMA::schIdiom TO Administrador;
GRANT DELETE ON SCHEMA::schIdiom TO Administrador;
GRANT INSERT ON SCHEMA::schIdiom TO Administrador;
GRANT UPDATE ON SCHEMA::schIdiom TO Administrador;

GRANT ALTER ON SCHEMA::schLogs TO Administrador;
GRANT CONTROL ON SCHEMA::schLogs TO Administrador;
GRANT SELECT ON SCHEMA::schLogs TO Administrador;
GRANT DELETE ON SCHEMA::schLogs TO Administrador;
GRANT INSERT ON SCHEMA::schLogs TO Administrador;
GRANT UPDATE ON SCHEMA::schLogs TO Administrador;

GRANT ALTER ON SCHEMA::schSchool TO Administrador;
GRANT CONTROL ON SCHEMA::schSchool TO Administrador;
GRANT SELECT ON SCHEMA::schSchool TO Administrador;
GRANT DELETE ON SCHEMA::schSchool TO Administrador;
GRANT INSERT ON SCHEMA::schSchool TO Administrador;
GRANT UPDATE ON SCHEMA::schSchool TO Administrador;

GRANT ALTER ON SCHEMA::schStudent TO Administrador;
GRANT CONTROL ON SCHEMA::schStudent TO Administrador;
GRANT SELECT ON SCHEMA::schStudent TO Administrador;
GRANT DELETE ON SCHEMA::schStudent TO Administrador;
GRANT INSERT ON SCHEMA::schStudent TO Administrador;
GRANT UPDATE ON SCHEMA::schStudent TO Administrador;
GO

/************************
 *  ROLE UTILIZADOR GP  *
 ************************/
GO
CREATE ROLE UtilizadorGP;

GRANT SELECT ON OBJECT::[schLogs].[view_logInscritosGP] TO UtilizadorGP;
GRANT SELECT ON OBJECT::[schLogs].[view_logGradesGP] TO UtilizadorGP;
GRANT SELECT ON OBJECT::[schSchool].[view_schoolYearInformationGP] TO UtilizadorGP;
GRANT SELECT ON OBJECT::[schSchool].[view_studentGradesGP] TO UtilizadorGP;
GRANT SELECT ON OBJECT::[schSchool].[view_studentInscritosGP] TO UtilizadorGP;
GRANT SELECT ON OBJECT::[schStudent].[view_studentActivitiesGP] TO UtilizadorGP;
GRANT SELECT ON OBJECT::[schStudent].[view_studentFamilyInformationGP] TO UtilizadorGP;
GRANT SELECT ON OBJECT::[schStudent].[view_studentsHealthStatusGP] TO UtilizadorGP;
GRANT SELECT ON OBJECT::[schStudent].[view_studentsInformationGP] TO UtilizadorGP;
GO

/************************
 *  ROLE UTILIZADOR MS  *
 ************************/
GO
CREATE ROLE UtilizadorMS;

GRANT SELECT ON OBJECT::[schLogs].[view_logInscritosMS] TO UtilizadorMS;
GRANT SELECT ON OBJECT::[schLogs].[view_logGradesMS] TO UtilizadorMS;
GRANT SELECT ON OBJECT::[schSchool].[view_schoolYearInformationMS] TO UtilizadorMS;
GRANT SELECT ON OBJECT::[schSchool].[view_studentGradesMS] TO UtilizadorMS;
GRANT SELECT ON OBJECT::[schSchool].[view_studentInscritosMS] TO UtilizadorMS;
GRANT SELECT ON OBJECT::[schStudent].[view_studentActivitiesMS] TO UtilizadorMS;
GRANT SELECT ON OBJECT::[schStudent].[view_studentFamilyInformationMS] TO UtilizadorMS;
GRANT SELECT ON OBJECT::[schStudent].[view_studentsHealthStatusMS] TO UtilizadorMS;
GRANT SELECT ON OBJECT::[schStudent].[view_studentsInformationMS] TO UtilizadorMS;
GO

/************************
 *    ROLE ESCOLA GP    *
 ************************/
GO
CREATE ROLE EscolaGP;

GRANT CONTROL ON SCHEMA::schLogs TO EscolaGP;
GRANT INSERT ON SCHEMA::schLogs TO EscolaGP;
GRANT UPDATE ON SCHEMA::schLogs TO EscolaGP;

GRANT ALTER ON OBJECT::schStudent.Student TO EscolaGP;
GRANT CONTROL ON OBJECT::schStudent.Student TO EscolaGP;
GRANT DELETE ON OBJECT::schStudent.Student TO EscolaGP;
GRANT INSERT ON OBJECT::schStudent.Student TO EscolaGP;
GRANT UPDATE ON OBJECT::schStudent.Student TO EscolaGP;

GRANT ALTER ON OBJECT::schSchool.Grade TO EscolaGP;
GRANT CONTROL ON OBJECT::schSchool.Grade TO EscolaGP;
GRANT DELETE ON OBJECT::schSchool.Grade TO EscolaGP;
GRANT INSERT ON OBJECT::schSchool.Grade TO EscolaGP;
GRANT UPDATE ON OBJECT::schSchool.Grade TO EscolaGP;

GRANT ALTER ON OBJECT::schSchool.Inscrito TO EscolaGP;
GRANT CONTROL ON OBJECT::schSchool.Inscrito TO EscolaGP;
GRANT DELETE ON OBJECT::schSchool.Inscrito TO EscolaGP;
GRANT INSERT ON OBJECT::schSchool.Inscrito TO EscolaGP;
GRANT UPDATE ON OBJECT::schSchool.Inscrito TO EscolaGP;

GRANT SELECT ON OBJECT::[schLogs].[view_logInscritosGP] TO EscolaGP;
GRANT SELECT ON OBJECT::[schLogs].[view_logGradesGP] TO EscolaGP;
GRANT SELECT ON OBJECT::[schSchool].[view_schoolYearInformationGP] TO EscolaGP;
GRANT SELECT ON OBJECT::[schSchool].[view_studentGradesGP] TO EscolaGP;
GRANT SELECT ON OBJECT::[schSchool].[view_studentInscritosGP] TO EscolaGP;
GRANT SELECT ON OBJECT::[schStudent].[view_studentActivitiesGP] TO EscolaGP;
GRANT SELECT ON OBJECT::[schStudent].[view_studentFamilyInformationGP] TO EscolaGP;
GRANT SELECT ON OBJECT::[schStudent].[view_studentsHealthStatusGP] TO EscolaGP;
GRANT SELECT ON OBJECT::[schStudent].[view_studentsInformationGP] TO EscolaGP;
GO

/************************
 *    ROLE ESCOLA MS    *
 ************************/
 GO
 CREATE ROLE EscolaMS;

GRANT CONTROL ON OBJECT::schLogs.ClosedInscritos TO EscolaMS;
GRANT INSERT ON OBJECT::schLogs.ClosedInscritos TO EscolaMS;
GRANT UPDATE ON OBJECT::schLogs.ClosedInscritos TO EscolaMS;

GRANT CONTROL ON OBJECT::schLogs.ClosedGrade TO EscolaMS;
GRANT INSERT ON OBJECT::schLogs.ClosedGrade TO EscolaMS;
GRANT UPDATE ON OBJECT::schLogs.ClosedGrade TO EscolaMS;

GRANT ALTER ON OBJECT::schStudent.Student TO EscolaMS;
GRANT CONTROL ON OBJECT::schStudent.Student TO EscolaMS;
GRANT DELETE ON OBJECT::schStudent.Student TO EscolaMS;
GRANT INSERT ON OBJECT::schStudent.Student TO EscolaMS;
GRANT UPDATE ON OBJECT::schStudent.Student TO EscolaMS;

GRANT ALTER ON OBJECT::schSchool.Grade TO EscolaMS;
GRANT CONTROL ON OBJECT::schSchool.Grade TO EscolaMS;
GRANT DELETE ON OBJECT::schSchool.Grade TO EscolaMS;
GRANT INSERT ON OBJECT::schSchool.Grade TO EscolaMS;
GRANT UPDATE ON OBJECT::schSchool.Grade TO EscolaMS;

GRANT ALTER ON OBJECT::schSchool.Inscrito TO EscolaMS;
GRANT CONTROL ON OBJECT::schSchool.Inscrito TO EscolaMS;
GRANT DELETE ON OBJECT::schSchool.Inscrito TO EscolaMS;
GRANT INSERT ON OBJECT::schSchool.Inscrito TO EscolaMS;
GRANT UPDATE ON OBJECT::schSchool.Inscrito TO EscolaMS;

GRANT SELECT ON OBJECT::[schLogs].[view_logInscritosMS] TO EscolaMS;
GRANT SELECT ON OBJECT::[schLogs].[view_logGradesMS] TO EscolaMS;
GRANT SELECT ON OBJECT::[schSchool].[view_schoolYearInformationMS] TO EscolaMS;
GRANT SELECT ON OBJECT::[schSchool].[view_studentGradesMS] TO EscolaMS;
GRANT SELECT ON OBJECT::[schSchool].[view_studentInscritosMS] TO EscolaMS;
GRANT SELECT ON OBJECT::[schStudent].[view_studentActivitiesMS] TO EscolaMS;
GRANT SELECT ON OBJECT::[schStudent].[view_studentFamilyInformationMS] TO EscolaMS;
GRANT SELECT ON OBJECT::[schStudent].[view_studentsHealthStatusMS] TO EscolaMS;
GRANT SELECT ON OBJECT::[schStudent].[view_studentsInformationMS] TO EscolaMS;
GO


/*********************
 *   Criação Users   *
 *********************/
CREATE LOGIN Admin WITH PASSWORD='123';
CREATE LOGIN UserGP WITH PASSWORD='123';
CREATE LOGIN UserMS WITH PASSWORD='123';
CREATE LOGIN EscolaMS WITH PASSWORD='123';
CREATE LOGIN EscolaGP WITH PASSWORD='123';

CREATE USER Admins FOR LOGIN Admin;
CREATE USER UserGP FOR LOGIN UserGP;
CREATE USER UserMS FOR LOGIN UserMS;
CREATE USER EscMS FOR LOGIN EscolaMS;
CREATE USER EscGP FOR LOGIN EscolaGP;

EXEC sp_addrolemember 'Administrador', 'Admins';
EXEC sp_addrolemember 'UtilizadorGP', 'UserGP';
EXEC sp_addrolemember 'UtilizadorMS', 'UserMS';
EXEC sp_addrolemember 'EscolaMS', 'EscMS';
EXEC sp_addrolemember 'EscolaGP', 'EscGP';

EXECUTE AS USER = 'EscMS'
SELECT * FROM schStudent.Family
REVERT
