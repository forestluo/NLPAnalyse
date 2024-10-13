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
-- Description:	<提取内容中的所有正则表达式>
-- =============================================

CREATE OR ALTER FUNCTION MatchStructs
(	
	-- Add the parameters for the function here
	@SqlRule UString,
	@SqlContent UString
)
RETURNS XML
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlXML XML;
	DECLARE @SqlResult XML;

	DECLARE @SqlEnd INT;
	DECLARE @SqlStart INT;
	DECLARE @SqlIndex INT;
	DECLARE @SqlLength INT;
	DECLARE @SqlPosition INT;
	DECLARE @SqlValue UString;

	DECLARE @SqlRows UString;
	DECLARE @SqlOriginal UString;
	DECLARE @SqlTable UMatchTable;

	-- 检查参数
	IF @SqlRule IS NULL OR
		LEN(@SqlRule) <= 0
	BEGIN
		-- PRINT 'MatchStructs> 无效输入！';
		RETURN CONVERT(XML, '<result id="-1">rule is null</result>');
	END
	IF @SqlContent IS NULL OR
		LEN(@SqlContent) <= 0
	BEGIN
		-- PRINT 'MatchStructs> 无效输入！';
		RETURN CONVERT(XML, '<result id="-2">content is null</result>');
	END

	-- 保存原值
	SET @SqlOriginal = @SqlRule;
	-- 将规则转换成XML
	SET @SqlXML = dbo.ConvertRule(@SqlRule);
	-- 检查结果
	IF @SqlXML IS NULL
		RETURN CONVERT(XML, '<result id="-3">fail to conver rule</result>');

	-- 清理参数
	SET @SqlRule = dbo.ClearParameters(@SqlRule);
	-- 替换参数
	SET @SqlRule = REPLACE(@SqlRule, '$', dbo.GetRegularString('parameter'));

	-- 将Rule转换成半角
	SET @SqlRule = dbo.LatinConvert(@SqlRule);
	-- 将内容转换成半角
	SET @SqlContent = dbo.LatinConvert(@SqlContent);

	-- 将结果插入到新的记录表中
	INSERT INTO @SqlTable
		(value, length, position)
		SELECT Match, MatchLength, MatchIndex
			FROM dbo.RegExMatches(dbo.XMLUnescape(@SqlRule), @SqlContent, 1);

	-- 设置初始值
	SET @SqlRows = '';
	SET @SqlIndex = 0;
	-- 声明游标
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT value, length, position FROM @SqlTable;
	-- 打开游标
	OPEN SqlCursor;
	-- 取第一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlValue, @SqlLength, @SqlPosition;
	-- 循环处理游标
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 依据XML进行解析处理
		SET @SqlResult = dbo.XMLParseContent(@SqlXML, @SqlValue, 0);
		-- 检查结果
		IF @SqlResult IS NULL OR
			ISNULL(@SqlResult.value('(//result/@id)[1]', 'int'), 0) <= 0 GOTO NEXT_ROW;
		-- 获得结尾
		SET @SqlEnd = ISNULL(@SqlResult.value('(//result/@end)[1]', 'int'), 0);
		-- 获得开头
		SET @SqlStart = ISNULL(@SqlResult.value('(//result/@start)[1]', 'int'), 0);

		-- 设置索引值
		SET @SqlIndex = @SqlIndex + 1;
		-- 拼接结果
		SET @SqlRows = @SqlRows +
		(
			'<row id="' + CONVERT(NVARCHAR(MAX), @SqlIndex) + '">' +
				ISNULL('<matched pos="' + CONVERT(NVARCHAR(MAX), @SqlStart + @SqlPosition) + '" ' +
					'len="' + CONVERT(NVARCHAR(MAX), LEN(@SqlValue)) + '">' + @SqlValue + '</matched>', '') + 
			(
				SELECT '<' + nodeType + ' ' +
					'id="' + CONVERT(NVARCHAR(MAX), nodeID) + '" ' +
					'pos="' + CONVERT(NVARCHAR(MAX), nodePos) + '" ' +
					'len="' + CONVERT(NVARCHAR(MAX), LEN(nodeValue)) + '" ' + 
					ISNULL('name="' + nodeName + '" ','') + '>' + nodeValue + '</' + nodeType + '>'
					FROM
					(
						SELECT
							Nodes.value('local-name(.)', 'nvarchar(max)') AS nodeType,
							Nodes.value('(@id)[1]', 'int') AS nodeID,
							Nodes.value('(@pos)[1]', 'int') + @SqlPosition AS nodePos,
							Nodes.value('(@name)[1]', 'nvarchar(max)') AS nodeName,
							Nodes.value('(text())[1]', 'nvarchar(max)') AS nodeValue
							FROM @SqlResult.nodes('//result/*') AS N(Nodes)
					) AS T FOR XML PATH(''), TYPE
			).value('.', 'nvarchar(max)') + '</row>'
		);
NEXT_ROW:
		-- 取下一条记录
		FETCH NEXT FROM SqlCursor INTO @SqlValue, @SqlLength, @SqlPosition;
	END
	-- 关闭游标
	CLOSE SqlCursor;
	-- 释放游标
	DEALLOCATE SqlCursor;

	-- 检查结果
	IF LEN(@SqlRows) <= 0 RETURN CONVERT(XML, '<result id="-4">no results</result>');
	-- 返回结果
	RETURN CONVERT(XML, '<result id="1"><rule>' + @SqlOriginal + '</rule>' + @SqlRows + '</result>');
END
GO
