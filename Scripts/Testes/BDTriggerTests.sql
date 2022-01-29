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
Teste dos triggers de backup
*****/
SELECT * FROM schLogs.ClosedGrade;
SELECT * FROM schLogs.ClosedInscritos;

/*****
Teste do trigger trg_email_user_password_change
*****/
--Se a mudança de password tiver sido executada no ficheiro de testes de procedures,
--um email foi "enviado" ao utilizador, este sendo visivel na tabela LogsPassword
SELECT * FROM schStudent.LogsPassword;