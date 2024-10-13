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
-- Create date: <2021年3月10日>
-- Description:	<是否为有效的字符串>
-- =============================================

CREATE OR ALTER FUNCTION GrammarIsInvalid
(
	-- Add the parameters for the function here
	@SqlContent UString
)
RETURNS INT
AS
BEGIN
	-- 检查结果
	IF LEN(@SqlContent) <= 1
		RETURN 0;
	ELSE IF LEN(@SqlContent) = 2
	BEGIN
		-- 返回检查结果
		IF EXISTS (SELECT gid FROM dbo.Grammar2
		WHERE content = @SqlContent AND (invalid = 1 AND enable = 0)) RETURN 1;
	END
	ELSE IF LEN(@SqlContent) = 3
	BEGIN
		-- 返回检查结果
		IF EXISTS (SELECT gid FROM dbo.Grammar3
		WHERE content = @SqlContent AND (invalid = 1 AND enable = 0)) RETURN 1;
	END
	ELSE IF LEN(@SqlContent) = 4
	BEGIN
		-- 返回检查结果
		IF EXISTS (SELECT gid FROM dbo.Grammar4
		WHERE content = @SqlContent AND (invalid = 1 AND enable = 0)) RETURN 1;
	END
	-- 返回无效
	RETURN -1;
END
GO

