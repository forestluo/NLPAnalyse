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
-- Author:		<�ވ�>
-- Create date: <2021��3��10��>
-- Description:	<�Ƿ�Ϊ��Ч���ַ���>
-- =============================================

CREATE OR ALTER FUNCTION GrammarIsInvalid
(
	-- Add the parameters for the function here
	@SqlContent UString
)
RETURNS INT
AS
BEGIN
	-- �����
	IF LEN(@SqlContent) <= 1
		RETURN 0;
	ELSE IF LEN(@SqlContent) = 2
	BEGIN
		-- ���ؼ����
		IF EXISTS (SELECT gid FROM dbo.Grammar2
		WHERE content = @SqlContent AND (invalid = 1 AND enable = 0)) RETURN 1;
	END
	ELSE IF LEN(@SqlContent) = 3
	BEGIN
		-- ���ؼ����
		IF EXISTS (SELECT gid FROM dbo.Grammar3
		WHERE content = @SqlContent AND (invalid = 1 AND enable = 0)) RETURN 1;
	END
	ELSE IF LEN(@SqlContent) = 4
	BEGIN
		-- ���ؼ����
		IF EXISTS (SELECT gid FROM dbo.Grammar4
		WHERE content = @SqlContent AND (invalid = 1 AND enable = 0)) RETURN 1;
	END
	-- ������Ч
	RETURN -1;
END
GO

