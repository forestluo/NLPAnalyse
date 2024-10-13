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
-- Create date: <2021年2月6日>
-- Description:	<获得内容的词频>
-- =============================================

CREATE OR ALTER FUNCTION GetFreqCount
(
	-- Add the parameters for the function here
	@SqlContent UString
)
RETURNS INT
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlCount INT = 0;
	-- 执行查询语句
	SELECT TOP 1 @SqlCount = [count]
		FROM dbo.Dictionary
		WHERE content = @SqlContent;
	-- 返回结果
	RETURN @SqlCount;
END
GO

