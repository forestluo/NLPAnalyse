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
-- Create date: <2020年12月10日>
-- Description:	<获得规则的分类>
-- =============================================

CREATE OR ALTER FUNCTION ParseRuleGetClassification
(
	-- Add the parameters for the function here
	@SqlRule UString
)
RETURNS UString
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlClassification UString = NULL;
	-- 检查参数
	IF @SqlRule IS NULL
		OR LEN(@SqlRule) < = 0 RETURN NULL;
	-- 查询
	SELECT @SqlClassification = [classification]
		FROM dbo.ParseRule WHERE [rule] = @SqlRule;
	-- 返回结果
	RETURN @SqlClassification;
END
GO

