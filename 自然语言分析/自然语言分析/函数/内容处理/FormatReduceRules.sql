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
-- Create date: <2020年12月12日>
-- Description:	<获得化简规则序列描述>
-- =============================================

CREATE OR ALTER FUNCTION FormatReduceRules
(
	-- Add the parameters for the function here
	@SqlTable UReduceTable READONLY
)
RETURNS UString
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlResult UString;
	-- 设置结果
	SET @SqlResult =
	(
		(
			SELECT '<rule id="' + CONVERT(NVARCHAR(MAX), id) + '"' +
				CASE id%2 WHEN 0 THEN ' sub="1"' ELSE '' END + '>' +
				parse_rule + '</rule>' FROM @SqlTable ORDER BY id FOR XML PATH(''), TYPE
		).value('.', 'nvarchar(max)')
	);
	-- 返回结果
	RETURN @SqlResult;
END
GO

