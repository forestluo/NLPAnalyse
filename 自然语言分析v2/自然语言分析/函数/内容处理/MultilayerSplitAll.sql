USE [nldb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年2月16日>
-- Description:	<将内容用多层次法进行分割>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[MultilayerSplitAll]
(
	-- Add the parameters for the function here
	@SqlContent UString
)
RETURNS XML
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlResult XML;
	DECLARE @SqlTable UMatchTable;

	-- 检查变量
	IF @SqlContent IS NULL OR LEN(@SqlContent) <= 0
		-- 返回结果
		RETURN CONVERT(XML, '<result id="-1">invalid content</result>');

	-------------------------------------------------------------------------------
	--
	-- 加载数量词正则规则
	--
	-------------------------------------------------------------------------------

	DECLARE @SqlID INT;
	DECLARE @SqlRule UString;
	DECLARE @SqlValue UString;
	DECLARE @SqlAttribute UString;

	DECLARE @SqlRules XML;
	SET @SqlRules = dbo.LoadNumericalRules();

	-- 将内容转换成小写
	SET @SqlValue = dbo.LatinConvert(@SqlContent);

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
				FROM dbo.RegExMatches(@SqlRule, @SqlValue, 1);
		-- 取下一条记录
		FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlRule, @SqlAttribute;
	END
	-- 关闭游标
	CLOSE SqlCursor;
	-- 释放游标
	DEALLOCATE SqlCursor;

	-------------------------------------------------------------------------------
	--
	-- 正向最大切分（完全重复的仅保留一项）
	--
	-------------------------------------------------------------------------------

	-- 正向最大切分
	SET @SqlResult = dbo.FMMSplitAll(1, @SqlContent);
	-- 插入到临时表中
	INSERT INTO @SqlTable
		(expression, position, value, length)
		SELECT
			'FMM',
			ISNULL(Nodes.value('(@pos)[1]', 'int'), 0) AS nodePos,
			Nodes.value('(text())[1]', 'nvarchar(max)') AS nodeValue,
			ISNULL(LEN(Nodes.value('(text())[1]', 'nvarchar(max)')), 0)
			FROM @SqlResult.nodes('//result/*') AS N(Nodes) ORDER BY nodePos;

	-------------------------------------------------------------------------------
	--
	-- 逆向最大切分（完全重复的仅保留一项）
	--
	-------------------------------------------------------------------------------

	-- 逆向最大切分
	SET @SqlResult = dbo.BMMSplitAll(1, @SqlContent);
	-- 插入到临时表中
	INSERT INTO @SqlTable
		(expression, position, value, length)
		SELECT
			'BMM',
			ISNULL(Nodes.value('(@pos)[1]', 'int'), 0) AS nodePos,
			Nodes.value('(text())[1]', 'nvarchar(max)') AS nodeValue,
			ISNULL(LEN(Nodes.value('(text())[1]', 'nvarchar(max)')), 0)
			FROM @SqlResult.nodes('//result/*') AS N(Nodes) ORDER BY nodePos;

	-------------------------------------------------------------------------------
	--
	-- 加载结构分析
	--
	-------------------------------------------------------------------------------

	-- 声明游标
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT rid, [rule]
			FROM dbo.ParseRule
			WHERE classification = '结构';
	-- 打开游标
	OPEN SqlCursor;
	-- 取第一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlRule;
	-- 循环处理游标
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 获得解析结果
		SET @SqlResult = dbo.MatchStructs(@SqlRule, @SqlContent);
		-- 检查结果
		IF @SqlResult IS NOT NULL AND
			ISNULL(@SqlResult.value('(//result/@id)[1]', 'int'), 0) > 0
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
						FROM @SqlResult.nodes('//result/row/matched') AS N(Nodes)
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
	SET @SqlValue =
	(
		(
			SELECT '<exp id="' + CONVERT(NVARCHAR(MAX),id) + '" type="' + expression + '" pos="' + CONVERT(NVARCHAR(MAX), position) + '" '
				+ 'len="' + CONVERT(NVARCHAR(MAX), length) + '">' + dbo.XMLEscape(value) + '</exp>'
				FROM @SqlTable ORDER BY position FOR XML PATH(''), TYPE
		).value('.', 'nvarchar(max)')
	);
	-- 返回结果
	RETURN dbo.ClearMatchTable(CONVERT(XML, '<result id="1">' + @SqlValue + '</result>'));
END
GO
