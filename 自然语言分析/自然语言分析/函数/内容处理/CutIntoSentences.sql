USE [nldb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年2月5日>
-- Description:	<将文本切分成句子>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[CutIntoSentences]
(
	-- Add the parameters for the function here
	@SqlText UString
)
RETURNS XML
AS
BEGIN

	-- 声明临时变量
	DECLARE @SqlXML XML;
	DECLARE @SqlResult INT;
	DECLARE @SqlExpressions XML;
	DECLARE @SqlContent UString;

	DECLARE @SqlID INT = 0;
	DECLARE @SqlEID INT = 0;
	DECLARE @SqlFilters XML;
	DECLARE @SqlRegulars XML;
	DECLARE @SqlValue UString;

	-- 检查参数
	IF @SqlText IS NULL
		OR LEN(@SqlText) <= 0
		RETURN CONVERT(XML, '<result id="-1">text is null</result>');

	-- 加载所有过滤规则
	SET @SqlFilters = dbo.LoadFilterRules();
	-- 检查结果
	IF @SqlFilters IS NULL
		RETURN CONVERT(XML, '<result id="-2">filters is null</result>');

	-- 加载所有正则规则
	SET @SqlRegulars = dbo.LoadRegularRules();
	-- 检查结果
	IF @SqlRegulars IS NULL
		RETURN CONVERT(XML, 'result id="-3">fail to load rules</result>');

	-- 设置初始值
	SET @SqlValue = '';
	-- 对原始内容进行预处理
	-- 先执行转义
	SET @SqlText = dbo.XMLUnescape(@SqlText);
	-- 替换多余的标点
	SET @SqlText = dbo.FilterContent(@SqlFilters, @SqlText);

	-- 循环处理
	WHILE @SqlText IS NOT NULL AND LEN(@SqlText) > 0
	BEGIN
		-- 提取所有正则表达式
		SET @SqlExpressions = dbo.ExtractExpressions(@SqlRegulars, @SqlText);

		-- 剪除无效字符
		SET @SqlText = dbo.LeftTrim(@SqlText);
		-- 检查结果
		IF @SqlText IS NULL OR LEN(@SqlText) <= 0
		BEGIN
			-- 设置错误信息
			SET @SqlResult = 0;/*无内容可以继续解析*/ BREAK;
		END

		-- 直接切分句子
		SET @SqlXML = dbo.XMLCutSentence(@SqlText, @SqlExpressions);
		-- 检查结果
		IF @SqlXML IS NULL
		BEGIN
			-- 设置错误信息
			SET @SqlResult = -101; BREAK;
		END
		-- 获得结果
		SET @SqlResult = @SqlXML.value('(//result/@id)[1]', 'int');
		-- 检查结果
		IF @SqlResult IS NULL
		BEGIN
			-- 设置错误信息
			SET @SqlResult = -101; BREAK;
		END
		ELSE IF @SqlResult <= 0 BREAK;
		-- 获得句子
		SET @SqlContent = @SqlXML.value('(//result/sentence/text())[1]', 'nvarchar(max)');
		-- 检查结果
		IF @SqlContent IS NULL	OR LEN(@SqlContent) <= 0
		BEGIN
			-- 设置错误信息
			SET @SqlResult = -102; BREAK;
		END
			
		-- 检查长度
		IF dbo.IsTooLong(@SqlContent) = 1
		BEGIN
			-- 设置错误信息
			SET @SqlResult = -103; BREAK;
		END
		ELSE
		BEGIN
			-- 设置计数器
			SET @SqlID = @SqlID + 1;

			-- 设置初始值
			SET @SqlEID = 0;
			-- 选择结果
			SELECT TOP 1 @SqlEID = eid FROM dbo.ExternalContent WHERE content = @SqlContent;

			-- 生成XML数据
			SET @SqlValue = @SqlValue +
			'<sentence id="' + CONVERT(NVARCHAR(MAX), @SqlID) + '" ' +
			'eid="' + CONVERT(NVARCHAR(MAX), @SqlEID) + '" len="' +
			CONVERT(NVARCHAR(MAX), LEN(@SqlContent)) + '">' + dbo.XMLEscape(@SqlContent) + '</sentence>';
		END
		-- 检查结果
		IF LEN(@SqlContent) < LEN(@SqlText)
		BEGIN
			-- 截取部分
			SET @SqlText = LTRIM(RIGHT(@SqlText, LEN(@SqlText) - LEN(@SqlContent)));
		END
		ELSE
		BEGIN
			-- 设置信息并清理结果
			SET @SqlResult = 0; SET @SqlText = NULL; BREAK;
		END
	END

	-- 检查结果
	RETURN CONVERT(XML, '<result id="' + CONVERT(NVARCHAR(MAX), @SqlResult) + '">' + @SqlValue + '</result>');
END
