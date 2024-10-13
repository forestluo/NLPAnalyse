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
-- Create date: <2020年12月13日>
-- Description:	<从结果集中获得句子>
-- =============================================

CREATE OR ALTER FUNCTION GetResultSentence
(
	-- Add the parameters for the function here
	@SqlResult XML,
	@SqlRule UString
)
RETURNS UString
AS
BEGIN
	-- 声明变量
	DECLARE @SqlIndex INT;
	DECLARE @SqlCount INT;
	DECLARE @SqlName UChar;
	DECLARE @SqlValue UString;
	DECLARE @SqlSentence UString;

	-- 检查参数
	IF @SqlResult IS NULL
		RETURN NULL;
	IF @SqlRule IS NULL OR
		LEN(@SqlRule) <= 0 RETURN NULL;
	
	-- 获得参数个数
	SET @SqlCount = dbo.GetVarCount(@SqlRule);
	-- 检查结果
	IF @SqlCount <= 0 OR @SqlCount > 26 SET @SqlCount = 26;
	-- 设置初始值
	SET @SqlIndex = 0;
	SET @SqlSentence = @SqlRule;
	-- 循环处理
	WHILE @SqlIndex < @SqlCount
	BEGIN
		-- 修改计数器
		SET @SqlIndex = @SqlIndex + 1;
		-- 获得参数名
		SET @SqlName = dbo.GetLowercase(@SqlIndex);
		-- 获得参数值
		SET @SqlValue = @SqlResult.value('(//result/var[@name=sql:variable("@SqlName")]/text())[1]', 'nvarchar(max)');
		-- 检查结果
		IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
		BEGIN
			-- 设置结果
			SET @SqlSentence = REPLACE(@SqlSentence, '$' + dbo.GetLowercase(@SqlIndex), @SqlValue);
		END
	END
	-- 返回结果
	RETURN @SqlSentence;
END
GO

