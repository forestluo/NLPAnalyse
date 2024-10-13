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
-- Create date: <2021年3月1日>
-- Description:	<获得三个词的相关系数>
-- =============================================

CREATE OR ALTER FUNCTION GetTriAlphaValue
(
	-- Add the parameters for the function here
	@SqlLeft UString,
	@SqlMiddle UString,
	@SqlRight UString
)
RETURNS FLOAT
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlValue FLOAT;
	
	DECLARE @SqlLeftCount INT;
	DECLARE @SqlRightCount INT;
	DECLARE @SqlMiddleCount INT;
	DECLARE @SqlCombinateCount INT;

	-- 检查参数
	IF @SqlLeft IS NULL OR
		LEN(@SqlLeft) <= 0 RETURN -1;
	IF @SqlMiddle IS NULL OR
		LEN(@SqlMiddle) <= 0 RETURN -1;
	IF @SqlRight IS NULL OR
		LEN(@SqlRight) <= 0 RETURN -1;

	-- 获得左侧词的概率
	SET @SqlLeftCount =
		dbo.GetFreqCount(@SqlLeft);
	-- 检查结果
	IF @SqlLeftCount <= 0 RETURN -1;
	
	-- 获得左侧词的概率
	SET @SqlMiddleCount =
		dbo.GetFreqCount(@SqlMiddle);
	-- 检查结果
	IF @SqlMiddleCount <= 0 RETURN -1;

	-- 获得右侧词的词频
	SET @SqlRightCount =
		dbo.GetFreqCount(@SqlRight);
	-- 检查结果
	IF  @SqlRightCount <= 0 RETURN -1;

	-- 获得合并词的词频
	SET @SqlCombinateCount =
		dbo.GetFreqCount(@SqlLeft + @SqlMiddle + @SqlRight);
	-- 检查加过
	IF @SqlCombinateCount <= 0 RETURN -1;

	-- 计算结果
	SET @SqlValue = @SqlLeftCount * 1.0 * @SqlMiddleCount * @SqlRightCount;
	SET @SqlValue = @SqlValue / (@SqlLeftCount * 1.0 * @SqlMiddleCount +
			@SqlLeftCount * 1.0 * @SqlRightCount + @SqlMiddleCount * 1.0 * @SqlRightCount);
	SET @SqlValue = @SqlValue / @SqlCombinateCount;
	-- 返回结果
	RETURN 3.0 * @SqlValue;
END
GO

