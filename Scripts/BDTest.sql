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
Teste dos triggers de logs
*****/
SELECT * FROM schLogs.ClosedGrade;
SELECT * FROM schLogs.ClosedInscritos;

/*****
As fun��es findHealthID, findActivityID e findCoexistenceID s�o testadas na importa��o de dados
e podem ser verificadas se funcionaram se os estudantes teem IDs para estas tabelas
*****/
SELECT * FROM schStudent.Student;

/*****
Teste da procedure spRegistarUtilizadorAutenticacao e fnCodificaPassword
*****/
EXEC dbo.spRegistarUtilizadorAutenticacao 'password',201700107; --Registo de um estudante
EXEC dbo.spRegistarUtilizadorAutenticacao 'password',201700107; --Ira ser lan�ado erro pois o estudante 201700107 ja esta registado
EXEC dbo.spRegistarUtilizadorAutenticacao 'ohnono', 3; --Registo de um encarregado
SELECT * FROM schStudent.UserAutentication;

/*****
Teste da procedure spMudarPassword e fnAutenticarUtilizador
*****/
EXEC dbo.spMudarPassword'guardian3@escola.pt', 'ohnono', 'password3', 'passw'; --Ser� lan�ado um erro porque as novas passwords n�o coincidem
EXEC dbo.spMudarPassword'guardian3@escola.pt', 'ohnono', 'ohnono', 'ohnono'; --Como a password nova � a mesma que a velha ser� lan�ado um erro

--A password apenas ser� alterada se os dados estiverem corretos,
--que � verificado na fun��o fnAutenticarUtlizador, esta sendo chamada dentro da procedure
EXEC dbo.spMudarPassword'guardian3', 'ohnono', 'ohn', 'ohn'; --Como o email de utilizador n�o esta correto � lan�ado um erro
SELECT * FROM schStudent.UserAutentication WHERE userEmail = 'guardian3@escola.pt'; --Visualiza��o de dados pre-mudan�a
EXEC dbo.spMudarPassword'guardian3@escola.pt', 'ohnono', 'password3', 'password3'; --Como os dados est�o corretos a password � alterada
SELECT * FROM schStudent.UserAutentication WHERE userEmail = 'guardian3@escola.pt'; --Visualiza��o de dados pos-mudan�a

/*****
Teste do trigger trg_email_user_password_change
*****/
--Se a mudan�a de password tiver sido executada no teste acima,
--um email foi "enviado" ao utilizador, este sendo visivel na tabela EmailPW
SELECT * FROM schStudent.EmailPW;

/*****
Teste da procedure spCriarTokenPassword
*****/
EXEC dbo.spCriarTokenPassword 'guard@email.pt'; --Lan�ara erro pois o email n�o existe
EXEC dbo.spCriarTokenPassword 'guardian3@escola.pt';
SELECT * FROM schStudent.UserAutentication WHERE userEmail = 'guardian3@escola.pt'; --Visualiza��o do token criado

/*****
Teste da procedure spMudarPasswordToken
*****/
DECLARE @token INT = (SELECT tokenPassword FROM schStudent.UserAutentication WHERE userEmail = 'guardian3@escola.pt');
EXEC dbo.spMudarPasswordToken 'guard@email.pt', @token, 'pass', 'pass'; --Lan�ara erro pois o email n�o existe
DECLARE @token INT = (SELECT tokenPassword FROM schStudent.UserAutentication WHERE userEmail = 'guardian3@escola.pt');
EXEC dbo.spMudarPasswordToken 'guardian3@escola.pt', @token, 'pass', 'pas'; --Erro pois as passwords n�o coincidem
EXEC dbo.spMudarPasswordToken 'guardian3@escola.pt', 83239, 'pass', 'pass'; --Erro porque o token n�o existe
DECLARE @token INT = (SELECT tokenPassword FROM schStudent.UserAutentication WHERE userEmail = 'guardian3@escola.pt');
EXEC dbo.spMudarPasswordToken 'guardian3@escola.pt', @token, 'pass', 'pass';

/*****
Teste da procedure spVerNotasAluno
*****/
EXEC dbo.spVerNotasAluno '201700107@escola.pt', 'password' --Encarregado ve as notas do seu educando
EXEC dbo.spVerNotasAluno 'guardian3@escola.pt', 'password3' --Encarregado ve as notas do seu educando
EXEC dbo.spVerNotasAluno 'guardian@escola.pt', 'ohn' --Ser� lan�ado um erro pois o utilizador n�o existe

/*****
Teste da procedure spInscreverAlunos
*****/

EXEC dbo.spInscreverAlunos'BD',201900003,'N',3; --Erro pois o estudante n�o est� na base de dados
EXEC dbo.spInscreverAlunos'BD',201901947,'N',3; --Erro pois o aluno j� se encontra inscrito na disciplina
INSERT INTO schStudent.Student
VALUES (dbo.fnMakeStudentNumber(3),null,null,null,'GP'
		,null,null,null,null,'Miguel','Santos',1,1,1);

EXEC dbo.spInscreverAlunos'BD',201900003,'N',3;

SELECT * FROM schSchool.Grade WHERE studentNumber = 201900003; --Visualiza��o da inscri��o do aluno
SELECT * FROM schSchool.Inscrito WHERE studentNumber = 201900003;
/*****
Teste da procedure spLancarNotas
*****/
EXEC dbo.spLancarNotas 201989324,'BD',17,10,13; --Erro pois o estudante n�o est� na base de dados
EXEC dbo.spLancarNotas 201900003,'CBD',17,10,13; --Erro pois o aluno n�o se encontra inscrito na disciplina

EXEC dbo.spLancarNotas 201900003,'BD',17,10,13;
SELECT * FROM schSchool.Grade WHERE studentNumber = 201900003; --Visualiza��o do lan�amento das notas para o aluno 201900003

/*****
Teste do trigger trg_change_activeYear
*****/
INSERT INTO schSchool.SchoolYear
VALUES (2020, 1);

SELECT * FROM schSchool.SchoolYear;

/*****
Views
*****/

--Testar a view_studentsInformation
SELECT * FROM view_studentsInformation

--Testar a view_studentsHealthStatus
SELECT * FROM view_studentsHealthStatus

--Testar a view_studentActivitys
SELECT * FROM view_studentActivities

--Testar view_studentGrades
SELECT * FROM view_studentGrades

--Testar view_studentFamilyInformation
SELECT * FROM view_studentFamilyInformation

--Testar view_schoolYearInformation
SELECT * FROM view_schoolYearInformation