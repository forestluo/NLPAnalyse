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
-- Create date: <2021年2月11日>
-- Description:	<提取内容中的所有结构>
-- =============================================

CREATE OR ALTER FUNCTION ExtractStructs
(	
	-- Add the parameters for the function here
	@SqlContent UString
)
RETURNS XML
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlID INT;
	DECLARE @SqlXML XML;
	DECLARE @SqlRule UString;
	DECLARE @SqlValue UString;
	DECLARE @SqlAttribute UString;
	DECLARE @SqlClassification UString;
	-- 声明临时变量
	DECLARE @SqlResult UString;
	DECLARE @SqlTable UMatchTable;

	-- 检查参数
	IF @SqlContent IS NULL OR
		LEN(@SqlContent) <= 0
	BEGIN
		-- PRINT 'ExtractStructs> 无效输入！';
		RETURN CONVERT(XML, '<result id="-1"/>');
	END
	-- 将内容转换成半角
	SET @SqlContent = dbo.LatinConvert(@SqlContent);

	-- 声明游标
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT rid, [rule], [attribute], [classification]
			FROM dbo.PhraseRule
			WHERE classification IN ('正则', '数词', '数量词');
	-- 打开游标
	OPEN SqlCursor;
	-- 取第一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlRule, @SqlAttribute, @SqlClassification;
	-- 循环处理游标
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 实现替换
		SET @SqlRule = dbo.RecoverRegularRule(@SqlRule);
		-- 实现XML转义
		SET @SqlRule = dbo.XMLUnescape(@SqlRule);
		-- 将Rule转换成半角
		SET @SqlRule = dbo.LatinConvert(@SqlRule);
		-- 将结果插入到新的记录表中
		INSERT INTO @SqlTable
			(expression, value, length, position)
			SELECT @SqlAttribute, Match, MatchLength, MatchIndex + 1
				FROM dbo.RegExMatches(@SqlRule, @SqlContent, 1);
		-- 取下一条记录
		FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlRule, @SqlAttribute, @SqlClassification;
	END
	-- 关闭游标
	CLOSE SqlCursor;
	-- 释放游标
	DEALLOCATE SqlCursor;

	-- 声明游标
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT rid, [rule]
			FROM dbo.ParseRule
			WHERE classification IN ('结构');
	-- 打开游标
	OPEN SqlCursor;
	-- 取第一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlRule;
	-- 循环处理游标
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 获得解析结果
		SET @SqlXML = dbo.MatchStructs(@SqlRule, @SqlContent);
		-- 检查结果
		IF @SqlXML IS NOT NULL AND
			ISNULL(@SqlXML.value('(//result/@id)[1]', 'int'), 0) > 0
		BEGIN
			-- 插入数据
			INSERT INTO @SqlTable
				(expression, value, length, position)
				SELECT '结构', nodeValue, nodeLen, nodePos FROM
				(
					SELECT
						Nodes.value('(@pos)[1]', 'int') AS nodePos,
						Nodes.value('(@len)[1]', 'int') AS nodeLen,
						Nodes.value('(text())[1]','nvarchar(max)') AS nodeValue
						FROM @SqlXML.nodes('//result/row/matched') AS N(Nodes)
				) AS NodesTable;
		END
		-- 取下一条记录
		FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlRule;
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
