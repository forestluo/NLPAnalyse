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
-- Create date: <20201207>
-- Description:	<从内容中切分出一个句子>
-- =============================================

CREATE OR ALTER FUNCTION XMLCutSentence
(
	-- Add the parameters for the function here
	@SqlContent UString,
	@SqlExpressions XML
)
RETURNS XML
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlResult XML;
	-- 声明临时表变量
	DECLARE @SqlTable UReduceTable;

	DECLARE @SqlRule UString;
	DECLARE @SqlMatchRule UString;
	DECLARE @SqlReduceRule UString;

	DECLARE @SqlSentence UString;
	DECLARE @SqlClassification UString;

	-- 检查参数
	IF @SqlContent IS NULL OR LEN(@SqlContent) <= 0
	BEGIN
		-- 返回结果
		RETURN CONVERT(XML, '<result id="-1">input is null</result>');
	END
	--------------------------------------------------------------------------------
	--
	-- 剪除内容的无效字符。
	--
	--------------------------------------------------------------------------------
	-- 剪除无效字符
	SET @SqlContent = dbo.LeftTrim(@SqlContent);
	-- 检查结果
	IF @SqlContent IS NULL OR LEN(@SqlContent) <= 0
	BEGIN
		-- 返回结果
		RETURN CONVERT(XML,	'<result id="-2">input is null after trimed</result>');
	END
	--------------------------------------------------------------------------------
	--
	-- 按照最大容量读取一段内容（其中能容纳一个齐头开始的句子）。
	--
	--------------------------------------------------------------------------------
	-- 读取一段内容，生成相关结果
	SET @SqlResult = dbo.ReadContent(@SqlContent, @SqlExpressions);
	-- 检查结果
	IF @SqlResult IS NULL OR
		ISNULL(@SqlResult.value('(//result/@id)[1]', 'int'), 0) <= 0
	BEGIN
		-- 返回结果
		RETURN CONVERT(XML, '<result id="-2">fail to read content</result>');
	END
	-- 获得规则
	SET @SqlRule = @SqlResult.value('(//result/rule/text())[1]', 'nvarchar(max)');
	-- 检查结果
	IF @SqlRule IS NULL OR LEN(@SqlRule) <= 0
	BEGIN
		-- 返回结果
		RETURN CONVERT(XML,	'<result id="-3">fail to get rule</result>');
	END

	--------------------------------------------------------------------------------
	--
	-- 创建规则历史记录表。
	--
	--------------------------------------------------------------------------------
	-- 设置初始值
	SET @SqlSentence = @SqlContent;

	-- 循环处理
	WHILE @SqlResult IS NOT NULL AND @SqlRule IS NOT NULL
	BEGIN
		--------------------------------------------------------------------------------
		--
		-- 检查当前整体规则，类别不为空或者为自身均可以。
		--
		--------------------------------------------------------------------------------
		-- 检查当前规则状态
		SET @SqlClassification =
			dbo.ParseRuleGetClassification(@SqlRule);
		-- 检查结果
		-- 本内容自身就可以在规则库中匹配到
		IF dbo.IsTerminateRule(@SqlRule) = 1 OR
			@SqlClassification IN ('拼接', '配对', '通用')
		BEGIN
			-- 插入原始记录
			INSERT INTO @SqlTable (parse_rule) VALUES (@SqlRule);
			-- 要把所有的内容组装起来
			SET @SqlSentence = dbo.GetResultSentence(@SqlResult, @SqlRule);
			-- 返回结果
			RETURN CONVERT(XML, '<result id="1">' +
				'<sentence>' + dbo.XMLEscape(@SqlSentence) + '</sentence>' + dbo.FormatReduceRules(@SqlTable) + '</result>');
		END
		ELSE
		BEGIN
			-- 插入原始记录
			INSERT INTO @SqlTable (parse_rule) VALUES (@SqlRule);
		END

		--------------------------------------------------------------------------------
		--
		-- 可以直接匹配。
		--
		--------------------------------------------------------------------------------
		-- 直接匹配
		SET @SqlMatchRule = dbo.MatchSentenceRule(@SqlRule);
		-- 检查结果
		IF @SqlMatchRule IS NOT NULL
		BEGIN
			-- 插入原始记录
			INSERT INTO @SqlTable (parse_rule) VALUES (@SqlMatchRule);
			-- 要把所有的内容组装起来
			SET @SqlSentence = dbo.GetResultSentence(@SqlResult, @SqlMatchRule);
			-- 返回结果
			RETURN CONVERT(XML, '<result id="1">' +
				'<sentence>' + dbo.XMLEscape(@SqlSentence) + '</sentence>' + dbo.FormatReduceRules(@SqlTable) + '</result>');
		END

		--------------------------------------------------------------------------------
		--
		-- 对规则进行简化，简化至可以直接识别为止。
		--
		--------------------------------------------------------------------------------
		-- 获取化简规则
		SET @SqlReduceRule = dbo.MatchReduceRule(@SqlRule);
		-- 检查结果
		IF @SqlReduceRule IS NULL OR LEN(@SqlReduceRule) <= 0
		BEGIN
			-- 要把所有的内容组装起来
			SET @SqlSentence = dbo.GetResultSentence(@SqlResult, @SqlRule);
			-- 返回结果
			RETURN CONVERT(XML,	'<result id="-7">' +
				'<sentence>' + dbo.XMLEscape(@SqlSentence) + '</sentence>' + dbo.FormatReduceRules(@SqlTable) + '</result>');
		END
		-- 插入原始记录
		INSERT INTO @SqlTable (parse_rule) VALUES (@SqlReduceRule);

		-- 对结果进行化简
		SET @SqlResult = dbo.GetReducedResult(@SqlResult, @SqlReduceRule);
		-- 检查结果
		-- 无法获得相应的简化结果
		IF @SqlResult IS NULL OR
			ISNULL(@SqlResult.value('(//result/@id)[1]', 'int'), 0) <= 0
		BEGIN
			-- 返回结果
			RETURN CONVERT(XML,	'<result id="-8">reduced result is null' + dbo.FormatReduceRules(@SqlTable) + '</result>');
		END

		--------------------------------------------------------------------------------
		--
		-- 用于简化的的规则本身就是单句（单句要求齐头开始解析）。
		--
		--------------------------------------------------------------------------------
		-- 检查类型
		SET @SqlClassification = dbo.ParseRuleGetClassification(@SqlReduceRule);
		-- 检查结果
		IF @SqlClassification = '单句'
		BEGIN
			-- 获得句子内容
			SET @SqlSentence =
				@SqlResult.value('(//result/var[@name="a"]/text())[1]', 'nvarchar(max)');
			-- 检查结果
			IF @SqlSentence IS NULL OR LEN(@SqlSentence) <= 0
			BEGIN
				-- 返回结果
				RETURN CONVERT(XML, '<result id="1">sentence is null' +
					dbo.FormatReduceRules(@SqlTable) + '</result>');
			END
			-- 返回结果
			RETURN CONVERT(XML, '<result id="1">' +
				'<sentence>' + dbo.XMLEscape(@SqlSentence) + '</sentence>' + dbo.FormatReduceRules(@SqlTable) + '</result>');
		END

		--------------------------------------------------------------------------------
		--
		-- 获得简化后的规则。
		--
		--------------------------------------------------------------------------------
		-- 获得简化后的规则
		SET @SqlRule = @SqlResult.value('(//result/rule/text())[1]', 'nvarchar(max)');
		-- 检查结果
		IF @SqlRule IS NULL AND LEN(@SqlRule) <= 0
		BEGIN
			-- 返回结果
			RETURN CONVERT(XML, '<result id="-9">fail to reduce' + dbo.FormatReduceRules(@SqlTable) + '</result>');
		END
	END
	-- 返回结果
	RETURN CONVERT(XML, '<result id="-10">something cannot be reduced' + dbo.FormatReduceRules(@SqlTable) + '</result>');
END
GO
