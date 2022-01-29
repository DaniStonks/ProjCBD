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

USE Proj_DB_RS;


/*****
As fun��es findHealthID, findActivityID e findCoexistenceID s�o testadas na importa��o de dados
e podem ser verificadas se funcionaram se os estudantes tem IDs para estas tabelas
*****/
SELECT * FROM schStudent.Student;


/*****
As fun��es encriptarMorada � testada na importa��o de dados e podem ser verificadas atraves da sua desencripta��o
*****/
SELECT * FROM schStudent.Address;

EXEC spOpenKeys
SELECT CONVERT(VARCHAR(100), DECRYPTBYKEY(address)) AS DecryptedAddress
FROM schStudent.Address


/*****
As fun��es fnFindMotherJobID, fnFindFatherJobID e fnFindFamilySizeID s�o testadas na importa��o de dados
e podem ser verificadas se funcionaram se as familias tem IDs para estas tabelas
*****/
SELECT * FROM schStudent.Family

/*****
Teste da fun��o fnFindSubjectIDByName
*****/
SELECT * FROM schSchool.Subject
SELECT dbo.fnFindSubjectIDByName('MAT1')


/*****
Teste da fun��o fnFindSubjectIDByName
*****/
SELECT * FROM schSchool.SchoolYear
SELECT dbo.fnBuscarAnoAberto()