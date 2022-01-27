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
/*******************
 *   ENCRIPTAÇÃO   *
 *******************/

/* Criação da master key */
GO
CREATE MASTER KEY ENCRYPTION
BY PASSWORD = 'pass123word'
GO

/* Criação do certificado de encriptação */
GO
CREATE CERTIFICATE AddressCert
WITH SUBJECT = 'Protect data'
GO

/* Criação chave simetrica */
GO
CREATE SYMMETRIC KEY AddressTableKey
WITH ALGORITHM = AES_128 ENCRYPTION
BY CERTIFICATE AddressCert
GO

/*
/* Visualização dos dados desencriptados */
GO
OPEN SYMMETRIC KEY AddressTableKey DECRYPTION
BY CERTIFICATE AddressCert
SELECT CONVERT(VARCHAR(100), DECRYPTBYKEY(address)) AS DecryptedAddress
FROM schStudent.Address
GO
*/