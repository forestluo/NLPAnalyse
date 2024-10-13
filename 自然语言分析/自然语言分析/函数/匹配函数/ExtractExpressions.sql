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

CREATE OR ALTER FUNCTION ExtractExpressions
(	
	-- Add the parameters for the function here
	@SqlRules XML,
	@SqlContent UString
)
RETURNS XML
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlID INT;
	DECLARE @SqlRule UString;
	DECLARE @SqlAttribute UString;
	-- 声明临时变量
	DECLARE @SqlResult UString;
	DECLARE @SqlTable UMatchTable;

	-- 检查参数
	IF @SqlRules IS NULL
	BEGIN
		-- PRINT 'ExtractExpressions> 无效输入！';
		RETURN CONVERT(XML, '<result id="-1"/>');
	END
	-- 检查参数
	IF @SqlContent IS NULL OR
		LEN(@SqlContent) <= 0
	BEGIN
		-- PRINT 'ExtractExpressions> 无效输入！';
		RETURN CONVERT(XML, '<result id="-2"/>');
	END
	-- 将内容转换成半角
	SET @SqlContent = dbo.LatinConvert(@SqlContent);

	-- 声明游标
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT
			Nodes.value('(@rid)[1]','int') AS nodeID,
			Nodes.value('(./regular/text())[1]', 'nvarchar(max)') AS nodeRule,
			Nodes.value('(./attribute/text())[1]', 'nvarchar(max)') AS nodeAttribute
			FROM @SqlRules.nodes('//result/rule') AS N(Nodes); 
	-- 打开游标
	OPEN SqlCursor;
	-- 取第一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlRule, @SqlAttribute;
	-- 循环处理游标
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 实现XML转义
		SET @SqlRule = dbo.XMLUnescape(@SqlRule);
		-- 将Rule转换成半角
		SET @SqlRule = dbo.LatinConvert(@SqlRule);
		-- 将结果插入到新的记录表中
		INSERT INTO @SqlTable
			(expression, value, length , position)
			SELECT @SqlAttribute, Match, MatchLength, MatchIndex + 1
				FROM dbo.RegExMatches(@SqlRule, @SqlContent, 1);
		-- 取下一条记录
		FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlRule, @SqlAttribute;
	END
	-- 关闭游标
	CLOSE SqlCursor;
	-- 释放游标
	DEALLOCATE SqlCursor;

	-- 形成XML
	SET @SqlResult =
	(
		(
			SELECT '<exp id="' + CONVERT(NVARCHAR(MAX),id) + '" type="' + expression + '" pos="' + CONVERT(NVARCHAR(MAX), position) + '" '
				+ 'len="' + CONVERT(NVARCHAR(MAX), length) + '">' + dbo.XMLEscape(value) + '</exp>'
				FROM @SqlTable ORDER BY position FOR XML PATH(''), TYPE
		).value('.', 'nvarchar(max)')
	);
	-- 返回结果
	RETURN dbo.ClearMatchTable(CONVERT(XML, '<result id="1">' + @SqlResult + '</result>'));
END
GO
