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
-- Create date: <2021年2月26日>
-- Description:	<清理不可见字符>
-- =============================================

CREATE OR ALTER FUNCTION ClearInvisible
(
	-- Add the parameters for the function here
	@SqlContent UString
)
RETURNS UString
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlChar UChar;
	DECLARE @SqlResult UString;

	DECLARE @SqlPosition INT = 0;

	-- 检查参数
	IF @SqlContent IS NULL OR 
		LEN(@SqlContent) <= 0 RETURN NULL;

	-- 设置初始值
	SET @SqlResult = '';
	-- 循环处理
	WHILE @SqlPosition < LEN(@SqlContent)
	BEGIN
		-- 增加计数器
		SET @SqlPosition = @SqlPosition + 1;
		-- 获得字符
		SET @SqlChar = SUBSTRING(@SqlContent, @SqlPosition, 1);
		-- 检测结果
		IF dbo.IsInvisible(@SqlChar) = 0 SET @SqlResult = @SqlResult + @SqlChar;
	END
	-- 返回结果
	RETURN @SqlResult;
END
GO

