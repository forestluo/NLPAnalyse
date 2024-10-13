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
-- Create date: <2021年1月25日>
-- Description:	<加载所有功能词规则>
-- =============================================

CREATE OR ALTER FUNCTION LoadAttributeRules 
(
	-- Add the parameters for the function here
)
RETURNS XML
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlResult UString;
	-- 拼接内容
	SET @SqlResult =
	(
		(
			SELECT content + '|'
				FROM
				(
					SELECT DISTINCT(content) AS content
						FROM dbo.WordAttribute WHERE classification = '功能词'
				) AS T
				ORDER BY LEN(content) DESC, content FOR XML PATH(''), TYPE
		).value('.', 'NVARCHAR(MAX)')
	);
	-- 替换
	-- SET @SqlResult = REPLACE(@SqlResult, '(', '');
	-- SET @SqlResult = REPLACE(@SqlResult, ')', '');
	SET @SqlResult = LEFT(@SqlResult, LEN(@SqlResult) - 1);
	-- 形成XML
	SET @SqlResult = '<rule>' + 
		'<regular>' + @SqlResult + '</regular>'
		+ '<attribute>功能词</attribute></rule>';
	-- 返回结果
	RETURN CONVERT(XML, '<result id="1">' + @SqlResult + '</result>');
END
GO
