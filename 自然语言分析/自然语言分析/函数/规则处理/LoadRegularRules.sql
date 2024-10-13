USE [nldb]
GO

-- ================================================
-- Template generated from Template Explorer using:
-- Create Scalar Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月23日>
-- Description:	<加载所有正则规则>
-- =============================================

CREATE OR ALTER FUNCTION LoadRegularRules 
(
	-- Add the parameters for the function here
)
RETURNS XML
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlResult UString;
	-- 形成XML
	SET @SqlResult = 
	(
		(
			SELECT '<rule rid="' + CONVERT(NVARCHAR(MAX), rid) + '">' +
				ISNULL('<regular>' + dbo.XMLEscape([rule]) + '</regular>','') +
				ISNULL('<attribute>' + dbo.XMLEscape([attribute]) + '</attribute>', '') + '</rule>'
				FROM dbo.PhraseRule
				WHERE [classification] = '正则'
				ORDER BY rid DESC FOR XML PATH(''), TYPE
		).value('.', 'nvarchar(max)')
	);
	-- 返回结果
	RETURN CONVERT(XML, '<result id="1">' + @SqlResult + '</result>');
END
GO
