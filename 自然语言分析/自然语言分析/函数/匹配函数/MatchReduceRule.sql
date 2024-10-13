USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[GetMatchedRule]    Script Date: 2020/12/7 9:56:14 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月7日>
-- Description:	<获得可以匹配的化简规则>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[MatchReduceRule]
(
	-- Add the parameters for the function here
	@SqlRule UString
)
RETURNS UString
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlCount INT;
	DECLARE @SqlReduce UString;
	DECLARE @SqlAbbreviation UString;

	-- 检查参数
	IF @SqlRule IS NULL OR
		LEN(@SqlRule) <= 0 RETURN NULL;
	
	-- 获得缩写
	SET @SqlCount = dbo.GetVarCount(@SqlRule);
	SET @SqlAbbreviation = dbo.ClearParameters(@SqlRule);
	-- 查询结果
	/*
	SELECT TOP 1 @SqlReduce = [rule]
	FROM dbo.ParseRule
	WHERE [rule] <> @SqlRule AND
	(
		([classification] = '单句' AND CHARINDEX(abbreviation, @SqlAbbreviation) = 1)
		OR
		([classification] <> '单句' AND CHARINDEX(abbreviation, @SqlAbbreviation) >= 1)
	)
	AND parameter_count <= @SqlCount AND [classification] IS NOT NULL
	ORDER BY dbo.GetParseRuleLevel([classification]),
	minimum_length DESC, static_suffix DESC, static_prefix DESC, parameter_count DESC, controllable_priority DESC;
	*/
	SELECT TOP 1 @SqlReduce = [rule]
	FROM
	(
		-- 先选出部分内容，避免全局计算
		SELECT [rule], classification, abbreviation, dbo.GetParseRuleLevel([classification]) AS [level], 
			minimum_length, static_suffix, static_prefix, parameter_count, controllable_priority FROM dbo.ParseRule
			WHERE [rule] <> @SqlRule AND parameter_count <= @SqlCount AND [classification] IS NOT NULL
	) AS t
	WHERE
	(
		([classification] = '单句' AND CHARINDEX(abbreviation, @SqlAbbreviation) = 1)
		OR
		([classification] <> '单句' AND CHARINDEX(abbreviation, @SqlAbbreviation) >= 1)
	)
	ORDER BY [level], minimum_length DESC, static_suffix DESC, static_prefix DESC, parameter_count DESC, controllable_priority DESC;
	-- 返回结果
	RETURN @SqlReduce;
END
GO
