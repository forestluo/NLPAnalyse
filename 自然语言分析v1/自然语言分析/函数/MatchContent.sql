USE [nldb]
GO

/****** Object:  StoredProcedure [dbo].[XMLParseSentence]    Script Date: 2020/12/6 20:01:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年11月30日>
-- Description:	<按照整体进行匹配>
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[MatchContent]
(
	-- Add the parameters for the stored procedure here
	@SqlContent UString
)
RETURNS XML
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlRID INT;
	DECLARE @SqlResult XML;
	DECLARE @SqlRule UString;
	DECLARE @SqlRemark UString;
	DECLARE @SqlClassification UString;

	-- 剪裁文本行
	SET @SqlContent = TRIM(@SqlContent);
	-- 检查结果
	IF @SqlContent IS NULL OR LEN(@SqlContent) <= 0
		RETURN CONVERT(XML, '<result id="-1">input is null</result>');
	-- 获得规则
	SET @SqlRule = dbo.GetParseRule(@SqlContent);
	-- 检查结果
	IF @SqlRule IS NULL OR LEN(@SqlRule) <= 0
		RETURN CONVERT(XML, '<result id="-2">fail to get parse rule</result>');
	-- 设置初始值
	SET @SqlRID = dbo.GetParseRuleID(@SqlRule);
	-- 检查结果
	IF @SqlRID <= 0
		RETURN CONVERT(XML, '<result id="-3">fail to get parse rule id</result>');
	-- PRINT '开始尝试匹配（' + CONVERT(NVARCHAR(MAX),@SqlRID) + ',"' + @SqlRule + '"）！';

	-- 解析XML
	SET @SqlResult = CONVERT(XML, @SqlRemark);
	-- 检查结果
	IF @SqlResult IS NOT NULL
	BEGIN
		-- 解析内容
		SET @SqlResult = dbo.XMLParseContent(@SqlResult, @SqlContent, 0);
		-- PRINT CONVERT(NVARCHAR(MAX), @SqlResult);
		-- 检查结果
		IF @SqlResult IS NOT NULL AND
			ISNULL(@SqlResult.value('(//result/@id)[1]','int'), 0) = 1 AND
			ISNULL(@SqlResult.value('(//result/@start)[1]','int'), 0) = 1 AND
			ISNULL(@SqlResult.value('(//result/@end)[1]','int'), 0) = LEN(@SqlContent) + 1
		BEGIN
			-- 增加属性
			SET @SqlResult.modify('insert (attribute rid {sql:variable("@SqlRID")}) into ((//result[position()=1])[1])');
			SET @SqlResult.modify('insert (attribute class {sql:variable("@SqlClassification")}) into ((//result[position()=1])[1])');
		END
	END
	-- 返回结果
	RETURN @SqlResult;
END
GO

