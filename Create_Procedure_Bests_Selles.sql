USE [AdventureWorks2019]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Sellers]

			@NomeVendedor		VARCHAR(10) = NULL
		,	@SobrenomeVendedor	VARCHAR(10) = NULL
		
AS 
		
SELECT		FirstName		AS	'Nome'
		,	LastName		AS	'Sobrenome'
		,	EmailAddress	AS	'E-mail'
		,	PhoneNumber		AS	'Telefone'
		,	JobTitle		AS	'Cargo'
		,	FORMAT(SUM(SalesQuota), 'C', 'EN-US') AS  'Valor_Total_Vendido'

FROM Person.Person PP (NOLOCK)

LEFT JOIN Person.EmailAddress	PE	(NOLOCK)	ON
	PE.BusinessEntityID = PP.BusinessEntityID

LEFT JOIN Person.PersonPhone	PF	(NOLOCK)	ON
	PF.BusinessEntityID = PP.BusinessEntityID

INNER JOIN HumanResources.Employee	HE	(NOLOCK)	ON
	HE.BusinessEntityID	= PP.BusinessEntityID

INNER JOIN Sales.SalesPersonQuotaHistory	SSPQH	(NOLOCK)	ON
	SSPQH.BusinessEntityID = PP.BusinessEntityID

WHERE		(PP.FirstName = @NomeVendedor)		OR	(@NomeVendedor		IS NULL) 
		AND (PP.LastName  = @SobrenomeVendedor)	OR	(@SobrenomeVendedor IS NULL)

GROUP BY FirstName,LastName,EmailAddress,PhoneNumber,JobTitle

HAVING 100000 < SUM(SalesQuota)

ORDER BY SUM(SalesQuota) DESC



