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
-- Description:	<获得可以匹配的规则>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[MatchSentenceRule]
(
	-- Add the parameters for the function here
	@SqlRule UString
)
RETURNS UString
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlCount INT;
	DECLARE @SqlAbbreviation UString;

	-- 检查参数
	IF @SqlRule IS NULL
		OR LEN(@SqlRule) <= 0 RETURN NULL;
	-- 获得参数个数
	SET @SqlCount = dbo.GetVarCount(@SqlRule);
	-- 清理参数名
	SET @SqlAbbreviation = dbo.ClearParameters(@SqlRule);
	-- 设置初始值
	SET @SqlRule = NULL;
	-- 查询数据表
	/*
	SELECT TOP 1 @SqlRule = [rule]
		FROM dbo.ParseRule
		WHERE CHARINDEX(abbreviation, @SqlAbbreviation) = 1 AND
			classification = '单句' AND parameter_count <= @SqlCount;
	*/
	SELECT TOP 1 @SqlRule = [rule]
	FROM
	(
		-- 先选出局部内容，防止全局计算
		SELECT [rule], abbreviation FROM dbo.ParseRule
			WHERE classification = '单句' AND parameter_count <= @SqlCount
	) AS t
	WHERE CHARINDEX(abbreviation, @SqlAbbreviation) = 1;
	-- 返回结果
	RETURN @SqlRule;
END
GO
