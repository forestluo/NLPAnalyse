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
-- Create date: <2020年12月13日>
-- Description:	<获得化简规则序列描述>
-- =============================================
CREATE OR ALTER FUNCTION FormatParseResult
(
	-- Add the parameters for the function here
	@SqlTable UParseTable READONLY
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
			SELECT '<' + type + ' ' + 
					'id="' + CONVERT(NVARCHAR(MAX), id) + '" ' +
					ISNULL('name="' + name + '" ','') +
					CASE seg WHEN 1 THEN 'seg="1" ' ELSE '' END +
					'pos="' + CONVERT(NVARCHAR(MAX), pos) + '">' +
					value + '</' + type + '>'
				FROM @SqlTable ORDER BY ID FOR XML PATH(''), TYPE
		).value('.', 'nvarchar(max)')
	);
	-- 返回结果
	RETURN @SqlResult;
END
GO

