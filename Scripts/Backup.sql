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

/************************
 * BACKUP E RECUPERA��O *
 ************************/
 USE Proj_DB_RS;


 --Modelo de recupera��o
 ALTER DATABASE [Proj_DB_RS] SET RECOVERY FULL

/**
Para o iniciou do ano letivo enquanto est� haver uma grande alfluencia de dados nas tabelas
decide-se fazer backup completo da base de dados todos os dias a noite at� as inscri��es acabarem
**/
 --Backup completo da base de dados Inicial
 BACKUP DATABASE Proj_DB_RS
 TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\Backup_Initial' 
 WITH  DESCRIPTION = N'Come�o do ano letivo'

  --Sequencia de recupera��o para o backup inicial da base de dados
 BACKUP LOG Proj_DB_RS
 TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\TrLogs_01.trn'
 WITH NORECOVERY, NO_TRUNCATE

 RESTORE DATABASE Proj_DB_RS
 FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\Backup_Initial.bak'
 WITH NORECOVERY

 RESTORE LOG Proj_DB_RS
 FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\TrLogs_01.trn'
 WITH RECOVERY


 /**
 Ap�s ter passado as inscri��es dos novos alunos, ou seja, uma grande afluencia de dados nas tabelas
 vai-se proceder ao backup diferencial, pois como este em termos de tamanho e performance pesa menos
 do que estar constantemente a fazer backup completo, decide-se fazer backup diferencial e um 
 backup completo ao final de cada m�s
 **/
 --Backup diferencial da base de dados diario
BACKUP LOG Proj_DB_RS
TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\DiffDaily_001.trn'
WITH DIFFERENTIAL

--backup completo ao final de cada m�s
BACKUP DATABASE Proj_DB_RS
TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\MonthlyFullBK.bak'

 --Sequencia de recupera��o para o backup durante o ano letivo
 BACKUP LOG Proj_DB_RS
 TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\TrLogs_02.trn'
 WITH NORECOVERY, NO_TRUNCATE

 RESTORE DATABASE Proj_DB_RS
 FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\MonthlyFullBK.bak'
 WITH NORECOVERY

 RESTORE LOG Proj_DB_RS
 FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\DiffDaily_001.trn'
 WITH FILE = 1, NORECOVERY

 RESTORE LOG Proj_DB_RS
 FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\TrLogs_02.trn'
 WITH RECOVERY

 /**
 Quando terminado o ano letivo volta-se a fazer backups completos a base de dados devido 
 a nova alfuencia de dados nas tabelas
 **/
--Backup no final do ano letivo
BACKUP DATABASE Proj_DB_RS
TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\FinalFullBK.bak'

--Sequencia de recupera��o da base de dados no final do ano letivo
  --Sequencia de recupera��o para o backup inicial da base de dados
 BACKUP LOG Proj_DB_RS
 TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\TrLogs_03.trn'
 WITH NORECOVERY, NO_TRUNCATE

 RESTORE DATABASE Proj_DB_RS
 FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\FinalFullBK.bak'
 WITH NORECOVERY

 RESTORE LOG Proj_DB_RS
 FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\TrLogs_03.trn'
 WITH RECOVERY
