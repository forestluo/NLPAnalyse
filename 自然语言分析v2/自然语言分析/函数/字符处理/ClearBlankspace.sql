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
-- Create date: <2020年12月19日>
-- Description:	<清理空格类型字符>
-- =============================================

CREATE OR ALTER FUNCTION ClearBlankspace
(
	-- Add the parameters for the function here
	@SqlContent UString,
	@SqlReplace UString = NULL
)
RETURNS UString
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlChar UChar;
	DECLARE @SqlResult UString;

	DECLARE @SqlPosition INT;

	-- 检查参数
	IF @SqlContent IS NULL OR 
		LEN(@SqlContent) <= 0 RETURN NULL;
	-- 检查参数
	SET @SqlReplace = ISNULL(@SqlReplace, '');

	-- 设置初始值
	SET @SqlResult = '';
	SET @SqlPosition = 0;
	-- 循环处理
	WHILE @SqlPosition < LEN(@SqlContent)
	BEGIN
		-- 增加计数器
		SET @SqlPosition = @SqlPosition + 1;
		-- 获得左侧第一个字符
		SET @SqlChar = SUBSTRING(@SqlContent, @SqlPosition, 1);
		-- 检测结果
		SET @SqlResult = @SqlResult +
			CASE
				WHEN dbo.IsBlankspace(@SqlChar) <= 0 THEN @SqlChar ELSE @SqlReplace
			END;
	END
	-- 返回结果
	RETURN @SqlResult;
END
GO

