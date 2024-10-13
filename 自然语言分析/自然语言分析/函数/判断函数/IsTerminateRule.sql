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
-- Create date: <2020��12��19��>
-- Description:	<�Ƿ�Ϊ�ս�ParseRule>
-- =============================================

CREATE OR ALTER FUNCTION IsTerminateRule
(
	-- Add the parameters for the function here
	@SqlRule UString
)
RETURNS INT
AS
BEGIN
	-- ���ؽ��
	RETURN CASE @SqlRule
		WHEN '$a' THEN 1
		WHEN '$a��' THEN 1
		WHEN '$a��' THEN 1
		ELSE 0 END;
END
GO

