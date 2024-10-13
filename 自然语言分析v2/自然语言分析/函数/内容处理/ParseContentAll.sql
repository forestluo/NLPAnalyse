USE [nldb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年2月10日>
-- Description:	<依据规则解析内容>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[ParseContentAll]
(
	-- Add the parameters for the function here
	@SqlRule UString,
	@SqlContent UString
)
RETURNS XML
AS
BEGIN
	-- 定义临时变量
	DECLARE @SqlXML XML;
	DECLARE @SqlResult XML;

	DECLARE @SqlEnd INT;
	DECLARE @SqlStart INT;
	DECLARE @SqlIndex INT;
	DECLARE @SqlOffset INT;
	DECLARE @SqlValue UString;
	DECLARE @SqlMatched UString;

	-- 检查参数
	IF @SqlRule IS NULL
		OR @SqlContent IS NULL
		RETURN CONVERT(XML, '<result id="-1">input is null</result>');

	-- 将规则转换成XML
	SET @SqlXML = dbo.ConvertRule(@SqlRule);

	-- 设置初始值
	SET @SqlEnd = 0;
	SET @SqlStart = 0;
	SET @SqlIndex = 0;
	SET @SqlOffset = 0;
	SET @SqlValue = '';
	-- 循环处理
	WHILE @SqlEnd < LEN(@SqlContent)
	BEGIN
		-- 截取内容
		SET @SqlContent = RIGHT(@SqlContent, LEN(@SqlContent) - @SqlEnd);
		-- 依据XML进行解析处理
		SET @SqlResult = dbo.XMLParseContent(@SqlXML, @SqlContent, 0);
		-- 检查结果
		IF @SqlResult IS NULL OR
			ISNULL(@SqlResult.value('(//result/@id)[1]', 'int'), 0) <= 0 BREAK;
		-- 获得结尾
		SET @SqlEnd = ISNULL(@SqlResult.value('(//result/@end)[1]', 'int'), 0);
		-- 获得开头
		SET @SqlStart = ISNULL(@SqlResult.value('(//result/@start)[1]', 'int'), 0);
		-- 获得匹配内容
		SET @SqlMatched = SUBSTRING(@SqlContent, @SqlStart, @SqlEnd - @SqlStart);

		-- 设置索引值
		SET @SqlIndex = @SqlIndex + 1;
		-- 拼接结果
		SET @SqlValue = @SqlValue +
		(
			'<row id="' + CONVERT(NVARCHAR(MAX), @SqlIndex) + '">' +
				ISNULL('<matched pos="' + CONVERT(NVARCHAR(MAX), @SqlStart + @SqlOffset) + '" ' +
					'len="' + CONVERT(NVARCHAR(MAX), LEN(@SqlMatched)) + '">' + @SqlMatched + '</matched>', '') + 
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
							Nodes.value('(@pos)[1]', 'int') + @SqlOffset AS nodePos,
							Nodes.value('(@name)[1]', 'nvarchar(max)') AS nodeName,
							Nodes.value('(text())[1]', 'nvarchar(max)') AS nodeValue
							FROM @SqlResult.nodes('//result/*') AS N(Nodes)
					) AS T FOR XML PATH(''), TYPE
			).value('.', 'nvarchar(max)') + '</row>'
		);
		-- 设置偏移量
		SET @SqlOffset = @SqlOffset + @SqlEnd;
	END
	-- 检查结果
	IF LEN(@SqlValue) <= 0 RETURN CONVERT(XML, '<result id="-1">no results</result>');
	-- 返回结果
	RETURN CONVERT(XML, '<result id="1"><rule>' + @SqlRule + '</rule>' + @SqlValue + '</result>');
END
GO

