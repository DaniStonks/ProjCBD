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
Teste dos triggers de logs
*****/
SELECT * FROM schLogs.ClosedGrade;
SELECT * FROM schLogs.ClosedInscritos;

/*****
As funções findHealthID, findActivityID e findCoexistenceID são testadas na importação de dados
e podem ser verificadas se funcionaram se os estudantes teem IDs para estas tabelas
*****/
SELECT * FROM schStudent.Student;

/*****
Teste da procedure spRegistarUtilizadorAutenticacao e fnCodificaPassword
*****/
EXEC dbo.spRegistarUtilizadorAutenticacao 'password',201700107; --Registo de um estudante
EXEC dbo.spRegistarUtilizadorAutenticacao 'password',201700107; --Ira ser lançado erro pois o estudante 201700107 ja esta registado
EXEC dbo.spRegistarUtilizadorAutenticacao 'ohnono', 3; --Registo de um encarregado
SELECT * FROM schStudent.UserAutentication;

/*****
Teste da procedure spMudarPassword e fnAutenticarUtilizador
*****/
EXEC dbo.spMudarPassword'guardian3@escola.pt', 'ohnono', 'password3', 'passw'; --Será lançado um erro porque as novas passwords não coincidem
EXEC dbo.spMudarPassword'guardian3@escola.pt', 'ohnono', 'ohnono', 'ohnono'; --Como a password nova é a mesma que a velha será lançado um erro

--A password apenas será alterada se os dados estiverem corretos,
--que é verificado na função fnAutenticarUtlizador, esta sendo chamada dentro da procedure
EXEC dbo.spMudarPassword'guardian3', 'ohnono', 'ohn', 'ohn'; --Como o email de utilizador não esta correto é lançado um erro
SELECT * FROM schStudent.UserAutentication WHERE userEmail = 'guardian3@escola.pt'; --Visualização de dados pre-mudança
EXEC dbo.spMudarPassword'guardian3@escola.pt', 'ohnono', 'password3', 'password3'; --Como os dados estão corretos a password é alterada
SELECT * FROM schStudent.UserAutentication WHERE userEmail = 'guardian3@escola.pt'; --Visualização de dados pos-mudança

/*****
Teste do trigger trg_email_user_password_change
*****/
--Se a mudança de password tiver sido executada no teste acima,
--um email foi "enviado" ao utilizador, este sendo visivel na tabela EmailPW
SELECT * FROM schStudent.EmailPW;

/*****
Teste da procedure spCriarTokenPassword
*****/
EXEC dbo.spCriarTokenPassword 'guard@email.pt'; --Lançara erro pois o email não existe
EXEC dbo.spCriarTokenPassword 'guardian3@escola.pt';
SELECT * FROM schStudent.UserAutentication WHERE userEmail = 'guardian3@escola.pt'; --Visualização do token criado

/*****
Teste da procedure spMudarPasswordToken
*****/
DECLARE @token INT = (SELECT tokenPassword FROM schStudent.UserAutentication WHERE userEmail = 'guardian3@escola.pt');
EXEC dbo.spMudarPasswordToken 'guard@email.pt', @token, 'pass', 'pass'; --Lançara erro pois o email não existe
DECLARE @token INT = (SELECT tokenPassword FROM schStudent.UserAutentication WHERE userEmail = 'guardian3@escola.pt');
EXEC dbo.spMudarPasswordToken 'guardian3@escola.pt', @token, 'pass', 'pas'; --Erro pois as passwords não coincidem
EXEC dbo.spMudarPasswordToken 'guardian3@escola.pt', 83239, 'pass', 'pass'; --Erro porque o token não existe
DECLARE @token INT = (SELECT tokenPassword FROM schStudent.UserAutentication WHERE userEmail = 'guardian3@escola.pt');
EXEC dbo.spMudarPasswordToken 'guardian3@escola.pt', @token, 'pass', 'pass';

/*****
Teste da procedure spVerNotasAluno
*****/
EXEC dbo.spVerNotasAluno '201700107@escola.pt', 'password' --Encarregado ve as notas do seu educando
EXEC dbo.spVerNotasAluno 'guardian3@escola.pt', 'password3' --Encarregado ve as notas do seu educando
EXEC dbo.spVerNotasAluno 'guardian@escola.pt', 'ohn' --Será lançado um erro pois o utilizador não existe

/*****
Teste da procedure spInscreverAlunos
*****/

EXEC dbo.spInscreverAlunos'BD',201900003,'N',3; --Erro pois o estudante não está na base de dados
EXEC dbo.spInscreverAlunos'BD',201901947,'N',3; --Erro pois o aluno já se encontra inscrito na disciplina
INSERT INTO schStudent.Student
VALUES (dbo.fnMakeStudentNumber(3),null,null,null,'GP'
		,null,null,null,null,'Miguel','Santos',1,1,1);

EXEC dbo.spInscreverAlunos'BD',201900003,'N',3;

SELECT * FROM schSchool.Grade WHERE studentNumber = 201900003; --Visualização da inscrição do aluno
SELECT * FROM schSchool.Inscrito WHERE studentNumber = 201900003;
/*****
Teste da procedure spLancarNotas
*****/
EXEC dbo.spLancarNotas 201989324,'BD',17,10,13; --Erro pois o estudante não está na base de dados
EXEC dbo.spLancarNotas 201900003,'CBD',17,10,13; --Erro pois o aluno não se encontra inscrito na disciplina

EXEC dbo.spLancarNotas 201900003,'BD',17,10,13;
SELECT * FROM schSchool.Grade WHERE studentNumber = 201900003; --Visualização do lançamento das notas para o aluno 201900003

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