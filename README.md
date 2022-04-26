##Criação de Procedure T-SQL (SQL SERVER)

**Trecho de criação padrão da procedure**
~~~~sql
USE [AdventureWorks2019]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Sellers]
~~~~
--------------
**Definição dos parâmetros @NomeVendedor e @SobrenomeVendedor...
Informo também que eles podem ser nulos, cabendo ao usuário preenchelos ou não**
~~~~sql
 @NomeVendedor		VARCHAR(10) = NULL
,@SobrenomeVendedor	VARCHAR(10) = NULL
~~~~		


**Inicio a minha Query**
~~~~sql		
SELECT		FirstName		AS	'Nome'
		,	LastName		AS	'Sobrenome'
		,	EmailAddress	AS	'E-mail'
		,	PhoneNumber		AS	'Telefone'
		,	JobTitle		AS	'Cargo'
		,	FORMAT(SUM(SalesQuota), 'C', 'EN-US') AS  'Valor_Total_Vendido'

--Tabela genérica de funcionários/clientes
FROM Person.Person PP (NOLOCK)

--Tabela genérica de emails funcionários/clientes
LEFT JOIN Person.EmailAddress	PE	(NOLOCK)	ON
	PE.BusinessEntityID = PP.BusinessEntityID -- Relacionamento

--Tabela genérica telefone funcionarios/clientes
LEFT JOIN Person.PersonPhone	PF	(NOLOCK)	ON
	PF.BusinessEntityID = PP.BusinessEntityID -- Relacionamento

--Tabela de funcionários para pegar os cargos
INNER JOIN HumanResources.Employee	HE	(NOLOCK)	ON
	HE.BusinessEntityID	= PP.BusinessEntityID -- Relacionamento

--Tabela de vendedores
INNER JOIN Sales.SalesPersonQuotaHistory	SSPQH	(NOLOCK)	ON
	SSPQH.BusinessEntityID = PP.BusinessEntityID -- Relacionamento

-- Iniciando a clausula WHERE
-- O nome informado no parâmetro deve ser igual a de um vendedor.
-- Se o nome não for de um vendedor não retornará resultado
-- Pode se chamar a procedure sem passar nenhum parâmetro, será retornado todos os vendedores
WHERE		(PP.FirstName = @NomeVendedor)		OR	(@NomeVendedor		IS NULL) 
		AND (PP.LastName  = @SobrenomeVendedor)	OR	(@SobrenomeVendedor IS NULL)

-- Agrupando os grupos da função de agragação SUM
GROUP BY FirstName,LastName,EmailAddress,PhoneNumber,JobTitle

-- Clausula HAVING similar ao WHERE porém ele é executado após o GROUP BY
HAVING 100000 < SUM(SalesQuota)

-- Orderna pelo valor mais alto, últil quando a procedure for chamada sem parâmetros
ORDER BY SUM(SalesQuota) DESC
~~~~
