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
-- Create date: <2020年12月12日>
-- Description:	<剪裁左侧的无效字符>
-- =============================================

CREATE OR ALTER FUNCTION LeftTrim
(
	-- Add the parameters for the function here
	@SqlContent UString
)
RETURNS UString
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlChar UChar;
	DECLARE @SqlPosition INT;

	-- 检查参数
	IF @SqlContent IS NULL
		OR LEN(@SqlContent) <= 0 RETURN NULL;

	-- 设置初始值
	SET @SqlPosition = 0;
	-- 循环处理
	WHILE @SqlPosition < LEN(@SqlContent)
	BEGIN
		-- 得到字符
		SET @SqlChar =
			SUBSTRING(@SqlContent,
				@SqlPosition + 1, 1);
		-- 检查字符
		IF dbo.IsPairEnd(@SqlChar) = 0 AND
			dbo.IsBlankspace(@SqlChar) = 0 AND
			dbo.IsMajorSplitter(@SqlChar) = 0 AND
			dbo.IsMinorSplitter(@SqlChar) = 0 BREAK;
		-- 设置位置
		SET @SqlPosition = @SqlPosition + 1;
	END
	-- 检查位置
	IF @SqlPosition > 0
	BEGIN
		-- 剪裁内容
		SET @SqlContent = RIGHT(@SqlContent, LEN(@SqlContent) - @SqlPosition);
	END
	-- 返回结果
	RETURN @SqlContent;
END
GO

