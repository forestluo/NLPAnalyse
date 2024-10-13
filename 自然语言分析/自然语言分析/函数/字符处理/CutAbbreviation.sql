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
-- Create date: <2021年2月20日>
-- Description:	<从原句中裁剪出部分内容>
-- =============================================

CREATE OR ALTER FUNCTION CutAbbreviation
(
	-- Add the parameters for the function here
	@SqlContent UString,
	@SqlPosition INT,
	@SqlLength INT,
	@SqlCutLength INT
)
RETURNS UString
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlEnd INT;
	DECLARE @SqlStart INT;
	DECLARE @SqlValue UString;

	-- 检查参数
	IF @SqlContent IS NULL OR 
		LEN(@SqlContent) <= 0 RETURN NULL;
	-- 检查裁剪长度
	IF @SqlCutLength < @SqlLength
		SET @SqlCutLength = 2 * @SqlLength;
	IF @SqlCutLength < 32 SET @SqlCutLength = 32;

	-- 设置开始位置
	SET @SqlStart = @SqlPosition + @SqlLength / 2 - @SqlCutLength / 2;
	-- 检查结果
	IF @SqlStart < 0 SET @SqlStart = 1;
	-- 设置结束位置
	SET @SqlEnd = @SqlPosition + @SqlLength / 2 + @SqlCutLength / 2;
	-- 检查结果
	IF @SqlEnd > LEN(@SqlContent) SET @SqlEnd = LEN(@SqlContent);
	-- 截取内容
	SET @SqlValue = SUBSTRING(@SqlContent, @SqlStart, @SqlEnd - @SqlStart + 1);
	-- 检查结果
	IF @SqlStart > 1 SET @SqlValue = '...' + @SqlValue;
	IF @SqlEnd < LEN(@SqlContent) SET @SqlValue = @SqlValue + '...';
	-- 返回结果
	RETURN @SqlValue;
END
GO

