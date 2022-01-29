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


/*****
As funções findHealthID, findActivityID e findCoexistenceID são testadas na importação de dados
e podem ser verificadas se funcionaram se os estudantes tem IDs para estas tabelas
*****/
SELECT * FROM schStudent.Student;


/*****
As funções encriptarMorada é testada na importação de dados e podem ser verificadas atraves da sua desencriptação
*****/
SELECT * FROM schStudent.Address;

EXEC spOpenKeys
SELECT CONVERT(VARCHAR(100), DECRYPTBYKEY(address)) AS DecryptedAddress
FROM schStudent.Address


/*****
As funções fnFindMotherJobID, fnFindFatherJobID e fnFindFamilySizeID são testadas na importação de dados
e podem ser verificadas se funcionaram se as familias tem IDs para estas tabelas
*****/
SELECT * FROM schStudent.Family

/*****
Teste da função fnFindSubjectIDByName
*****/
SELECT * FROM schSchool.Subject
SELECT dbo.fnFindSubjectIDByName('MAT1')


/*****
Teste da função fnFindSubjectIDByName
*****/
SELECT * FROM schSchool.SchoolYear
SELECT dbo.fnBuscarAnoAberto()