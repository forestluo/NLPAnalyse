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
-- Description:	<是否为中文类型字符串>
-- =============================================

CREATE OR ALTER FUNCTION IsChineseString
(
	-- Add the parameters for the function here
	@SqlContent UString
)
RETURNS INT
AS
BEGIN
	-- 定义临时变量
	DECLARE @SqlPosition INT = 0;

	-- 检查参数
	IF @SqlContent IS NULL OR
		LEN(@SqlContent) <= 0 RETURN 0;
	-- 循环处理
	WHILE @SqlPosition < LEN(@SqlContent)
	BEGIN
		-- 修改计数器
		SET @SqlPosition = @SqlPosition + 1;
		-- 检查结果
		IF dbo.IsChineseChar(SUBSTRING(@SqlContent, @SqlPosition, 1)) = 0 RETURN 0;
	END
	-- 返回结果
	RETURN 1;
END
GO

