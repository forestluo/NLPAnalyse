USE [nldb]
GO

-- ================================================
-- Template generated from Template Explorer using:
-- Create Inline Function (New Menu).SQL
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
-- Create date: <2020年12月16日>
-- Description:	<提取内容中的所有正则表达式>
-- =============================================

CREATE OR ALTER FUNCTION MatchExpressions
(	
	-- Add the parameters for the function here
	@SqlRule UString,
	@SqlContent UString
)
RETURNS XML
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlResult UString;
	DECLARE @SqlTable UMatchTable;

	-- 检查参数
	IF @SqlContent IS NULL OR
		LEN(@SqlContent) <= 0
	BEGIN
		-- PRINT 'MatchExpressions> 无效输入！';
		RETURN CONVERT(XML, '<result id="-1"/>');
	END
	IF @SqlRule IS NULL OR
		LEN(@SqlRule) <= 0
	BEGIN
		-- PRINT 'MatchExpressions> 无效输入！';
		RETURN CONVERT(XML, '<result id="-2"/>');
	END

	-- 将Rule转换成半角
	SET @SqlRule = dbo.LatinConvert(@SqlRule);
	-- 将内容转换成半角
	SET @SqlContent = dbo.LatinConvert(@SqlContent);

	-- 将结果插入到新的记录表中
	INSERT INTO @SqlTable
		(value, length , position)
		SELECT Match, MatchLength, MatchIndex + 1
			FROM dbo.RegExMatches(dbo.XMLUnescape(@SqlRule), @SqlContent, 1);

	-- 形成XML
	SET @SqlResult =
	(
		(
			SELECT '<exp pos="' + CONVERT(NVARCHAR(MAX), position) + '" '
				+ 'id="' + CONVERT(NVARCHAR(MAX), id) + '" '
				+ 'len="' + CONVERT(NVARCHAR(MAX), length) + '">' + dbo.XMLEscape(value) + '</exp>'
				FROM @SqlTable ORDER BY position FOR XML PATH(''), TYPE
		).value('.', 'nvarchar(max)')
	);
	-- 返回结果
	RETURN CONVERT(XML, '<result id="1">' + @SqlResult + '</result>');
END
GO
