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
/*******************
 *   ENCRIPTA��O   *
 *******************/

/* Cria��o da master key */
GO
CREATE MASTER KEY ENCRYPTION
BY PASSWORD = 'pass123word'
GO

/* Cria��o do certificado de encripta��o */
GO
CREATE CERTIFICATE AddressCert
WITH SUBJECT = 'Protect data'
GO

/* Cria��o chave simetrica */
GO
CREATE SYMMETRIC KEY AddressTableKey
WITH ALGORITHM = AES_128 ENCRYPTION
BY CERTIFICATE AddressCert
GO