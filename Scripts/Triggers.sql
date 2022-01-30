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

DROP TRIGGER schSchool.trg_backup_grades;
GO
CREATE TRIGGER schSchool.trg_backup_grades
ON schSchool.Grade
AFTER INSERT
AS
BEGIN
	INSERT INTO schLogs.ClosedGrade (classFailures, subjectAbsences, period1Grade, period2Grade, 
								     period3Grade, subjectID, studentNumber, logDate)
	SELECT classFailures, subjectAbsences, period1Grade,
		   period2Grade, period3Grade, subjectID, studentNumber, GETDATE() FROM inserted
END
GO

DROP TRIGGER schSchool.trg_backup_inscritos;
GO
CREATE TRIGGER schSchool.trg_backup_inscritos
ON schSchool.Inscrito
AFTER INSERT
AS
BEGIN
	INSERT INTO schLogs.ClosedInscritos(weekStudyTime, paidClasses, studentNumber, subjectID, logDate)
	SELECT weekStudyTime, paidClasses, studentNumber, subjectID, GETDATE() FROM inserted
END
GO

/**
este trigger implmenta a RF11 - "O sistema deverá notificar o utilizador, sempre que este mude a password, por email"
**/
DROP TRIGGER schStudent.trg_email_user_password_change;
GO
CREATE TRIGGER schStudent.trg_email_user_password_change
ON schStudent.UserAutentication
AFTER UPDATE
AS
BEGIN
	DECLARE @newPW VARCHAR(128) = (SELECT hashPassword FROM inserted)
	DECLARE @oldPW VARCHAR(128) = (SELECT hashPassword FROM deleted)

	IF(@newPW != @oldPW) --apenas vai enviar o email no caso de mudança de password
	BEGIN
		DECLARE @email VARCHAR(40) = (SELECT userEmail FROM inserted)

		INSERT INTO schStudent.LogsPassword(userEmail, emailEvent)
		VALUES (@email, 'U')
	END
END
GO