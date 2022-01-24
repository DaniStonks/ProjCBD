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
CREATE SECURITY POLICY UserFilter
ADD FILTER PREDICATE dbo.fn_SalesSecurity(UserName) 
ON dbo.Sales
WITH (STATE = ON);
GO


CREATE FUNCTION dbo.fn_SchoolSecurity(@schoolName AS sysname)
RETURNS TABLE
WITH SCHEMABINDING
AS
    RETURN SELECT 1 AS fn_SalesSecurity_Result
    -- Logic for filter predicate
    WHERE @schoolName = USER_NAME() 
    OR USER_NAME() = 'CEO';
GO

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

GRANT SELECT ON SCHEMA::schLogs TO UtilizadorGP;
GRANT SELECT ON SCHEMA::schSchool TO UtilizadorGP;
GRANT SELECT ON SCHEMA::schStudent TO UtilizadorGP;

GO

/************************
 *  ROLE UTILIZADOR MS  *
 ************************/
GO
CREATE ROLE UtilizadorMS;

GRANT SELECT ON SCHEMA::schLogs TO UtilizadorMS;
GRANT SELECT ON SCHEMA::schSchool TO UtilizadorMS;
GRANT SELECT ON SCHEMA::schStudent TO UtilizadorMS;
GO

/************************
 *    ROLE ESCOLA GP    *
 ************************/
GO
CREATE ROLE EscolaGP;

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
 *    ROLE ESCOLA MS    *
 ************************/
 GO
 CREATE ROLE EscolaMS;
 GO


/*********************
 *   Criação Users   *
 *********************/
--3) Crie 3 logins com a seguinte designação: UserS1, UserS2, UserS3.
CREATE LOGIN Adminstrador WITH PASSWORD='123';
CREATE LOGIN UserGP WITH PASSWORD='123';
CREATE LOGIN UserMS WITH PASSWORD='123';
CREATE LOGIN EscolaGP WITH PASSWORD='123';
CREATE LOGIN EscolaMS WITH PASSWORD='123';

--4) Crie 3 utilizadores, um para cada login, com o schema [Developer_Schema] pré-definido
CREATE USER Adminstrador FOR LOGIN Adminstrador;
CREATE USER UserGP FOR LOGIN UserGP;
CREATE USER UserS3 FOR LOGIN UserS3;
CREATE USER [UserS1] FOR LOGIN [UserS1];
CREATE USER UserS2 FOR LOGIN UserS2;
CREATE USER UserS3 FOR LOGIN UserS3;

EXEC sp_addrolemember N'Developer_Role', N'UserS1';
EXEC sp_addrolemember N'Client_Role', N'UserS2';
EXEC sp_addrolemember N'Reader_Role', N'UserS3';
